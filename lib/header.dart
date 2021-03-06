import 'dart:math';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  static const double borderRadiusFactor = 8.0;
  static const double collapsedHeight = 57.0;
  static const double expandedHeight = 342.0;

  const Header();

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
          minHeight: collapsedHeight + MediaQuery.of(context).padding.top,
          maxHeight: expandedHeight + MediaQuery.of(context).padding.top),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Container(decoration: BoxDecoration(color: Colors.purple.shade100)),
        Container(
          height: 317,
          child: Center(
            child: Text(
              "This is the header",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
