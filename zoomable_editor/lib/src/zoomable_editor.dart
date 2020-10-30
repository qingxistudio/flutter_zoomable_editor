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
      });

  final Widget child;
  final double editorWidth;
  final double editorHeight;
  final double contentWidth;
  final double contentHeight;
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

  @override
  void initState() {
    _transformationController = TransformationController(widget.zoomableController.transformMatrix);
    super.initState();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    _startGlobalFocalPoint = details.localFocalPoint;
    _startOffset = widget.zoomableController.offset;
    _startScale = widget.zoomableController.scale;

    print('$_startGlobalFocalPoint,$_startOffset,$_startScale');
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    final offsetDelta = -(details.localFocalPoint - _startGlobalFocalPoint);
    print('$offsetDelta,${widget.zoomableController.scale},${widget.zoomableController.offset}');

    widget.zoomableController.scale = _startScale * details.scale;
    widget.zoomableController.offset = _startOffset + offsetDelta * widget.zoomableController.scale;

    print('after ${widget.zoomableController.scale},${widget.zoomableController.offset}');
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    // Nothing to do.
  }

  Size editorContentFitDisplaySize() {
    const showEdgeFactor = 0.6;
    final editorRatio = widget.editorWidth / widget.editorHeight;
    final contentRatio = widget.contentWidth / widget.contentHeight;
    if (editorRatio > contentRatio) {
      final h = widget.editorHeight * showEdgeFactor;
      return Size(h * contentRatio, h);
    } else {
      final w = widget.editorWidth * showEdgeFactor;
      return Size(w, w / contentRatio);
    }
  }

  Widget createEdgeMask() {
        final topBottomMask = ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) {
          final topStop = _insets.top/bounds.height;
          final bottomStop = 1-_insets.bottom/bounds.height;
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0,topStop,topStop,bottomStop,bottomStop,1],
            colors: [maskColor, maskColor, transparentColor, transparentColor, maskColor, maskColor],
          ).createShader(Rect.fromLTRB(_insets.left, 0, bounds.right-_insets.right, bounds.bottom));
        },
        child: stack,
      );

    final maskContainer = ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) {
          final leftStop = _insets.left/bounds.width;
          final rightStop = 1-_insets.right/bounds.width;
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [
              0,
              leftStop,
              leftStop,
              rightStop,
              rightStop,
              1],
            colors: [maskColor, maskColor, transparentColor, transparentColor, maskColor, maskColor],
          ).createShader(bounds);
      },
      child:topBottomMask
    );

    return maskContainer;
  }

  @override
  Widget build(BuildContext context) {

    final editorContentDisplaySize = editorContentFitDisplaySize();

    final interactiveViewer = InteractiveViewer(
      child: Center(
        child: Container(
          color: Colors.red,
          width: widget.contentWidth,
          height: widget.contentHeight,
        ),
      ),
      scaleEnabled: widget.zoomableController.scaleEnabled,
      panEnabled: widget.zoomableController.transitionEnabled,
      transformationController: _transformationController,
      onInteractionStart: _onInteractionStart,
      onInteractionUpdate: _onInteractionUpdate,
      onInteractionEnd: _onInteractionEnd,
      minScale: widget.zoomableController.minScale,
      maxScale: widget.zoomableController.maxScale,
    );

    // return Container(color: Colors.amberAccent,);

    return Card(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Colors.black87,
                child: Stack(
                  children: [
                    Center(
                      child: _ZoomableContainerBuilder(
                        widget.child,
                        widget.zoomableController,
                        contentWidth: widget.contentWidth,
                        contentHeight: widget.contentHeight,
                        displayWidth: widget.targetWidth,
                        displayHeight: widget.targetHeight,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: interactiveViewer,
                    )
                  ],
                )
              ),
              // Expanded(...)
            ],
          ),
        )
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
      clipToBounds: true,
    );
    return zoomContainer;
  }

}
