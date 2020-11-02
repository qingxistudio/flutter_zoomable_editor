part of 'cut_control.dart';

const _defaultBarSickness = 6.0;
const _defaultBarHitAreaSickness = 30.0;
const _defaultBarDisplaySize = Size(16, _defaultBarSickness);
const _defaultBarHitSize = Size(60, _defaultBarHitAreaSickness);

class CutControlBar extends StatefulWidget {
  const CutControlBar(this.alignmentID, this.horizontalHitSize, this.horizontalDisplaySize) : super();

  factory CutControlBar.barByAlignment(Alignment alignment) {
    return CutControlBar(alignment, _defaultBarHitSize, _defaultBarDisplaySize);
  }

  EdgeInsets get barEdgeInsets {
    final leftRight = (horizontalHitSize.width - horizontalDisplaySize.width) / 2;
    final topBottom = (horizontalHitSize.height - horizontalDisplaySize.height) / 2;

    if (vertical) {
      return EdgeInsets.fromLTRB(topBottom, leftRight, topBottom, leftRight);
    } else {
      return EdgeInsets.fromLTRB(leftRight, topBottom, leftRight, topBottom);
    }
  }

  Size get displaySize {
    return vertical ? Size(horizontalDisplaySize.height, horizontalDisplaySize.width) : horizontalDisplaySize;
  }


  Size get hitSize {
    return vertical ? Size(horizontalHitSize.height, horizontalHitSize.width) : horizontalHitSize;
  }

  bool get vertical => alignmentID == Alignment.centerLeft || alignmentID == Alignment.centerRight;


  final Alignment alignmentID;
  final Size horizontalHitSize;
  final Size horizontalDisplaySize;

  @override
  State<StatefulWidget> createState() {
    return _CutControlBarState();
  }
}

class _CutControlBarState extends State<CutControlBar> {
  _CutControlBarState();

  @override
  Widget build(BuildContext context) {

    final container = Container(
      color: Colors.transparent,
      padding: widget.barEdgeInsets,
      width: widget.hitSize.width,
      height: widget.hitSize.height,
      child: _CutControlBarIcon(widget.displaySize),
    );
    final controller = CropRectControllerProvider.of(context).controller;

    return GestureDetector(
      child: container,
      onPanStart: (dragDetail)  {
        controller.updateByEdgeOffset(Offset.zero, widget.alignmentID);
      },
      onPanUpdate: (dragDetail) {
        controller.updateByEdgeOffset(Offset(1, 0), widget.alignmentID);
      },
      onPanEnd: (dragDetail) {
        controller.end(true);
      },
      onPanCancel: () {
        controller.end(true);
      }
    );
  }
}


class _CutControlBarIcon extends StatefulWidget {

  const _CutControlBarIcon(this.displaySize);

  final Size displaySize;

  @override
  State<StatefulWidget> createState() {
    return _CutControlBarIconState();
  }

}

class _CutControlBarIconState extends State<_CutControlBarIcon> {

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
      if (_controller.updating ?? false) {
        return Container();
      } else {
        return Container(
              width: widget.displaySize.width,
              height: widget.displaySize.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))
              )
            );
      }
  }

}
