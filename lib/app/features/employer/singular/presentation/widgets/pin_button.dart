import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PinButton extends StatelessWidget {
  final int? number;
  final Function(int?) onChange;
  final IconData? icon;
  const PinButton({
    super.key,
    this.number,
    this.icon,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: IconButton(
        highlightColor: context.color.white.withOpacity(0.2),
        onPressed: () {
          onChange(number);
        },
        icon: number != null
            ? Text(
                number.toString(),
                style: TextStyle(
                    color: context.color.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              )
            : Icon(
                icon,
                color: context.color.white,
              ),
      ),
    );
  }
}
