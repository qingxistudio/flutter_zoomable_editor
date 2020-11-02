part of 'zoomable_editor.dart';

class _ZoomableEditorCropControl extends StatefulWidget {

  const _ZoomableEditorCropControl();

  @override
  State<StatefulWidget> createState() {
    return _ZoomableEditorCropControlState();
  }
}

class _ZoomableEditorCropControlState extends State<_ZoomableEditorCropControl> {
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
    final cropRect = _controller.displayRect;
    final rectWithControlBarInsets = Rect.fromCenter(
        center: cropRect.center,
        width: cropRect.width+CutControl.extraInsets.horizontal,
        height: cropRect.height+CutControl.extraInsets.vertical
    );
    return Positioned.fromRect(rect: rectWithControlBarInsets, child: CutControl(rectWithControlBarInsets.size),);
  }
}
