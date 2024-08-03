import 'package:attendify_lite/app/features/employee/leave/data/models/leave_transaction_model.dart';
import 'package:attendify_lite/app/features/employee/leave/presentation/widgets/leave_tag_button.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveListItem extends StatelessWidget {
  final LeaveTransactionModel transactionModel;
  const LeaveListItem({super.key, required this.transactionModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transactionModel.title ?? 'N/A',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: context.color.font),
              ),
              const Gap(10),
              Text(
                'Applied From:',
                style: TextStyle(fontSize: 10, color: context.color.font),
              ),
              Text(
                '${DateFormat('yMMMd').format(transactionModel.recordedTimeIn!).toString()} to ${DateFormat('yMMMd').format(transactionModel.recordedTimeOut ?? DateTime.now()).toString()}',
                style: TextStyle(fontSize: 10, color: context.color.font),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                '${DateFormat('dd MMM').format(transactionModel.transactionDate!).toString()} - ${DateFormat('hh:mm a').format(transactionModel.transactionDate!)}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const Gap(20),
              LeaveTagTwoButton(status: transactionModel.requestApproved)
            ],
          ),
        ],
      ),
    );
  }
}
