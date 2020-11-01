import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zoomable_editor/src/zoomable_container.dart';

part 'zoomable_editor_controller.part.dart';
part 'zoomable_editor_container.part.dart';
part 'zoomable_editor_control.part.dart';

class ZoomableEditor extends StatefulWidget {

  const ZoomableEditor(
      this.child,
      this.zoomableController,
      {
        @required this.editorSize,
        @required this.contentSize,
        this.displayWHRatio,
        this.contentInsets,
      }): assert(editorSize != null), assert(contentSize != null);

  /// [child] The content to zoom
  final Widget child;
  /// [editorSize] Size for the editor container
  final Size editorSize;
  /// [contentSize] Size of the content to scale and move
  final Size contentSize;
  /// [displayWHRatio] default value is [contentWidth] / [contentHeight]
  final double displayWHRatio;
  /// [contentInsets] Custom the content display insets in the editor
  final EdgeInsets contentInsets;
  /// [zoomableController] Control the sale and offset of the content
  final ZoomableController zoomableController;

  double get contentWidth => contentSize.width;
  double get contentHeight => contentSize.height;
  double get editorWidth => editorSize.width;
  double get editorHeight => editorSize.height;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableEditorState();
  }
}

class _ZoomableEditorState extends State<ZoomableEditor> {

  Offset _startGlobalFocalPoint;
  Offset _startOffset;
  double _startScale;

  double _contentDisplayScale;
  // BouncingScrollPhysics _bouncingScrollPhysics;
  _DoubleTapRecognizer _doubleTapRecognizer;

  /// Display Size : 400 * 400,
  /// Content Size : 800 * 1000, Fit Size: 400 * 500
  /// [allowOffsetInContentWithScale] will be Offset(0, 50)
  /// Allow from Offset(0, -50) to Offset(0, 100)
  Offset allowOffsetInContentWithScale() {

    final contentDisplaySize = editorContentFitDisplaySize();
    final curScale = widget.zoomableController.scale;
    final allowOffsetX = (widget.contentWidth * curScale - contentDisplaySize.width / _contentDisplayScale) / 2;
    final allowOffsetY = (widget.contentHeight * curScale - contentDisplaySize.height / _contentDisplayScale) / 2;
    return Offset(allowOffsetX, allowOffsetY);
  }

  @override
  void initState() {
    if (widget.zoomableController.doubleTapEnabled) {
      _doubleTapRecognizer = _DoubleTapRecognizer((){
        final scale = widget.zoomableController.scale;
        final fromTransform = widget.zoomableController.transformMatrix;
        if (scale == widget.zoomableController.minScale) {
          widget.zoomableController.updateScale(widget.zoomableController.maxScale, notify: false);
        } else {
          widget.zoomableController.updateScale(widget.zoomableController.minScale, notify: false);
        }
        widget.zoomableController.updateOffset(Offset.zero, notify: false);
        widget.zoomableController.notifyChange(animated: true, fromTransfrom: fromTransform);
      });
    }
    // _bouncingScrollPhysics = BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
    super.initState();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _doubleTapRecognizer?.addDownEvent(details.focalPoint);

    _startGlobalFocalPoint = details.focalPoint;
    _startOffset = widget.zoomableController.offset;
    _startScale = widget.zoomableController.scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    _doubleTapRecognizer?.updateCurrentOffset(details.focalPoint);

    final offsetDelta = -(details.focalPoint - _startGlobalFocalPoint);
    final newScale = _startScale * details.scale;
    final newOffset = _startOffset - offsetDelta / widget.zoomableController.scale / _contentDisplayScale;
    widget.zoomableController.updateScale(newScale);
    widget.zoomableController.updateOffset(newOffset);
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final fromTransform = widget.zoomableController.transformMatrix;
    final newScale = widget.zoomableController.scale.clamp(
        widget.zoomableController.minScale, widget.zoomableController.maxScale).toDouble();

    /// limit scale to avoid out of bound
    widget.zoomableController.updateScale(newScale, notify: false);

    final curOffset = widget.zoomableController.offset;
    final allowOffset = allowOffsetInContentWithScale() / newScale;
    final dx = (curOffset.dx).clamp(-allowOffset.dx.abs(), allowOffset.dx.abs()).toDouble();
    final dy = (curOffset.dy).clamp(-allowOffset.dy.abs(), allowOffset.dy.abs()).toDouble();

    /// limit offset to avoid out of bound
    widget.zoomableController.updateOffset(Offset(dx, dy), notify: false);
    widget.zoomableController.notifyChange(animated: true, fromTransfrom: fromTransform);

    _startGlobalFocalPoint = null;
    _startScale = null;
    _startOffset = null;

    _doubleTapRecognizer?.addEndEvent();
  }

