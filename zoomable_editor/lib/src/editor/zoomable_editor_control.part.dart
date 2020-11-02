part of 'zoomable_editor.dart';

class _ZoomableEditorCropControl extends StatefulWidget {

  const _ZoomableEditorCropControl(this.rect);

  final Rect rect;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableEditorCropControlState();
  }
}


class _ZoomableEditorCropControlState extends State<_ZoomableEditorCropControl> {
  @override
  Widget build(BuildContext context) {

    return Positioned.fromRect(rect: widget.rect, child: ResizeControl(widget.rect.size),);
  }

}
