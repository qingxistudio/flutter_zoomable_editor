import 'package:flutter/material.dart';

class ZoomableContainer extends StatefulWidget {

  const ZoomableContainer(
      this.child,
      {
        @required this.displayWidth,
        @required this.displayHeight,
        @required this.contentWidth,
        @required this.contentHeight,
        this.fromTransform,
        this.transform,
        this.clipToBounds = true,
      });

  final Widget child;
  final double displayHeight;
  final double displayWidth;
  final double contentHeight;
  final double contentWidth;
  final Matrix4 fromTransform;
  final Matrix4 transform;
  final bool clipToBounds;

  @override
  State<StatefulWidget> createState() {
    return _ZoomableContainerState();
  }
}

class _ZoomableContainerState extends State<ZoomableContainer> with SingleTickerProviderStateMixin {


  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final clipDecoration = BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 0)
    );

    final toTransform = widget.transform ?? Matrix4.identity();
    Widget contentWidget;
    if (widget.fromTransform == null) {
      contentWidget = Container(
          child: Transform(
            alignment: Alignment.center,
            transform: widget.transform ?? Matrix4.identity(),
            child: widget.child,
          ),
        );
    } else {
      contentWidget = AnimatedBuilder(
        child: widget.child,
        builder: (BuildContext context, Widget child) {
          return Container(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4Tween(
                                begin: widget.fromTransform,
                                end: toTransform
                              ).evaluate(new CurvedAnimation(
                                parent: _controller,
                                curve: Curves.easeOut
                              )),
                    child: child,
                  ),
                );
        },
        animation: _controller,
      );

      _controller.forward(from: 0);
    }

    return Container(
      clipBehavior: widget.clipToBounds ? Clip.antiAlias : Clip.none,
      decoration: widget.clipToBounds ? clipDecoration : null,
      width: widget.displayWidth,
      height: widget.displayHeight,
      child: FittedBox(
        fit: BoxFit.cover,
        child: contentWidget,
      ),
    );
  }
}


