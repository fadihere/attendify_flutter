// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employee/settings/presentation/widgets/dialogs.dart';
import 'package:attendify_lite/app/features/employee/settings/presentation/widgets/tile_widget.dart';
import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/bloc/theme_cubit/theme_cubit.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/constants/app_sizes.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/config/routes/app_router.dart';
import '../../../../../../core/utils/widgets/logout_tile_widget.dart';
import '../../../../../../core/utils/widgets/profile_avatar_widget.dart';
import '../../../../../shared/widgets/dialogs.dart';

@RoutePage()
class SettingsEmpPage extends StatelessWidget {
  const SettingsEmpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSize.overallPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(30),
              BlocConsumer<AuthEmpBloc, AuthEmpState>(
                listener: (context, state) {
                  if (state is ShowImageDialogState) {
                    _imageDialog(context, state);
                    return;
                  }
                },
                builder: (context, state) {
                  if (state.user != null) {
                    return ProfileAvatarWidget(
                      file: state.image,
                      onTap: () {
                        final authBloc = context.read<AuthEmpBloc>();
                        authBloc.add(
                          PickImageEvent(source: ImageSource.gallery),
                        );
                      },
                      name: state.user!.employeeName,
                      description: state.user!.organizationName,
                      imageUrl: state.user!.imageUrl,
                      employeeID: state.user!.employeeId,
                    );
                  }
                  return Offstage();
                },
              ),
              Gap(13),
              Container(
                decoration: dropShadowDecoration(context),
                child: Column(
                  children: [
                    TileWidget(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      top: 16.r,
                      onTap: () => router.push(LeaveDashboardRoute()),
                      title: "Manage Leaves",
                      icon: Assets.icons.calendarInfoOutline,
                    ),
                    TileWidget(
                      top: 10.r,
                      onTap: () => router.push(ChangePhoneNumRoute()),
                      title: "Change Phone Number",
                      icon: Assets.icons.phone,
                    ),
                    TileWidget(
                      top: 10.r,
                      onTap: () => router.push(ChangePasswordEmpRoute()),
                      title: "Change Password",
                      icon: Assets.icons.lockOutline,
                    ),
                    TileWidget(
                      top: 10.r,
                      onTap: () => _changeTheme(context),
                      title: "Dark Mode",
                      icon: Assets.icons.moonOutline,
                      surfix: IgnorePointer(
                        child: SizedBox(
                          height: 0,
                          child: Switch.adaptive(
                            activeColor: context.color.primary,
                            value:
                                Theme.of(context).brightness == Brightness.dark,
                            onChanged: (_) {},
                          ),
                        ),
                      ),
                    ),
                    LogoutTileWidget(onTap: () => _logoutDialog(context)),
                  ],
                ),
              )
            ],
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
          final authBloc = context.read<AuthEmpBloc>();
          authBloc.add(UploadProfileImageEvent(newImage: state.newimage));
        },
        image: state.newimage,
      ),
    );
  }

  void _logoutDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => LogOutDialogWidget(
        onCancel: () {
          router.maybePop();
        },
        onLogout: () {
          final user = context.read<AuthEmpBloc>().state.user;
          context.read<AuthEmpBloc>().add(
              LogoutEvent(empId: user!.employeeId, emrId: user.employerId));
          router.replaceAll([UserSelectionRoute()]);
        },
      ),
    );
  }

  _changeTheme(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark
        ? context.read<ThemeCubit>().setTheme(ThemeMode.light)
        : context.read<ThemeCubit>().setTheme(ThemeMode.dark);
  }
}
