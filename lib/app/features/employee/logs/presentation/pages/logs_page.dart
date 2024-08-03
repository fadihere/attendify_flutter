import 'package:attendify_lite/app/features/employee/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:attendify_lite/app/features/employee/logs/presentation/bloc/logs_bloc.dart';
import 'package:attendify_lite/app/features/employee/logs/presentation/widgets/logs_profile_avatar.dart';
import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:m7_livelyness_detection/index.dart';

import '../../../../../../core/utils/functions/functions.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/table_entry_widget.dart';
import '../widgets/table_heading_widget.dart';

@RoutePage()
class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthEmpBloc>().state.user!;
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('Log\'s'),
        ),
        body: SingleChildScrollView(
          padding: AppSize.overallPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<AuthEmpBloc, AuthEmpState>(
                builder: (context, state) {
                  if (state.user != null) {
                    return LogsProfileAvatar(
                      file: state.image,
                      name: state.user!.employeeName,
                      description: state.user!.organizationName,
                      imageUrl: state.user!.imageUrl,
                    );
                  }
                  return const Text('Currently user is signed out');
                },
              ),
              Gap(20.r),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, homeState) {
                  if (homeState.isConnected) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: dropShadowDecoration(context),
                      child: Column(
                        children: [
                          BlocBuilder<LogsBloc, LogsState>(
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<LogsBloc>()
                                            .add(FetchPreviousMonthLogsEvent(
                                              user: user,
                                              createdOn: user.createdOn,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios,
                                            color: context.color.primary,
                                            size: 12,
                                          ),
                                          const Text(
                                            'Prev',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: FontFamily.hellix),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${getMonthName(state.startDate?.getMonth ?? DateTime.now().getMonth)} ${state.startDate?.year.toString() ?? DateTime.now().year}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<LogsBloc>()
                                            .add(FetchNextMonthLogsEvent(
                                              user: user,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Next',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: context.color.primary,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          const Gap(5),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            color: const Color(0xffEEEEEE),
                            height: 46.r,
                            child: const LogTableHeadingWidget(),
                          ),
                          const Gap(5),
                          BlocBuilder<LogsBloc, LogsState>(
                            builder: (context, state) {
                              if (state.isLoadingState) {
                                return SizedBox(
                                  height: 0.4.sh,
                                  child: const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                );
                              }
                              if (state.isFailedState) {
                                return SizedBox(
                                  height: 0.4.sh,
                                  child: Center(
                                    child: Text(state.errorMessage),
                                  ),
                                );
                              }
                              if (state.logsList.isEmpty) {
                                return SizedBox(
                                  height: 0.4.sh,
                                  child: Center(
                                    child: Text(state.errorMessage),
                                  ),
                                );
                              }

                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (_, index) {
                                  return TableEntryWidget(
                                    logsModel: state.logsList[index],
                                  );
                                },
                                separatorBuilder: (_, index) {
                                  return const Divider();
                                },
                                itemCount: state.logsList.length,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                        child: Assets.icons.noInterner.svg(
                      alignment: Alignment.center,
                      width: 160.r,
                      height: 170.r,
                    )),
                  );
                },
              ),
              const Gap(30),
            ],
          ),
        ));
  }
}
