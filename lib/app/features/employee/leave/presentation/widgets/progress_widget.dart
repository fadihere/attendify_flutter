import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    super.key,
    required this.height,
    required this.title,
  });

  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: height * 0.07,
              height: height * 0.07,
              child: CircularProgressIndicator(
                value: 0.8,
                color: context.color.primary,
                backgroundColor: Colors.grey.shade300,
                strokeWidth: 7,
              ),
            ),
            Text(
              '08',
              style: TextStyle(
                  color: context.color.font,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(
              color: context.color.font,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
