import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final double value;
  final bool isWidth;

  double dynamicWidthBuild(BuildContext context, double val) =>
      MediaQuery.of(context).size.width * val;

  double dynamicHeightBuild(BuildContext context, double val) =>
      MediaQuery.of(context).size.height * val;

  @override
  Widget build(BuildContext context) {
    return isWidth
        ? SizedBox(width: dynamicWidthBuild(context, value))
        : SizedBox(height: dynamicHeightBuild(context, value));
  }

  EmptyWidget.width({this.isWidth = true, this.value})
      : assert(value < 1 && value > 0);
  EmptyWidget.height({this.isWidth = false, this.value})
      : assert(value < 1 && value > 0);
}
