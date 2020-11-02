
import 'package:flutter/material.dart';

class SizeInfoInheritedModel extends InheritedWidget {

  const SizeInfoInheritedModel(this.contentSize, this.editorSize, {Widget child}) : super(child: child);

  final Size contentSize;
  final Size editorSize;

  @override
  bool updateShouldNotify(covariant SizeInfoInheritedModel oldWidget) {

    return contentSize != oldWidget.contentSize
    || editorSize != oldWidget.editorSize;
  }

  static SizeInfoInheritedModel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeInfoInheritedModel>();
  }
}
