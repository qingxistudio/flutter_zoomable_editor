import 'package:flutter/material.dart';
import 'package:zoomable_editor/src/zoomable_container.dart';

part 'zoomable_editor_controller.part.dart';

class ZoomableEditor extends StatefulWidget {

  const ZoomableEditor(
      this.child,
      this.zoomableController,
      {
        @required this.editorWidth,
        @required this.editorHeight,
        @required this.contentWidth,
        @required this.contentHeight,
        this.displayWHRatio,
        this.contentInsets,
      }): assert(editorWidth != null), assert(editorHeight != null), assert(contentWidth != null), assert(contentHeight != null);

  final Widget child;
  final double editorWidth;
  final double editorHeight;
  final double contentWidth;
  final double contentHeight;
  final double displayWHRatio;
  final EdgeInsets contentInsets;
  final ZoomableController zoomableController;

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

  /// Display Size : 400 * 400,
  /// Content Size : 800 * 1000, Fit Size: 400 * 500
  /// [allowOffsetInContentWithScale] will be Offset(0, 50)
  /// Allow from Offset(0, -50) to Offset(0, 100)
  Offset allowOffsetInContentWithScale() {

    final contentDisplaySize = editorContentFitDisplaySize();
    print('_contentDisplayScale $_contentDisplayScale contentDisplaySize $contentDisplaySize');
    final curScale = widget.zoomableController.scale;
    final allowOffsetX = (widget.contentWidth * curScale - contentDisplaySize.width / _contentDisplayScale) / 2;
    final allowOffsetY = (widget.contentHeight * curScale - contentDisplaySize.height / _contentDisplayScale) / 2;
    return Offset(allowOffsetX, allowOffsetY);
  }

  @override
  void initState() {
    // _bouncingScrollPhysics = BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
    super.initState();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startGlobalFocalPoint = details.focalPoint;
    _startOffset = widget.zoomableController.offset;
    _startScale = widget.zoomableController.scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final offsetDelta = -(details.focalPoint - _startGlobalFocalPoint);
    final newScale = _startScale * details.scale;
    final newOffset = _startOffset + offsetDelta / widget.zoomableController.scale / _contentDisplayScale;
    widget.zoomableController.updateScale(newScale);
    widget.zoomableController.updateOffset(newOffset);
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final fromTransform = widget.zoomableController.transformMatrix;
    final newScale = widget.zoomableController.scale.clamp(widget.zoomableController.minScale, widget.zoomableController.maxScale).toDouble();
    /// limit scale to avoid out of bound
    widget.zoomableController.updateScale(newScale, notify: false);

    final curOffset = widget.zoomableController.offset;
    final allowOffset = allowOffsetInContentWithScale() / newScale;
    print('allowOffset: $allowOffset, curOffset $curOffset');
    final dx = (curOffset.dx).clamp(-allowOffset.dx.abs(), allowOffset.dx.abs()).toDouble();
    final dy = (curOffset.dy).clamp(-allowOffset.dy.abs(), allowOffset.dy.abs()).toDouble();
    /// limit offset to avoid out of bound
    widget.zoomableController.updateOffset(Offset(dx, dy), notify: false);
    widget.zoomableController.notifyChange(animated: true, fromTransfrom: fromTransform);
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
    final scaleFactor = widget.zoomableController.scale;
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
                contentWidth: widget.contentWidth,
                contentHeight: widget.contentHeight,
                displayWidth: contentDisplaySize.width,
                displayHeight: contentDisplaySize.height,
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

class _ZoomableContainerBuilder extends StatefulWidget {

  const _ZoomableContainerBuilder(
      this.child,
      this.zoomableController,
      {
        @required this.displayWidth,
        @required this.displayHeight,
        @required this.contentWidth,
        @required this.contentHeight,
      });

  final Widget child;
  final ZoomableController zoomableController;
  final double displayWidth;
  final double displayHeight;
  final double contentWidth;
  final double contentHeight;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableContainerBuilderState();
  }
}

class _ZoomableContainerBuilderState extends State<_ZoomableContainerBuilder> {

  bool animated = false;
  Matrix4 from;
  Matrix4 to;

  @override
  void initState() {
    widget.zoomableController.onChanged = ({bool animated, Matrix4 from, Matrix4 to}) {
      setState(() {
        this.animated = animated;
        this.from = from;
        this.to = to;
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final zoomContainer = ZoomableContainer(
      widget.child,
      contentWidth: widget.contentWidth,
      contentHeight: widget.contentHeight,
      displayWidth: widget.displayWidth,
      displayHeight: widget.displayHeight,
      fromTransform: animated ? from : null,
      transform: widget.zoomableController.transformMatrix,
      clipToBounds: false,
    );
    return zoomContainer;
  }

}
