import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  final Offset begin;
  final Offset end;
  final Duration duration;

  SlidePageRoute({
    required this.page,
    this.begin = const Offset(1.0, 0.0),
    this.end = Offset.zero,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            );
            
            return SlideTransition(
              position: Tween<Offset>(
                begin: begin,
                end: end,
              ).animate(curve),
              child: FadeTransition(
                opacity: curve,
                child: child,
              ),
            );
          },
          transitionDuration: duration,
        );
}
