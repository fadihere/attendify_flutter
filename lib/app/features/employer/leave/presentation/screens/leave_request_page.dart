import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/res/constants.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

@RoutePage()
class LeaveRequestPage extends StatelessWidget {
  const LeaveRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Leave Request',
          style: TextStyle(fontFamily: FontFamily.hellix, fontSize: 20.r),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSize.overallPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 350.r,
                    decoration: BoxDecoration(
                        color: context.color.whiteBlack,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 15)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(27),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Employee Name',
                            style: TextStyle(
                              color: context.color.hint,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Gap(7),
                          Text(
                            'John Doe',
                            style: TextStyle(
                              color: context.color.font,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(20),
                          Text(
                            'Comments',
                            style: TextStyle(
                              color: context.color.hint,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Gap(7),
                          Text(
                            'Taking a Casual Leave',
                            style: TextStyle(
                              color: context.color.font,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(20),
                          Text(
                            'Leave Type',
                            style: TextStyle(
                              color: context.color.hint,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Gap(7),
                          Text(
                            'Casual Leave',
                            style: TextStyle(
                              color: context.color.font,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(20),
                          Text(
                            'Leave Dates',
                            style: TextStyle(
                              color: context.color.hint,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Gap(7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '14 Feb 2024 - 16 Feb 2024',
                                style: TextStyle(
                                  color: context.color.font,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '2 Days',
                                style: TextStyle(
                                  color: context.color.hint,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(30),
                  const Padding(
                    padding: AppSize.sidePadding,
                    child: CustomTextFormField(
                      hintText: "Type your comment here",
                      minLines: 5,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: AppSize.sidePadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButtonWidget(
                        onTap: () {},
                        margin: EdgeInsets.zero,
                        text: AppConstants.accept.toUpperCase(),
                        color: context.color.primary),
                    AppButtonWidget(
                      onTap: () {},
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      text: AppConstants.reject.toUpperCase(),
                      textColor: context.color.primary,
                      color: context.color.primary.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
