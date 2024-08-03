import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m7_livelyness_detection/index.dart';

class SetHoursTileWidget extends StatefulWidget {
  final String? title1;
  final String? title2;
  final String? buttonText;
  final VoidCallback? onPressed;
  const SetHoursTileWidget({
    super.key,
    this.title1,
    this.title2,
    this.buttonText,
    this.onPressed,
  });

  @override
  State<SetHoursTileWidget> createState() => _SetHoursTileWidgetState();
}

class _SetHoursTileWidgetState extends State<SetHoursTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.r,
      padding: const EdgeInsets.all(10),
      decoration: dropShadowDecoration(context, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title1 ?? "",
                  style: const TextStyle(
                    fontFamily: 'Hellix',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.title2 ?? "",
                  style: const TextStyle(
                    fontFamily: 'Hellix',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width: 75.r,
              height: 35.r,
              child: AppButtonWidget(
                margin: const EdgeInsets.only(top: 5),
                onTap: widget.onPressed ?? () {},
                text: widget.buttonText?.toUpperCase() ?? "",
                fontSize: 10,
                textColor: context.color.white,
              )),
        ],
      ),
    );
  }
}
