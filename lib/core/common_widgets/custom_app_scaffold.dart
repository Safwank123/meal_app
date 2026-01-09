
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomAppScaffold extends Scaffold {
  final ScrollController? controller;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? padding;

  CustomAppScaffold({
    super.key,
    super.appBar,
    Widget? body,
    this.controller,
    this.onRefresh,
    this.padding,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.persistentFooterAlignment,
    super.drawer,
    super.endDrawer,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.primary,
    super.drawerDragStartBehavior = DragStartBehavior.start,
    super.extendBody,
    super.extendBodyBehindAppBar,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture,
    super.endDrawerEnableOpenDragGesture,
    super.restorationId,
  }) : super(
         body: _buildBody(body: body, controller: controller, onRefresh: onRefresh, padding: padding),
       );

  static Widget _buildBody({
    required Widget? body,
    ScrollController? controller,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
  }) {
    if (body == null) return const SizedBox();

    final Widget scrollableBody = SingleChildScrollView(
      controller: controller,
      padding: padding,
      physics: onRefresh != null ? const AlwaysScrollableScrollPhysics() : const BouncingScrollPhysics(),
      child: body,
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: Stack(
          children: [
            Positioned.fill(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  // This prevents the glow effect when scrolling up
                  if (notification.leading) {
                    notification.disallowIndicator();
                  }
                  return false;
                },
                child: scrollableBody,
              ),
            ),
          ],
        ),
      );
    }

    return scrollableBody;
  }
}
