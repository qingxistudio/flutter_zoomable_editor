
import 'package:flutter/material.dart';
import 'package:zoomable_editor/src/bloc/crop_rect_controller_provider.dart';

part 'cut_control.part.dart';

const CutControlEdgeInsetsAll = _defaultBarHitAreaSickness / 2;

class CutControl extends StatelessWidget {

  const CutControl(this.cutControlSizeWithInsets) : super();
  static const double DEFAULT_BAR_THICKNESS = 6;
  static const EdgeInsets extraInsets = EdgeInsets.all(CutControlEdgeInsetsAll);
  final Size cutControlSizeWithInsets;

  Widget wrapWithAlignment(Widget widget, Alignment alignment) {
      return LayoutId(
        id: alignment,
        child: widget,
      );
  }

  @override
  Widget build(BuildContext context) {

    final cutAnchors = [
        Alignment.topCenter,
        Alignment.centerLeft,
        Alignment.centerRight,
        Alignment.bottomCenter,
      ];
    final barWidgets = <Widget>[];
    for (final anchorAlignment in cutAnchors) {
      barWidgets.add(wrapWithAlignment(CutControlBar.barByAlignment(anchorAlignment), anchorAlignment));
    }
    return Container(
      width: cutControlSizeWithInsets.width,
      height: cutControlSizeWithInsets.height,
      child: CustomMultiChildLayout(
        children: barWidgets,
        delegate: _CutControlLayoutDelegate(cutControlSizeWithInsets)
    ),);
  }
}
class _CutControlLayoutDelegate extends MultiChildLayoutDelegate {
  _CutControlLayoutDelegate(this.decorationRectSize);
  final Size decorationRectSize;
  @override
  void performLayout(Size size) {

    if (hasChild(Alignment.topCenter)) {
      final Size barSize = layoutChild(Alignment.topCenter, BoxConstraints.loose(size));
      final Offset offset = Offset((size.width-barSize.width)/2, 0);
      positionChild(Alignment.topCenter, offset);
    }

    if (hasChild(Alignment.centerRight)) {
      final Size barSize = layoutChild(Alignment.centerRight, BoxConstraints.loose(size));
      final Offset offset = Offset(size.width - barSize.width, (size.height-barSize.height)/2);
      positionChild(Alignment.centerRight, offset);
    }

    if (hasChild(Alignment.bottomCenter)) {
      final Size barSize = layoutChild(Alignment.bottomCenter, BoxConstraints.loose(size));
      final Offset offset = Offset((size.width-barSize.width)/2, size.height-barSize.height);
      positionChild(Alignment.bottomCenter, offset);
    }

    if (hasChild(Alignment.centerLeft)) {
      Size barSize = Size.zero;
      barSize = layoutChild(Alignment.centerLeft, BoxConstraints.loose(size));
      final Offset offset = Offset(0, (size.height-barSize.height)/2);
      positionChild(Alignment.centerLeft, offset);
    }
  }

  @override
  bool shouldRelayout(_CutControlLayoutDelegate oldDelegate) {
    return oldDelegate.decorationRectSize != decorationRectSize;
  }
}
