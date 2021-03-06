# MultiSliver example application

This is an example application to demonstrate two issues that we currently are experiencing with the MultiSliver component from `sliver_tools`.

## How to run

Make sure an emulator is up and running, then just execute `flutter run` in the source code main directory.

## Functionality

The way we use it in our app is that we have a sliver list in the body of the application, and it is possible to drag it to the top of the screen. The header then collapses (and normally animates to a different layout).

![demo](readme/multi-sliver-example-app-usage?raw=true "demo")

## Issue 1: Floating Point rounding error

The first issue is after adding a `CupertinoSliverRefreshControl` to provide "swipe up to refresh the list" functionality, there is sometimes a floating point rounding error in the MultiSliver component.

In the example app the issue does not happen every time but it eventually always does happen.

![floating-point](readme/multi-sliver-floating-point-rounding-error?raw=true "floating-point")

```
I/flutter ( 4939): ══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════
I/flutter ( 4939): The following assertion was thrown during performLayout():
I/flutter ( 4939): SliverGeometry has a paintOffset that exceeds the remainingPaintExtent from the constraints.
I/flutter ( 4939): The render object whose geometry violates the constraints is the following: RenderMultiSliver#51598 relayoutBoundary=up1 NEEDS-PAINT:
I/flutter ( 4939):   needs compositing
I/flutter ( 4939):   creator: MultiSliver ← Viewport ← IgnorePointer-[GlobalKey#fa2ea] ← Semantics ← _PointerListener ←
I/flutter ( 4939):     Listener ← _GestureSemantics ←
I/flutter ( 4939):     RawGestureDetector-[LabeledGlobalKey<RawGestureDetectorState>#6eda8] ← _PointerListener ← Listener
I/flutter ( 4939):     ← _ScrollableScope ← _ScrollSemantics-[GlobalKey#630fd] ← ⋯
I/flutter ( 4939):   parentData: paintOffset=Offset(0.0, 391.1) (can use size)
I/flutter ( 4939):   constraints: SliverConstraints(AxisDirection.down, GrowthDirection.forward, ScrollDirection.forward,
I/flutter ( 4939):     scrollOffset: 0.0, remainingPaintExtent: 253.5, overlap: -175.9, crossAxisExtent: 411.4,
I/flutter ( 4939):     crossAxisDirection: AxisDirection.right, viewportMainAxisExtent: 820.6, remainingCacheExtent:
I/flutter ( 4939):     503.5, cacheOrigin: 0.0)
I/flutter ( 4939):   geometry: SliverGeometry(scrollExtent: 714.4, paintExtent: 429.4, paintOrigin: -175.9, layoutExtent:
I/flutter ( 4939):     253.5, maxPaintExtent: 890.4, hasVisualOverflow: true, cacheExtent: 253.5)
I/flutter ( 4939): The remainingPaintExtent is 253.48901034416613, but the paintOrigin + paintExtent is
I/flutter ( 4939): 253.48901034416616.
I/flutter ( 4939): Maybe you have fallen prey to floating point rounding errors, and should explicitly apply the min()
I/flutter ( 4939): or max() functions, or the clamp() method, to the paintOrigin + paintExtent?
I/flutter ( 4939): The paintOrigin and paintExtent must cause the child sliver to paint within the viewport, and so
I/flutter ( 4939): cannot exceed the remainingPaintExtent.
I/flutter ( 4939):
```

## Issue 2: MultiSliver changes in 0.1.10 do not work with `SliverFillRemainingCustomWidget`

We have a custom widget: `SliverFillRemainingCustomWidget`. This widget is supposed to fill up the remaining space in the body in case there is not enough content (in our case: list items) to fill up the remaining space.

This component works perfectly well with version 0.1.9 but no longer works with 0.1.10. In the example app it is possible to just switch the version to 0.1.10 and then the functionality that we want to achieve no longer works.

![version-upgrade](readme/multi-sliver-version-upgrade-issue?raw=true "version-upgrade")
