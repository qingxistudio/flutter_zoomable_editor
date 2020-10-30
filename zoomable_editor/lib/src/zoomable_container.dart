import 'package:flutter/material.dart';


class ZoomableContainer extends StatelessWidget {

  ZoomableContainer(
      this.child,
      {
        @required this.displayWidth,
        @required this.displayHeight,
        @required this.contentWidth,
        @required this.contentHeight,
        @required this.transform,
        this.clipToBounds = true,
        this.contentWidegtKey
      });

  final Widget child;
  final double displayHeight;
  final double displayWidth;
  final double contentHeight;
  final double contentWidth;
  final Matrix4 transform;
  final bool clipToBounds;
  final GlobalKey contentWidegtKey;

  @override
  Widget build(BuildContext context) {

    final clipDecoration = BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 0)
    );

    return Container(
      clipBehavior: clipToBounds ? Clip.antiAlias : Clip.none,
      decoration: clipToBounds ? clipDecoration : null,
      width: displayWidth,
      height: displayHeight,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Container(
          key: contentWidegtKey,
          child: Transform(
            alignment: Alignment.center,
            transform: transform ?? Matrix4.identity(),
            child: child,
          ),
        ),
      ),
    );
  }
}
