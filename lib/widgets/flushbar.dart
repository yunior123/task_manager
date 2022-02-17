import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/models/flush_bar_data.dart';

enum FlushBarStyle { success, error, warning, info, swin }

FlushBarData _getFlushBarDataFromStyle(FlushBarStyle style) {
  switch (style) {
    case FlushBarStyle.error:
      return FlushBarData(
        iconData: Icons.close_rounded,
        color: Colors.red,
      );
    case FlushBarStyle.success:
      return FlushBarData(
        iconData: Icons.verified_rounded,
        color: Colors.green,
      );

    case FlushBarStyle.info:
      return FlushBarData(
        iconData: FontAwesomeIcons.infoCircle,
        color: Colors.blue,
      );

    case FlushBarStyle.warning:
      return FlushBarData(
        iconData: Icons.warning_rounded,
        color: Colors.yellow,
      );

    default:
      return FlushBarData(
        iconData: Icons.warning_rounded,
        color: Colors.red,
      );
  }
}

void showFlushBar({
  required BuildContext context,
  required String text,
  String? title,
  required FlushBarStyle style,
}) {
  final data = _getFlushBarDataFromStyle(style);
  final flashBar = Flushbar<bool?>(
    flushbarPosition: FlushbarPosition.TOP,
    title: title,
    message: text,
    icon: Icon(data.iconData),
    duration: const Duration(seconds: 4),
    isDismissible: false,
    backgroundColor: data.color,
    boxShadows: [
      BoxShadow(
        color: data.color,
        offset: const Offset(0.0, 2.0),
        blurRadius: 3.0,
      )
    ],
  );
  flashBar.show(context);
}
