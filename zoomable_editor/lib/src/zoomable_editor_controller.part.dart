part of 'zoomable_editor.dart';

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

  Offset _offset = Offset.zero;
  Offset get offset => _offset;
  set offset(Offset newOffset) {
    if (_offset != newOffset) {
      _offset = newOffset;
      _notifyChange();
    }
  }

  double _scale = 1;
  double get scale => _scale;
  set scale(double newScale) {
    if (_scale != newScale) {
      _scale = newScale;
      _notifyChange();
    }
  }

  void _notifyChange() {
    if (onChanged != null) {
      onChanged();
    }
  }

  VoidCallback onChanged;

  Matrix4 get transformMatrix {
   return Matrix4.identity()..scale(-scale,-scale)..translate(offset.dx,offset.dy);
  }
}