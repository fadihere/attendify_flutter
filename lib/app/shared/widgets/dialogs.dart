import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/utils/widgets/buttons.dart';

class LogOutDialogWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onLogout;

  const LogOutDialogWidget({
    super.key,
    required this.onCancel,
    required this.onLogout,
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
              "Logout",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(9),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(25),
            AppButtonWidget(
              margin: EdgeInsets.zero,
              onTap: onCancel,
              text: "CANCEL",
              textColor: context.color.primary,
              color: context.color.primary.withOpacity(0.3),
            ),
            const Gap(10),
            AppButtonWidget(
              margin: EdgeInsets.zero,
              onTap: onLogout,
              text: "YES, LOG OUT",
              color: context.color.warning,
            ),
          ],
        ),
      ),
    );
  }
}
