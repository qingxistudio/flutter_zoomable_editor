part of 'zoomable_editor.dart';


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
