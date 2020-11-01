// part of 'resize_control.dart';
//
//
// const _defaultDotHitAreaSickness = 30.0;
// const _defaultDotRadius = 6.0;
// const _defaultDotDisplaySize = Size(_defaultDotRadius * 2, _defaultDotRadius * 2);
// const _defaultDotHitSize = Size(_defaultDotHitAreaSickness, _defaultDotHitAreaSickness);
//
// class ResizeControlDot extends StatefulWidget {
//
//   const ResizeControlDot(this.alignment) : super();
//   final Alignment alignment;
//
//   @override
//   State<StatefulWidget> createState() {
//     return _ResizeControlDotState();
//   }
//
// }
//
// class _ResizeControlDotState extends State<ResizeControlDot> {
//
//   final PanControlGestureDetectorDelegate gestureDetectDelegate = PanControlGestureDetectorDelegate();
//
//   EdgeInsets get dotEdgeInsets {
//     final insetValue = (_defaultDotHitSize.width - _defaultDotDisplaySize.width) / 2;
//     return EdgeInsets.all(insetValue);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final barRectWidget = BlocBuilder<DecorationOperationTypeReadCubit, ElementDecorationOperationType>(
//       builder: (cubit, opType) {
//         if (opType == ElementDecorationOperationType.normal) {
//           return Container(
//                 width: _defaultDotDisplaySize.width,
//                 height: _defaultDotDisplaySize.height,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle
//                 )
//               );
//         } else {
//           return Container();
//         }
//       },
//     );
//
//
//     final container = Container(
//       color: Colors.transparent,
//       padding:dotEdgeInsets,
//       width: _defaultDotHitSize.width,
//       height: _defaultDotHitSize.height,
//       child: barRectWidget,
//     );
//
//     ReadonlyElementModel currentDraggingModel;
//     return GestureDetector(
//       child: container,
//       onPanStart: (dragDetail)  {
//         final globalCenter = context.bloc<ElementDecorationLocalInfoCubit>().state.globalRect.center;
//         gestureDetectDelegate.onPanStart(context, dragDetail, globalCenter);
//         context.bloc<CanvasDecorationControllerCubit>().changeOperationType(ElementDecorationOperationType.resizing);
//         currentDraggingModel = context.bloc<DecorationElementSelectionReadCubit>().state.elementModel;
//       },
//       onPanUpdate: (dragDetail) => gestureDetectDelegate.onPanUpdate(context, dragDetail, (globalOffset, localOffset) {
//         final rect = gestureDetectDelegate.converter.rectWhenResizeByControlPoint(localOffset, widget.alignment, currentDraggingModel.controlOptions.keepCenterWhenResize);
//         final elementController = context.bloc<DecorationElementSelectionReadCubit>().state.elementController;
//         context.bloc<DecorationControllerCubit>().updateWhenResize(elementController, rect);
//       }),
//       onPanEnd: (dragDetail) => gestureDetectDelegate.onPanEnd(context, dragDetail, (globalOffset, localOffset) {
//         final rect = gestureDetectDelegate.converter.rectWhenResizeByControlPoint(localOffset, widget.alignment, currentDraggingModel.controlOptions.keepCenterWhenResize);
//         final elementController = context.bloc<DecorationElementSelectionReadCubit>().state.elementController;
//         context.bloc<DecorationControllerCubit>().endResize(elementController, rect, context);
//         gestureDetectDelegate.reset();
//         currentDraggingModel = null;
//       }),
//       onPanCancel: () {
//         gestureDetectDelegate.onPanCancel(context);
//         currentDraggingModel = null;
//       }
//     );
//   }
// }
