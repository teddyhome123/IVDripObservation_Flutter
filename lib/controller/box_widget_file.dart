import 'package:flutter/material.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'camera_view_singleton.dart';


  class BoxWidget extends StatelessWidget {
    final ResultObjectDetection result;
    final Color? boxesColor;
    final bool showPercentage;
    const BoxWidget(
        {Key? key,
          required this.result,
          this.boxesColor,
          this.showPercentage = true})
        : super(key: key);
    @override
    Widget build(BuildContext context) {
      Color? usedColor;

      Size screenSize = CameraViewSingleton.actualPreviewSizeH;

      // print(screenSize);
      double factorX = screenSize.width;
      double factorY = screenSize.height ;
      if (boxesColor == null) {
        //change colors for each label
        usedColor = Colors.primaries[
        ((result.className ?? result.classIndex.toString()).length +
            (result.className ?? result.classIndex.toString())
                .codeUnitAt(0) +
            result.classIndex) %
            Colors.primaries.length];
      } else {
        usedColor = boxesColor;
      }
      return Positioned(
        left: result.rect.left * factorX,
        top: result.rect.top * factorY - 20,
        // width: result.rect.width.toDouble(),
        // height: result.rect.height.toDouble(),

        //left: re?.rect.left.toDouble(),
        //top: re?.rect.top.toDouble(),
        //right: re.rect.right.toDouble(),
        //bottom: re.rect.bottom.toDouble(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              alignment: Alignment.centerRight,
              color: usedColor,
              child: Text(
                "${result.className ?? result.classIndex.toString()}_${showPercentage
                        ? "${(result.score * 100).toStringAsFixed(2)}%"
                        : ""}",
              ),
            ),
            Container(
              width: result.rect.width.toDouble() * factorX,
              height: result.rect.height.toDouble() * factorY,
              decoration: BoxDecoration(
                  border: Border.all(color: usedColor!, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(2))),
              child: Container(),
            ),
          ],
        ),
      );
    }
  }
