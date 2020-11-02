part of 'resize_control.dart';


const _defaultDotHitAreaSickness = 30.0;
const _defaultDotRadius = 6.0;
const _defaultDotDisplaySize = Size(_defaultDotRadius * 2, _defaultDotRadius * 2);
const _defaultDotHitSize = Size(_defaultDotHitAreaSickness, _defaultDotHitAreaSickness);

class ResizeControlDot extends StatefulWidget {

  const ResizeControlDot(this.alignment) : super();
  final Alignment alignment;

  @override
  State<StatefulWidget> createState() {
    return _ResizeControlDotState();
  }

}

class _ResizeControlDotState extends State<ResizeControlDot> {

  EdgeInsets get dotEdgeInsets {
    final insetValue = (_defaultDotHitSize.width - _defaultDotDisplaySize.width) / 2;
    return EdgeInsets.all(insetValue);
  }

  @override
  Widget build(BuildContext context) {

    final ZoomableEditorCropRectController cropRectController = CropRectControllerProvider.of(context).notifier;
    final barRectWidget = Container(
                width: _defaultDotDisplaySize.width,
                height: _defaultDotDisplaySize.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                )
              );


    final container = Container(
      color: Colors.transparent,
      padding:dotEdgeInsets,
      width: _defaultDotHitSize.width,
      height: _defaultDotHitSize.height,
      child: barRectWidget,
    );

    return GestureDetector(
      child: container,
      onPanStart: (dragDetail)  {
      },
      onPanUpdate: (dragDetail) {
        cropRectController.updateByEdgeOffset(dragDetail.localPosition, widget.alignment);
      },
      onPanEnd: (dragDetail) {
        cropRectController.end(true);
      },
      onPanCancel: () {

      }
    );
  }
}
