part of 'zoomable_editor.dart';

class _ZoomableEditorRectContainer extends StatefulWidget {

  const _ZoomableEditorRectContainer(
      this.child,
      this.zoomableController,
      this._rectController
      );

  final Widget child;
  final ZoomableEditorCropRectController _rectController;
  final ZoomableController zoomableController;

  Size get contentSize => _rectController.contentSize;
  Size get contentCropSize => _rectController.cropRect.size;
  Size get editorSize => _rectController.editorSize;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableEditorRectContainerState();
  }
}

class _ZoomableEditorRectContainerState extends State<_ZoomableEditorRectContainer> with SingleTickerProviderStateMixin {

  EdgeInsets fromInsets;
  EdgeInsets toInsets;

  AnimationController _controller;

  @override
  void initState() {
    toInsets = widget._rectController.insets;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    widget._rectController.addListener(_onChangeInsets);
    super.initState();
  }

  @override
  void dispose() {
    widget._rectController.removeListener(_onChangeInsets);
    _controller.dispose();
    super.dispose();
  }

  void _onChangeInsets() {
    setState(() {
     fromInsets = widget._rectController.value.fromInsets;
     toInsets = widget._rectController.value.insets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // final contentContainer = Container(
    //           foregroundDecoration: BoxDecoration(
    //             border: Border.all(width: 2, color: Colors.white),
    //           ),
    //           child: _ZoomableContainerBuilder(
    //             widget.child,
    //             widget.zoomableController,
    //             displaySize: widget.contentCropSize,
    //             contentSize:widget.contentSize,
    //           )
    //         );
    //
    // if (fromInsets == null) {
    //   return Container(
    //       padding: toInsets,
    //       child: contentContainer
    //   );
    // } else {
    //   final aAnimatedBuilder = AnimatedBuilder(
    //     child: widget.child,
    //     builder: (BuildContext context, Widget child) {
    //                 return Container(
    //                 padding: EdgeInsetsTween(begin: fromInsets, end: toInsets).evaluate(CurvedAnimation(
    //                             parent: _controller,
    //                             curve: Curves.easeOut
    //                           )),
    //                 child: contentContainer
    //             );
    //     },
    //     animation: _controller,
    //   );
    //
    //   _controller.forward(from: 0);
    //   return aAnimatedBuilder;
    // }
  }
}
