//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// part 'resize_control.part.dart';
//
// const ResizeControlEdgeInsetsAll = _defaultDotHitAreaSickness / 2;
//
//
// class ResizeControl extends StatelessWidget {
//
//   const ResizeControl(this.sizeWithHitAreaInsets) : super();
//   static const EdgeInsets extraInsets = EdgeInsets.all(ResizeControlEdgeInsetsAll);
//
//   final Size sizeWithHitAreaInsets;
//
//   @override
//   Widget build(BuildContext context) {
//
//     final currentModel = context.bloc<DecorationElementSelectionReadCubit>().state.elementModel;
//     final dots = currentModel.controlOptions.resizeAnchors;
//     final dotWidgets = <Widget>[];
//     for (final dotAlignment in dots) {
//       dotWidgets.add(
//         LayoutId(
//           id: dotAlignment,
//           child: ResizeControlDot(dotAlignment),
//         ),
//       );
//     }
//     final widget = BlocBuilder<ElementDecorationLocalInfoCubit, ElementDecorationLocalInfoState>(
//         builder: (context, state) {
//           return Container(
//             width: sizeWithHitAreaInsets.width,
//             height: sizeWithHitAreaInsets.height,
//             child: CustomMultiChildLayout(
//               children: dotWidgets,
//               delegate: _ResizeControlLayoutDelegate(sizeWithHitAreaInsets)
//           ),);
//     });
//
//     return widget;
//   }
// }
//
//
// class _ResizeControlLayoutDelegate extends MultiChildLayoutDelegate {
//   _ResizeControlLayoutDelegate(this.decorationRectSize);
//   final Size decorationRectSize;
//
//   @override
//   void performLayout(Size size) {
//
//     if (hasChild(Alignment.topLeft)) {
//       layoutChild(Alignment.topLeft, BoxConstraints.loose(size));
//       final Offset offset = Offset.zero;
//       positionChild(Alignment.topLeft, offset);
//     }
//
//     if (hasChild(Alignment.topRight)) {
//       final pointer = layoutChild(Alignment.topRight, BoxConstraints.loose(size));
//       final offset = Offset(size.width - pointer.width, 0);
//       positionChild(Alignment.topRight, offset);
//     }
//
//     if (hasChild(Alignment.bottomRight)) {
//       final pointer = layoutChild(Alignment.bottomRight, BoxConstraints.loose(size));
//       final offset = Offset(size.width - pointer.width, size.height - pointer.height);
//       positionChild(Alignment.bottomRight, offset);
//     }
//
//     if (hasChild(Alignment.bottomLeft)) {
//       final pointer = layoutChild(Alignment.bottomLeft, BoxConstraints.loose(size));
//       final offset = Offset(0, size.height - pointer.height);
//       positionChild(Alignment.bottomLeft, offset);
//     }
//   }
//
//   @override
//   bool shouldRelayout(_ResizeControlLayoutDelegate oldDelegate) {
//     return oldDelegate.decorationRectSize != decorationRectSize;
//   }
// }
//
