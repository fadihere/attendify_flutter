import 'package:attendify_lite/app/features/employer/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/utils/widgets/buttons.dart';

class DeleteDialogWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const DeleteDialogWidget({
    super.key,
    required this.onCancel,
    required this.onDelete,
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
              "Delete Organization",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Are you sure you want to delete your organization?",
                style: TextStyle(
                  fontSize: 16,
                  color: context.color.hintColor,
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
            BlocBuilder<SettingsEmrBloc, SettingsEmrState>(
              builder: (context, state) {
                return AppButtonWidget(
                  isLoading: state.status == Status.loading,
                  margin: EdgeInsets.zero,
                  onTap: onDelete,
                  text: "DELETE",
                  color: context.color.warning,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
