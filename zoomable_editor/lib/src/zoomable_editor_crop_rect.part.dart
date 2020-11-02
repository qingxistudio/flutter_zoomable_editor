part of 'zoomable_editor.dart';

typedef OnInsetsChange = void Function({EdgeInsets fromInsets});

class _ZoomableEditorRectController {
  _ZoomableEditorRectController(this.contentSize, this.editorSize, this.insets);

  final Size contentSize;
  Size editorSize;
  EdgeInsets insets;

  OnInsetsChange _onChange;
  
  Rect get cropRect => Rect.fromLTWH(
      insets.left,
      insets.top,
      editorSize.width - insets.horizontal,
      editorSize.height - insets.vertical
  );

  void changeByEdgeOffset(Offset offset, Alignment edge) {
    if (edge == Alignment.topCenter) {
      final top = (insets.top + offset.dy).clamp(0, editorSize.height - insets.bottom).toDouble();
      insets = insets.copyWith(top: top);
    } else if (edge == Alignment.bottomCenter) {
      final bottom = (insets.bottom - offset.dy).clamp(0, editorSize.height - insets.top).toDouble();
      insets = insets.copyWith(bottom: bottom);
    } else if (edge == Alignment.centerLeft) {
      final left = (insets.left + offset.dx).clamp(0, editorSize.width - insets.right).toDouble();
      insets = insets.copyWith(left: left);
    }  else if (edge == Alignment.centerRight) {
      final right = (insets.right - offset.dx).clamp(0, editorSize.width - insets.left).toDouble();
      insets = insets.copyWith(right: right);
    } else {
      assert(false);
    }

    if (_onChange != null) {
      _onChange();
    }
  }
}

class _ZoomableEditorRectContainer extends StatefulWidget {

  const _ZoomableEditorRectContainer(
      this.child,
      this.zoomableController,
      this._rectController
      );

  final Widget child;
  final _ZoomableEditorRectController _rectController;
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
    widget._rectController._onChange = ({ EdgeInsets fromInsets}) {
      setState(() {
        this.fromInsets = fromInsets;
        toInsets = widget._rectController.insets;
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final contentContainer = Container(
              foregroundDecoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
              ),
              child: _ZoomableContainerBuilder(
                widget.child,
                widget.zoomableController,
                displaySize: widget.contentCropSize,
                contentSize:widget.contentSize,
              )
            );

    if (fromInsets == null) {
      return Container(
          padding: toInsets,
          child: contentContainer
      );
    } else {
      final aAnimatedBuilder = AnimatedBuilder(
        child: widget.child,
        builder: (BuildContext context, Widget child) {
                    return Container(
                    padding: EdgeInsetsTween(begin: fromInsets, end: toInsets).evaluate(CurvedAnimation(
                                parent: _controller,
                                curve: Curves.easeOut
                              )),
                    child: contentContainer
                );
        },
        animation: _controller,
      );

      _controller.forward(from: 0);
      return aAnimatedBuilder;
    }
  }
}
