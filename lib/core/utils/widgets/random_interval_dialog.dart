import 'package:attendify_lite/app/features/employer/auth/data/models/user_emr_model.dart';
import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/settings/data/models/interval_model.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RandomIntervalWidget extends StatefulWidget {
/*   final VoidCallback onSave;
  final VoidCallback onCancel; */
  final UserEmrModel user;
  final int intervalValue;
  final FixedExtentScrollController controller;
  const RandomIntervalWidget(
      {super.key,
      /*   required this.onSave,
      required this.onCancel, */
      required this.intervalValue,
      required this.user,
      required this.controller});

  @override
  State<RandomIntervalWidget> createState() => _RandomIntervalWidgetState();
}

class _RandomIntervalWidgetState extends State<RandomIntervalWidget> {
  @override
  void initState() {
    context
        .read<AuthEmrBloc>()
        .add(SetIntervalEvent(interval: widget.user.intervalValue));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.jumpToItem(
          widget.intervalValue); // Change the index to your desired position
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.controller.jumpToItem(widget.intervalValue);
    return BlocBuilder<AuthEmrBloc, AuthEmrState>(
      builder: (context, state) {
        return Dialog(
          insetPadding: EdgeInsets.all(20.w),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Random Attendance Check",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(9),
                /*    Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Set your frequency for employee \n attendance check",
                    style: TextStyle(
                      fontSize: 16,
                      color: context.color.hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(9), */
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 160.h,
                        child: ListWheelScrollView(
                          controller: widget.controller,
                          itemExtent: 30,
                          magnification: 1.2,
                          useMagnifier: true,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            context
                                .read<AuthEmrBloc>()
                                .add(SetIntervalEvent(interval: index));
                          },
                          children: getIntervalsList()
                              .map((item) => Text(
                                    item.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                      color: context.color.font,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      Positioned(
                        // Adjust this value to position the selection box correctly
                        child: Container(
                          height: 40.0,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: context.color.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => router.popForced(),
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              fontSize: 16,
                              color: context.color.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      TextButton(
                        onPressed: () {
                          final UserEmrModel currentUser = UserEmrModel(
                              employerId: widget.user.employerId,
                              imageUrl: widget.user.imageUrl,
                              organizationName: widget.user.organizationName,
                              emailAddress: widget.user.emailAddress,
                              isActive: widget.user.isActive,
                              isDeleted: widget.user.isDeleted,
                              createdOn: widget.user.createdOn,
                              updatedOn: widget.user.updatedOn,
                              intervalValue: state.interval,
                              token: widget.user.token);
                          context
                              .read<AuthEmrBloc>()
                              .add(UpdateIntervalEvent(user: currentUser));
                        },
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.color.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
    );
  }
}
