import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../leave/presentation/widgets/notification_tile_widget.dart';

@RoutePage()
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.notifications,
          style: TextStyle(fontFamily: FontFamily.hellix),
        ),
      ),
      body: RefreshIndicator(
        color: context.color.primary,
        backgroundColor: context.color.container,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 3));
        },
        child: ListView.builder(
          padding: AppSize.overallPadding,
          itemCount: 1,
          itemBuilder: (context, index) {
            return const NotificationTileWidget();
          },
        ),
      ),
    );
  }
}
