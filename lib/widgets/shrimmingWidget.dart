import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmeringWidget.rectangular(
      {this.width = double.infinity, required this.height})
      : this.shapeBorder = const RoundedRectangleBorder();

  const ShimmeringWidget.circular(
      {this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Color(0x18000000),
        highlightColor: Color(0x09000000),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: width,
              height: height,
              decoration: ShapeDecoration(
                color: Colors.grey[400]!,
                shape: shapeBorder,
              ),
            ),
          ),
        ),
      );
}
