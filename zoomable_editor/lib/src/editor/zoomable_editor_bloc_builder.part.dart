part of 'zoomable_editor.dart';


class _ZoomableEditorBlocBuilder extends StatefulWidget {

  const _ZoomableEditorBlocBuilder(
      this.zoomableController,
      this.cropRectController,
      {
        @required this.editorSize,
        @required this.contentSize,
        @required this.child,
      });

  /// [child] The content to show with transform
  final Widget child;
  /// [displaySize] Size for the editor
  final Size editorSize;
  /// [contentSize] Size of the content to scale and move
  final Size contentSize;
  final ZoomableController zoomableController;
  final ZoomableEditorCropRectController cropRectController;


  @override
  State<StatefulWidget> createState() {
    return _ZoomableEditorBlocBuilderState();
  }
}

class _ZoomableEditorBlocBuilderState extends State<_ZoomableEditorBlocBuilder> {

  @override
  Widget build(BuildContext context) {

    return SizeInfoInheritedModel(
      widget.contentSize,
      widget.editorSize,
      child: CropRectControllerProvider(
        widget.cropRectController,
        child: ZoomableControllerProvider(
          widget.zoomableController,
          child: widget.child,
        ),
      ),
    );
  }
}
