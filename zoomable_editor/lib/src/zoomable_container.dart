import 'package:flutter/material.dart';

class ZoomableContainer extends StatefulWidget {

  const ZoomableContainer(
      this.child,
      {
        this.displaySize,
        this.contentSize,
        this.fromTransform,
        this.transform,
        this.clipToBounds = true,
      });

  /// [child] The content to show with transform
  final Widget child;
  /// [displaySize] Size for the editor container
  final Size displaySize;
  /// [contentSize] Size of the content to scale and move
  final Size contentSize;
  final Matrix4 fromTransform;
  final Matrix4 transform;
  /// [clipToBounds] Should clip overflow content
  final bool clipToBounds;
  
  double get displayWidth => displaySize.width;
  double get displayHeight => displaySize.height;
  double get contentWidth => contentSize.width;
  double get contentHeight => contentSize.height;

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
                              ).evaluate(CurvedAnimation(
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


