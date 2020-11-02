part of 'zoomable_editor.dart';


class _ZoomableContentBuilder extends StatefulWidget {

  const _ZoomableContentBuilder(
      this.child,
      this.zoomableController,
      {
        this.displaySize,
        this.contentSize,
      });

  /// [child] The content to show with transform
  final Widget child;
  /// [displaySize] Size for the editor container
  final Size displaySize;
  /// [contentSize] Size of the content to scale and move
  final Size contentSize;
  final ZoomableController zoomableController;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableContentBuilderState();
  }
}

class _ZoomableContentBuilderState extends State<_ZoomableContentBuilder> {

  bool animated = false;
  Matrix4 from;
  Matrix4 to;

  @override
  void initState() {
    widget.zoomableController.addListener(_onZoomChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.zoomableController.removeListener(_onZoomChange);
    super.dispose();
  }

  void _onZoomChange() {
    final newState = widget.zoomableController.value;
    animated = newState.animated;
    from = newState.from;
    to = newState.to;
  }

  @override
  Widget build(BuildContext context) {
    final zoomContainer = ZoomableContainer(
      widget.child,
      contentSize: widget.contentSize,
      displaySize: widget.displaySize,
      fromTransform: animated ? from : null,
      transform: widget.zoomableController.transformMatrix,
      clipToBounds: false,
    );
    return zoomContainer;
  }
}
