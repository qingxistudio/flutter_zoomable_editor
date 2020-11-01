part of 'zoomable_editor.dart';

typedef OnChangeTransformCallback = void Function({Matrix4 from, @required Matrix4 to, bool animated});

class ZoomableController {

  ZoomableController({
    this.transitionEnabled = true,
    this.scaleEnabled = true,
    this.doubleTapEnabled = true,
    this.minScale,
    this.maxScale,
    Offset initOffset,
    double initScale
  }) {
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

  void notifyChange({@required bool animated, Matrix4 fromTransfrom}) {
    final newTransform = transformMatrix;
    if (onChanged != null) {
      onChanged(from:fromTransfrom ?? lastTransformMatrix, to:newTransform, animated: animated);
    }
    if (_onChangedInternal != null) {
      _onChangedInternal(from:fromTransfrom ?? lastTransformMatrix, to:newTransform, animated: animated);
    }
    lastTransformMatrix = newTransform;
  }

  OnChangeTransformCallback onChanged;

  OnChangeTransformCallback _onChangedInternal;


  Matrix4 get transformMatrix {
   return Matrix4.identity()..scale(scale,scale)..translate(offset.dx,offset.dy);
  }
}