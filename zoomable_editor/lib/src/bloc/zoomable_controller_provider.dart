import 'package:flutter/material.dart';

@immutable
class ChangeTransformState {
  const ChangeTransformState(this.to, {this.from, this.animated=false});
  final Matrix4 to;
  final Matrix4 from;
  final bool animated;
}

typedef OnChangeTransformCallback = void Function({Matrix4 from, @required Matrix4 to, bool animated});

class ZoomableController extends ValueNotifier<ChangeTransformState> {

  ZoomableController({
    this.transitionEnabled = true,
    this.scaleEnabled = true,
    this.doubleTapEnabled = true,
    this.minScale,
    this.maxScale,
    Offset initOffset,
    double initScale
  }) : super(ChangeTransformState(Matrix4.identity())) {
    _offset = initOffset ?? Offset.zero;
    _scale = initScale ?? 1;
  }

  final double minScale;
  final double maxScale;

  final bool transitionEnabled;
  final bool scaleEnabled;
  final bool doubleTapEnabled;

  Matrix4 lastTransformMatrix;

  Offset _offset;
  Offset get offset => _offset;
  void updateOffset(Offset newOffset, {bool notify = true}) {
    if (_offset != newOffset) {
      _offset = newOffset;
      if (notify) {
        notifyChange(animated: false);
      }
    }
  }

  double _scale;
  double get scale => _scale;
  void updateScale(double newScale, {bool notify = true}) {
    if (_scale != newScale) {
      _scale = newScale;
      if (notify) {
        notifyChange(animated: false);
      }
    }
  }

  void notifyChange({@required bool animated, Matrix4 fromTransform}) {
    final newTransform = transformMatrix;
    if (_onChangedInternal != null) {
      _onChangedInternal(from:fromTransform ?? lastTransformMatrix, to:newTransform, animated: animated);
    }
    value = ChangeTransformState(
        newTransform,
        from: fromTransform ?? lastTransformMatrix,
        animated: animated
    );
    lastTransformMatrix = newTransform;
  }

  OnChangeTransformCallback _onChangedInternal;

  Matrix4 get transformMatrix {
   return Matrix4.identity()..scale(scale,scale)..translate(offset.dx,offset.dy);
  }

}


class ZoomableControllerProvider extends InheritedNotifier<ZoomableController> {

  const ZoomableControllerProvider(ZoomableController controller, {Widget child}): super(child: child, notifier: controller);
  ZoomableController get controller => notifier;

  static ZoomableController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ZoomableControllerProvider>().notifier;
  }
}
