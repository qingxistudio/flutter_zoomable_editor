part of 'zoomable_editor.dart';

class _ZoomableEditorCanvas extends StatefulWidget {

  const _ZoomableEditorCanvas(this.contentChild);

  final Widget contentChild;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableEditorCanvasState();
  }
}

class _ZoomableEditorCanvasState extends State<_ZoomableEditorCanvas> {

  ZoomableEditorCropRectController _controller;

  void _onUpdateCropRect() {
    if (_controller != null) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdateCropRect);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = CropRectControllerProvider.of(context).controller;
    _controller.removeListener(_onUpdateCropRect);
    _controller.addListener(_onUpdateCropRect);

    final insets = _controller.insets;
    final zoomableController = ZoomableControllerProvider.of(context);
    final infoModel = SizeInfoInheritedModel.of(context);
    final w = infoModel.editorSize.width - insets.horizontal;
    final h = infoModel.editorSize.height - insets.vertical;
    final contentDisplaySize = Size(w, h);
    return Container(
          padding: insets,
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