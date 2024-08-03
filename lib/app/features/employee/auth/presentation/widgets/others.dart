import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/gen/assets.gen.dart';
import 'pickers.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Theme.of(context).brightness == Brightness.light
            ? Assets.icons.logoLight.svg(width: 168.sp)
            : Assets.icons.logoDark.svg(width: 168.sp));
  }
}

class CodePickerWidget extends StatefulWidget {
  final String initialValue;
  final void Function(String) onchange;
  const CodePickerWidget({
    super.key,
    required this.onchange,
    required this.initialValue,
  });

  @override
  State<CodePickerWidget> createState() => _CodePickerWidgetState();
}

class _CodePickerWidgetState extends State<CodePickerWidget> {
  String? code;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        countryCodePicker(
          context,
          onSelect: (country) {
            setState(() {
              code = '+${country.phoneCode}';
            });
            widget.onchange(code ?? widget.initialValue);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code ?? widget.initialValue,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: context.color.primary,
              ),
              textAlign: TextAlign.end,
            ),
            Text(
              ' |',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 25,
                color: context.color.outline,
              ),
            )
          ],
        ),
      ),
    );
  }
}
