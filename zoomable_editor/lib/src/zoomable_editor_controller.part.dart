part of 'zoomable_editor.dart';

typedef OnChangeTransformCallback = void Function({Matrix4 from, @required Matrix4 to, bool animated});

class ZoomableController {

  ZoomableController({
    this.transitionEnabled = false,
    this.scaleEnabled = false,
    this.minScale,
    this.maxScale
  });

  final double minScale;
  final double maxScale;

  final bool transitionEnabled;
  final bool scaleEnabled;

  Matrix4 lastTransformMatrix;

  Offset _offset = Offset.zero;
  Offset get offset => _offset;
  void updateOffset(Offset newOffset, {bool notify = true}) {
    if (_offset != newOffset) {
      _offset = newOffset;
      if (notify) {
        notifyChange(animated: false);
      }
    }
  }

  double _scale = 1;
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
    if (onChanged != null) {
      final newTransform = transformMatrix;
      onChanged(from:fromTransfrom ?? lastTransformMatrix, to:newTransform, animated: animated);
      lastTransformMatrix = newTransform;
    }
  }

  OnChangeTransformCallback onChanged;

  Matrix4 get transformMatrix {
   return Matrix4.identity()..scale(-scale,-scale)..translate(offset.dx,offset.dy);
  }
}