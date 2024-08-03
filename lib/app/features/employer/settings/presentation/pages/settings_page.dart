import 'dart:developer';

import 'package:attendify_lite/app/features/employee/settings/presentation/widgets/tile_widget.dart';
import 'package:attendify_lite/app/features/employer/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/bloc/theme_cubit/theme_cubit.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/utils/extensions/utils.dart';
import 'package:attendify_lite/core/utils/widgets/delete_dialog.dart';
import 'package:attendify_lite/core/utils/widgets/logout_tile_widget.dart';
import 'package:attendify_lite/core/utils/widgets/profile_avatar_widget.dart';
import 'package:attendify_lite/core/utils/widgets/random_interval_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../shared/widgets/dialogs.dart';
import '../../../../employee/settings/presentation/widgets/dialogs.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

@RoutePage()
class AdmSettingsPage extends StatelessWidget {
  const AdmSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthEmrBloc>().state.user;

    final controller = FixedExtentScrollController();
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: AppSize.sidePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(30),
                BlocConsumer<AuthEmrBloc, AuthEmrState>(
                  listener: (context, state) {
                    if (state is ShowImageDialogState) {
                      _imageDialog(context, state);
                      return;
                    }
                  },
                  builder: (context, state) {
                    return ProfileAvatarWidget(
                      onTap: () {
                        context.read<AuthEmrBloc>().add(PickImageEvent());
                      },
                      file: state.image,
                      name: state.user!.organizationName.capitalize,
                      description: state.user!.emailAddress,
                      imageUrl: state.user!.imageUrl ?? '',
                    );
                  },
                ),
                const Gap(30),
                Container(
                  decoration: dropShadowDecoration(context),
                  child: Column(
                    children: [
                      TileWidget(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        top: 16.r,
                        onTap: () {
                          final authBloc = context.read<AuthEmrBloc>();
                          router
                              .push(AdmReportRoute(user: authBloc.state.user!));
                        },
                        title: "Generate Reports",
                        icon: Assets.icons.calendarOutline,
                      ),
                      TileWidget(
                        top: 10.r,
                        onTap: () {
                          router.push(const SetOfficeHourRoute());
                        },
                        title: "Set Office Hours",
                        icon: Assets.icons.laptopClockOutline,
                      ),
                      BlocBuilder<AuthEmrBloc, AuthEmrState>(
                        builder: (context, state) {
                          log('INTERVAL ===> ${state.interval}');
                          return TileWidget(
                            top: 10.r,
                            onTap: () {
                              log(state.interval.toString());
                              showAdaptiveDialog(
                                  context: context,
                                  builder: (context) => RandomIntervalWidget(
                                        controller: controller,
                                        intervalValue: state.interval,
                                        user: currentUser!,
                                        /*         onCancel: () {
                                        router.popForced();
                                      },
                                      onSave: () {
                                        log(state.interval.toString());
                                        /*  final UserEmrModel user = UserEmrModel(
                                            employerId: currentUser.employerId,
                                            imageUrl: currentUser.imageUrl,
                                            organizationName:
                                                currentUser.organizationName,
                                            emailAddress:
                                                currentUser.emailAddress,
                                            isActive: currentUser.isActive,
                                            isDeleted: currentUser.isDeleted,
                                            createdOn: currentUser.createdOn,
                                            updatedOn: currentUser.updatedOn,
                                            intervalValue: state.interval,
                                            token: currentUser.token);
                                        context.read<AuthEmrBloc>().add(
                                            UpdateIntervalEvent(user: user)); */
                                      } */
                                      ));
                            },
                            title: "Random Attendance Check",
                            icon: Assets.icons.interval,
                          );
                        },
                      ),
                      TileWidget(
                        top: 10.r,
                        onTap: () {
                          // router.maybePop();
                          router.push(const LeavePeriodRoute());
                          /* showAdaptiveDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return LeaveDialogWidget(
                                onLeavePeriod: () {
                                  router.maybePop();
                                  router.push(const LeavePeriodRoute());
                                },
                                onLeaveCategory: () {
                                  router.maybePop();
                                  router.push(
                                      LeaveCategoryRoute(isUpdate: false));
                                },
                              );
                            },
                          );
                       */
                        },
                        title: "Leave Types",
                        icon: Assets.icons.menu,
                      ),
                      TileWidget(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        top: 16.r,
                        onTap: () {
                          router.push(const AdmAddNewLocationRoute());
                        },
                        title: "Organization Locations",
                        icon: Assets.icons.pickLocation,
                        disableDivider: true,
                      ),
                    ],
                  ),
                ),
                const Gap(15),
                Container(
                  decoration: dropShadowDecoration(context),
                  child: Column(
                    children: [
                      TileWidget(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        top: 16.r,
                        onTap: () {
                          router.push(SetupPin1Route(title: "Enter PIN"));
                        },
                        title: "Singular Device Mode",
                        icon: Assets.icons.singularModeOutline,
                      ),
                      TileWidget(
                        top: 10.r,
                        onTap: () {
                          final themeBloc = context.read<ThemeCubit>();
                          Theme.of(context).brightness == Brightness.dark
                              ? themeBloc.setTheme(ThemeMode.light)
                              : themeBloc.setTheme(ThemeMode.dark);
                        },
                        title: "Dark Mode",
                        icon: Assets.icons.moonOutline,
                        surfix: IgnorePointer(
                          child: SizedBox(
                            height: 0,
                            child: CupertinoSwitch(
                              activeColor: context.color.primary,
                              value: Theme.of(context).brightness ==
                                  Brightness.dark,
                              onChanged: (_) {},
                            ),
                          ),
                        ),
                      ),
                      TileWidget(
                        top: 10.r,
                        onTap: () {
                          router.push(ChangeEmailRoute());
                        },
                        title: "Change Email",
                        icon: Assets.icons.emailOutline,
                      ),
                      TileWidget(
                        top: 10.r,
                        onTap: () {
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) =>
                                  DeleteDialogWidget(onCancel: () {
                                    router.popForced();
                                  }, onDelete: () {
                                    context.read<SettingsEmrBloc>().add(
                                        DeleteEmployerEvent(
                                            employerID:
                                                currentUser!.employerId));
                                  }));
                        },
                        title: "Delete Organization",
                        icon: Assets.icons.deleteOutline,
                      ),
                      LogoutTileWidget(
                          onTap: () =>
                              _logoutDialog(context, currentUser!.employerId)),
                    ],
                  ),
                ),
                const Gap(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _imageDialog(
    BuildContext context,
    ShowImageDialogState state,
  ) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) => ImageDialogWidget(
        onPressed: () {
          final authBloc = context.read<AuthEmrBloc>();
          authBloc.add(UploadProfileImageEvent(state.newimage));
        },
        image: state.newimage,
      ),
    );
  }

  void _logoutDialog(BuildContext context, String employerID) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => LogOutDialogWidget(
        onCancel: () {
          router.maybePop();
        },
        onLogout: () {
          context.read<AuthEmrBloc>().add(LogoutEvent(employerID: employerID));
          router.replaceAll([const UserSelectionRoute()]);
        },
      ),
    );
  }
}
