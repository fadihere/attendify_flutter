import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaveDialogWidget extends StatelessWidget {
  final VoidCallback onLeavePeriod;
  final VoidCallback onLeaveCategory;

  const LeaveDialogWidget({
    super.key,
    required this.onLeavePeriod,
    required this.onLeaveCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Manage Leaves",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(25),
            AppButtonWidget(
              margin: EdgeInsets.zero,
              onTap: onLeavePeriod,
              text: "LEAVE PERIOD",
              textColor: context.color.primary,
              color: context.color.primary.withOpacity(0.12),
            ),
            const Gap(10),
            AppButtonWidget(
              margin: EdgeInsets.zero,
              onTap: onLeaveCategory,
              text: "SET LEAVE CATEGORY",
              color: context.color.primary,
            ),
          ],
        ),
      ),
    );
  }
}
