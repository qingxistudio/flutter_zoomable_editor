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
      });

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

  TransformationController _transformationController;
  Offset _startGlobalFocalPoint;
  Offset _startOffset;
  double _startScale;

  double _contentDisplayScale;
  BouncingScrollPhysics _bouncingScrollPhysics;

  /// Display Size : 400 * 400,
  /// Content Size : 800 * 1000, Fit Size: 400 * 500
  /// [initialAllowOffsetInEditor] will be Offset(0, 100)
  /// Allow from Offset(0, -100) to Offset(0, 100)
  Offset initialAllowOffsetInEditor;

  @override
  void initState() {
    _transformationController = TransformationController();
    _bouncingScrollPhysics = BouncingScrollPhysics();
    super.initState();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startGlobalFocalPoint = details.focalPoint;
    _startOffset = widget.zoomableController.offset;
    _startScale = widget.zoomableController.scale;

    print('$_startGlobalFocalPoint,$_startOffset,$_startScale');
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final offsetDelta = -(details.focalPoint - _startGlobalFocalPoint);
    print('$offsetDelta,${widget.zoomableController.scale},${widget.zoomableController.offset}');

    widget.zoomableController.scale = _startScale * details.scale;
    widget.zoomableController.offset = _startOffset + offsetDelta / widget.zoomableController.scale / _contentDisplayScale;

    print('after ${widget.zoomableController.scale},${widget.zoomableController.offset}');
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final list = ListView();
    // Nothing to do.
  }

  Size editorContentFitDisplaySize() {
    const showEdgeFactor = 0.8;
    final editorWHRatio = widget.editorWidth / widget.editorHeight;
    final contentOriginWHRatio = widget.contentWidth / widget.contentHeight;
    final contentDisplayWHRatio = widget.displayWHRatio ?? contentOriginWHRatio;
    Size displaySize;

    if (editorWHRatio > contentDisplayWHRatio) {
      final h = widget.editorHeight * showEdgeFactor;
      displaySize = Size(h * contentDisplayWHRatio, h);
    } else {
      final w = widget.editorWidth * showEdgeFactor;
      displaySize = Size(w, w / contentDisplayWHRatio);
    }
    if (contentDisplayWHRatio > contentOriginWHRatio) {
      _contentDisplayScale =  displaySize.width / widget.contentWidth;
      initialAllowOffsetInEditor = Offset(0, widget.contentHeight * _contentDisplayScale - displaySize.height);
    } else {
      _contentDisplayScale =  displaySize.height / widget.contentHeight;
      initialAllowOffsetInEditor = Offset(widget.contentWidth * _contentDisplayScale - displaySize.width, 0);
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
        child: _ZoomableContainerBuilder(
                        widget.child,
                        widget.zoomableController,
                        contentWidth: widget.contentWidth,
                        contentHeight: widget.contentHeight,
                        displayWidth: contentDisplaySize.width,
                        displayHeight: contentDisplaySize.height,
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

  @override
  void initState() {
    widget.zoomableController.onChanged = () {
      setState(() {});
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
      transform: widget.zoomableController.transformMatrix,
      clipToBounds: false,
    );
    return zoomContainer;
  }

}