  Size editorContentFitDisplaySize() {
    final editorWHRatio = widget.editorWidth / widget.editorHeight;
    final contentOriginWHRatio = widget.contentWidth / widget.contentHeight;
    final contentDisplayWHRatio = widget.displayWHRatio ?? contentOriginWHRatio;
    Size displaySize;
    if (widget.contentInsets != null) {
      displaySize = Size(widget.editorWidth - widget.contentInsets.horizontal, widget.editorHeight - widget.contentInsets.vertical);
    } else {
      const showEdgeFactor = 0.8;
      if (editorWHRatio > contentDisplayWHRatio) {
        final h = widget.editorHeight * showEdgeFactor;
        displaySize = Size(h * contentDisplayWHRatio, h);
      } else {
        final w = widget.editorWidth * showEdgeFactor;
        displaySize = Size(w, w / contentDisplayWHRatio);
      }
    }
    if (contentDisplayWHRatio > contentOriginWHRatio) {
      _contentDisplayScale =  displaySize.width / widget.contentWidth;
    } else {
      _contentDisplayScale =  displaySize.height / widget.contentHeight;
    }
    return displaySize;
  }

  EdgeInsets editorEdgeInsets() {
    if (widget.contentInsets != null) {
      return widget.contentInsets;
    }
    final size = editorContentFitDisplaySize();
    final left = (widget.editorWidth - size.width) / 2;
    final top = (widget.editorHeight - size.height) / 2;
    final edgeInsets = EdgeInsets.fromLTRB(left, top, left, top);
    return edgeInsets;
  }

  Widget createEdgeMaskWithChild({@required Widget child}) {
    final edgeInsets = editorEdgeInsets();
    final maskColor = Colors.white.withOpacity(0.4);
    return Container(
      child: child,
      foregroundDecoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: edgeInsets.right,
            color: maskColor,
          ),
          left: BorderSide(
            width: edgeInsets.left,
            color: maskColor,
          ),
          bottom: BorderSide(
            width: edgeInsets.bottom,
            color: maskColor,
          ),
          top: BorderSide(
            width: edgeInsets.top,
            color: maskColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final contentDisplaySize = editorContentFitDisplaySize();
    final insets = editorEdgeInsets();

    final editorCanvasWidget = createEdgeMaskWithChild(child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 0)
      ),
      width: widget.editorWidth,
      height: widget.editorHeight,
      child: Container(
          padding: insets,
          child: Container(
              foregroundDecoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              ),
              child: _ZoomableContainerBuilder(
                widget.child,
                widget.zoomableController,
                contentSize: widget.contentSize,
                displaySize: contentDisplaySize,
              )
            )
      ),
    ));

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: editorCanvasWidget,
    );
  }
}

/// Timeout to recognize as a tap
const kTapTimeout = 250;
/// Max offset distance to recognize as a tap
const kTapMaxDistance = 18;

class _DoubleTapRecognizer {

  _DoubleTapRecognizer(this.onDoubleTap): assert(onDoubleTap != null);

  final VoidCallback onDoubleTap;

  int _tapCount = 0;
  int _lastTapTimestamp;
  int _downTimestamp;

  Offset _startOffset;
  Offset _currentOffset;


  void addDownEvent(Offset startOffset) {
    _downTimestamp = DateTime.now().millisecondsSinceEpoch;
    _startOffset = startOffset;
    _currentOffset = null;
  }

  void updateCurrentOffset(Offset offset) {
    _currentOffset = offset;
  }

  void addEndEvent() {
    if (_downTimestamp == null || _startOffset == null) {
      assert(false);
      cancel();
      return;
    }
    final nowTS = DateTime.now().millisecondsSinceEpoch;
    if (nowTS - _downTimestamp > kTapTimeout
        || (_currentOffset != null && (_currentOffset - _startOffset).distance > kTapMaxDistance)) {
      cancel();
    } else {
      if (_tapCount == 0) {
        _tapCount = 1;
        _lastTapTimestamp = nowTS;
      } else {
        if (nowTS - _lastTapTimestamp > kTapTimeout) {
          cancel();
        } else {
          onDoubleTap();
          reset();
        }
      }
    }
  }

  void cancel() {
    _tapCount = 0;
    _lastTapTimestamp = null;
    _downTimestamp = null;

    _startOffset = null;
    _currentOffset = null;
  }

  void reset() => cancel();

}
