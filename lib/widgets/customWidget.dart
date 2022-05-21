import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomWidget.rectangular(
      {this.width = double.infinity, required this.height})
      : this.shapeBorder = const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)));

  const CustomWidget.circular(
      {this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        period: Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey[800]!,
            shape: shapeBorder,
          ),
        ),
      );
}
