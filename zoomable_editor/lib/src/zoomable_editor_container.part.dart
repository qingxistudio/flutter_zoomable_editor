part of 'zoomable_editor.dart';


class _ZoomableContainerBuilder extends StatefulWidget {

  const _ZoomableContainerBuilder(
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
    return _ZoomableContainerBuilderState();
  }
}

class _ZoomableContainerBuilderState extends State<_ZoomableContainerBuilder> {

  bool animated = false;
  Matrix4 from;
  Matrix4 to;

  @override
  void initState() {
    widget.zoomableController._onChangedInternal = ({bool animated, Matrix4 from, Matrix4 to}) {
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
      contentSize: widget.contentSize,
      displaySize: widget.displaySize,
      fromTransform: animated ? from : null,
      transform: widget.zoomableController.transformMatrix,
      clipToBounds: false,
    );
    return zoomContainer;
  }

}
