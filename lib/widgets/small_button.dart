import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final double? paddingVertical;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final Widget? child;
  final Color? color;
  final Color? borderColor;

  const SmallButton({
    Key? key,
    required this.text,
    this.paddingVertical,
    required this.onPressed,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.child,
    this.color,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 35,
        maxWidth: 200,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          textColor: Theme.of(context).colorScheme.secondary,
          color: color ?? Theme.of(context).disabledColor,
          child: Text(
            text,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
