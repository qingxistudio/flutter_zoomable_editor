part of 'zoomable_editor.dart';

class _ZoomableEditRectContainer extends StatefulWidget {

  const _ZoomableEditRectContainer(
      this.child,
      this.zoomableController,
      {
        @required this.insets,
      });

  final Widget child;
  final EdgeInsets insets;
  final ZoomableController zoomableController;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableEditRectContainerState();
  }
}

class _ZoomableEditRectContainerState extends State<_ZoomableEditRectContainer> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: widget.insets,
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
      );
  }
}
