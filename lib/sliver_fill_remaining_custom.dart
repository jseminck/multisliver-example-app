import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class SliverFillRemainingCustomWidget extends StatelessWidget {
  final GlobalKey sliverListKey;
  final Widget child;
  final double offset;

  const SliverFillRemainingCustomWidget(
      {Key key, @required this.sliverListKey, this.offset = 0.0, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SliverFillRemainingAndOverscroll(
        offset: offset, sliverListKey: sliverListKey, child: child);
  }
}

class _SliverFillRemainingAndOverscroll extends SingleChildRenderObjectWidget {
  final GlobalKey sliverListKey;
  final double offset;

  const _SliverFillRemainingAndOverscroll({Key key, this.sliverListKey, this.offset, Widget child})
      : super(key: key, child: child);

  @override
  _RenderSliverFillRemainingAndOverscroll createRenderObject(BuildContext context) =>
      _RenderSliverFillRemainingAndOverscroll(offset: offset, sliverListKey: sliverListKey);
}

class _RenderSliverFillRemainingAndOverscroll extends RenderSliverSingleBoxAdapter {
  /// Creates a [RenderSliver] that wraps a non-scrollable [RenderBox] which is
  /// sized to fit the remaining space plus any overscroll in the viewport.

  // Offset is subtracted from the extent to be filled (appbar height, paddings etc)
  final double offset;
  final GlobalKey sliverListKey;

  _RenderSliverFillRemainingAndOverscroll({this.offset, this.sliverListKey, RenderBox child})
      : super(child: child);

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    // The remaining space in the viewportMainAxisExtent. Can be <= 0 if we have
    // scrolled beyond the extent of the screen.
    double extent =
        constraints.viewportMainAxisExtent - constraints.precedingScrollExtent - 140 - offset;
    // The maxExtent includes any overscrolled area. Can be < 0 if we have
    // overscroll in the opposite direction, away from the end of the list.
    double maxExtent = constraints.remainingPaintExtent - math.min(constraints.overlap, 0.0);

    print(
        'this.sliverListKey.currentContext: ${this.sliverListKey.currentContext.findRenderObject().paintBounds.bottom}');

    if (child != null) {
      double childExtent;
      switch (constraints.axis) {
        case Axis.horizontal:
          childExtent = child.getMaxIntrinsicWidth(constraints.crossAxisExtent);
          break;
        case Axis.vertical:
          childExtent = child.getMaxIntrinsicHeight(constraints.crossAxisExtent);
          break;
      }

      // If the childExtent is greater than the computed extent, we want to use
      // that instead of potentially cutting off the child. This allows us to
      // safely specify a maxExtent.
      extent = math.max(extent, childExtent);
      // The extent could be larger than the maxExtent due to a larger child
      // size or overscrolling at the top of the scrollable (rather than at the
      // end where this sliver is).
      maxExtent = math.max(extent, maxExtent);
      child.layout(constraints.asBoxConstraints(minExtent: extent, maxExtent: maxExtent));
    }

    final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: extent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: math.min(maxExtent, constraints.remainingPaintExtent),
      maxPaintExtent: maxExtent,
      hasVisualOverflow:
          extent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
    if (child != null) {
      setChildParentData(child, constraints, geometry);
    }
  }
}
