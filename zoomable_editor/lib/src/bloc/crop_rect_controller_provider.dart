import 'package:flutter/material.dart';

@immutable
class ZoomableEditorCropRectState {
  const ZoomableEditorCropRectState(this.insets, {this.fromInsets});
  final EdgeInsets insets;
  final EdgeInsets fromInsets;
}

class ZoomableEditorCropRectController extends ValueNotifier<ZoomableEditorCropRectState>  {

  ZoomableEditorCropRectController(
      this.editorKey,
      this.contentSize,
      this.editorSize,
      EdgeInsets insets
      ): super(ZoomableEditorCropRectState(insets));

  final GlobalKey editorKey;
  final Size contentSize;
  final Size editorSize;
  EdgeInsets get insets => value.insets;
  Rect get displayRect => Rect.fromLTWH(
      insets.left,
      insets.top,
      editorSize.width-insets.horizontal,
      editorSize.height-insets.vertical
  );
  bool updating;

  Rect get cropRect => Rect.fromLTWH(
      insets.left,
      insets.top,
      editorSize.width - insets.horizontal,
      editorSize.height - insets.vertical
  );

  void updateByEdgeOffset(Offset offset, Alignment edge) {
    updating = true;
    EdgeInsets newInsets = EdgeInsets.zero;
    if (edge == Alignment.topCenter) {
      final top = (insets.top + offset.dy).clamp(0, editorSize.height - insets.bottom).toDouble();
      newInsets = insets.copyWith(top: top);
    } else if (edge == Alignment.bottomCenter) {
      final bottom = (insets.bottom - offset.dy).clamp(0, editorSize.height - insets.top).toDouble();
      newInsets = insets.copyWith(bottom: bottom);
    } else if (edge == Alignment.centerLeft) {
      final left = (insets.left + offset.dx).clamp(0, editorSize.width - insets.right).toDouble();
      newInsets = insets.copyWith(left: left);
    }  else if (edge == Alignment.centerRight) {
      final right = (insets.right - offset.dx).clamp(0, editorSize.width - insets.left).toDouble();
      newInsets = insets.copyWith(right: right);
    } else {
      assert(false);
    }
    value = ZoomableEditorCropRectState(newInsets);
  }

  void end(bool alignCenter) {
    if (updating) {
      updating = false;
      if (alignCenter) {
        final fromInsets = insets;
        final center = EdgeInsets.fromLTRB(
            fromInsets.horizontal / 2,
            fromInsets.vertical / 2,
            fromInsets.horizontal / 2,
            fromInsets.vertical / 2
        );
        if (center != fromInsets) {
          value = ZoomableEditorCropRectState(center, fromInsets: fromInsets);
        }
      }
    }
  }
}

class CropRectControllerProvider extends InheritedNotifier<ZoomableEditorCropRectController> {

  const CropRectControllerProvider(ZoomableEditorCropRectController controller, {Widget child}): super(child: child, notifier: controller);
  ZoomableEditorCropRectController get controller => notifier;

  static CropRectControllerProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CropRectControllerProvider>();
  }
}

