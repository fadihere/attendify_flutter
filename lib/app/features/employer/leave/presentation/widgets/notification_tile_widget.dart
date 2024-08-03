import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationTileWidget extends StatelessWidget {
  const NotificationTileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.color.outline,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: context.color.primary,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const Gap(5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Medical Leave Request',
                  style: TextStyle(
                    height: 0.8,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(5),
                Text(
                  'John Doe have requested for medical leaves from 25 August to 27 August 2024',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.color.hintColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '1m ago',
            style: TextStyle(
              fontSize: 12,
              color: context.color.hintColor,
              height: 0.8,
            ),
          )
        ],
      ),
    );
  }
}
