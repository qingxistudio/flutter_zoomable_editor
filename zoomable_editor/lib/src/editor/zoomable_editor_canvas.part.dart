part of 'zoomable_editor.dart';

class _ZoomableEditorCanvas extends StatefulWidget {

  const _ZoomableEditorCanvas(this.contentChild,
      {
        @required this.insets,
      });

  final Widget contentChild;
  final EdgeInsets insets;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableEditorCanvasState();
  }
}

class _ZoomableEditorCanvasState extends State<_ZoomableEditorCanvas> {
  @override
  Widget build(BuildContext context) {

    final zoomableController = ZoomableControllerProvider.of(context);
    final infoModel = SizeInfoInheritedModel.of(context);
    final w = infoModel.editorSize.width - widget.insets.horizontal;
    final h = infoModel.editorSize.height - widget.insets.vertical;
    final contentDisplaySize = Size(w, h);
    return Container(
          padding: widget.insets,
          child: Container(
              foregroundDecoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              ),
              child: _ZoomableContentBuilder(
                widget.contentChild,
                zoomableController,
                contentSize: infoModel.contentSize,
                displaySize: contentDisplaySize,
              )
            )
      );
  }
}