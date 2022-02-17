import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    Key? key,
    required this.text,
    this.paddingVertical,
    required this.color,
    this.textColor,
    required this.onPressed,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.child,
    this.borderColor,
  }) : super(key: key);

  final bool autofocus;
  final Color? borderColor;
  final Widget? child;
  final Clip clipBehavior;
  final Color color;
  final FocusNode? focusNode;
  final VoidCallback? onLongPress;
  final VoidCallback? onPressed;
  final double? paddingVertical;
  final ButtonStyle? style;
  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      color: Theme.of(context).backgroundColor,
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      onPressed: onPressed,
    );
  }
}
