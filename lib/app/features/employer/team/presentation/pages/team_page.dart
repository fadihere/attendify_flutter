import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/data/models/team_model.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/team_bloc/team_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:attendify_lite/core/utils/extensions/utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:m7_livelyness_detection/index.dart';

import '../../../../../../core/utils/widgets/buttons.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../shared/widgets/pop_up_menu.dart';
import '../../../../employee/home/presentation/widgets/clock_widget.dart';
import '../widgets/dialogs.dart';

@RoutePage()
class TeamEmrPage extends StatelessWidget {
  const TeamEmrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: BlocBuilder<AuthEmrBloc, AuthEmrState>(
          builder: (context, state) {
            return Text(
              state.user!.organizationName.capitalize,
              style: const TextStyle(
                fontFamily: FontFamily.hellix,
              ),
            );
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.r),
              child: Column(
                children: [
                  const Gap(25),
                  const ClockWidget(),
                  AppButtonWidget(
                    width: 185.r,
                    margin: EdgeInsets.only(top: 25.r),
                    onTap: () {
                      router.push(const AddEmployeeRoute());
                    },
                    subText: "+",
                    text: ' ADD EMPLOYEE',
                    fontSize: 16.r,
                    textColor: context.color.white,
                  ),
                  const Gap(25),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          spreadRadius: 0.1,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: CustomTextFormField(
                      borderRadius: 100,
                      hintText: "Search",
                      borderEnabled: false,
                      fillColor: context.color.container,
                      onChanged: (value) {
                        final teamBloc = context.read<TeamBloc>();
                        teamBloc.add(SearchTeamEvent(text: value));
                      },
                    ),
                  ),
                  const Gap(10),
                  BlocBuilder<TeamBloc, TeamState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TabBarWidget(
                              onTap: () {
                                final teamBloc = context.read<TeamBloc>();
                                teamBloc.add(GetActiveTeamEvent());
                              },
                              name: 'Active',
                              isSelected: state.isActive,
                            ),
                            TabBarWidget(
                              onTap: () {
                                final teamBloc = context.read<TeamBloc>();
                                teamBloc.add(GetDeactiveTeamEvent());
                              },
                              name: 'Deactivated',
                              isSelected: !state.isActive,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Gap(15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: BlocConsumer<TeamBloc, TeamState>(
                        listener: (context, state) {
                          if (state.status == Status.success) {}
                          if (state.status == Status.loading) {
                            BotToast.showLoading();
                            return;
                          }
                          BotToast.closeAllLoading();
                        },
                        builder: (context, state) {
                          if (state.isActive && state.activeteam.isNotEmpty) {
                            return ListView.builder(
                              padding: EdgeInsets.only(bottom: 22.r),
                              shrinkWrap: true,
                              itemCount: state.activeteam.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final team = state.activeteam[index];

                                return ListTile(
                                  visualDensity: VisualDensity.compact,
                                  contentPadding: EdgeInsets.zero,
                                  horizontalTitleGap: 10.r,
                                  minVerticalPadding: 0,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(40.r),
                                    child: CircleAvatar(
                                      backgroundColor: context.color.outline,
                                      radius: 20.r,
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: CachedNetworkImage(
                                          imageUrl: team.imageUrl ?? '',
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Icon(
                                            Icons.person,
                                            color: context.color.white,
                                          ),
                                          errorWidget: (_, __, ___) => Icon(
                                            Icons.person,
                                            color: context.color.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    team.employeeName.capitalize,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    team.phoneNumber,
                                    style: TextStyle(color: context.color.hint),
                                  ),
                                  trailing: CustomPopupMenu(
                                    padding: EdgeInsets.zero,
                                    onSelected: (index) {
                                      switch (index) {
                                        case 0:
                                          router.push(
                                              TeamReportRoute(team: team));
                                          break;
                                        case 1:
                                          router.push(
                                            AssignLocationRoute(team: team),
                                          );
                                          break;
                                        case 2:
                                          _deactive(context, team);
                                          break;
                                        case 3:
                                          _showFaceScanDialog(context, team);
                                          break;
                                        case 4:
                                          router.push(
                                              ChangeTeamPhoneRoute(team: team));
                                          break;
                                        case 5:
                                          router.push(
                                              SetWorkTimeRoute(team: team));
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem<int>(
                                          height: 28.r,
                                          value: 0,
                                          child: CustomPopItem(
                                            icon: Assets.icons.copyOutline,
                                            title: "Reports",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 28.r,
                                          value: 1,
                                          child: CustomPopItem(
                                            icon: Assets.icons.locationOutline,
                                            title: "Assign Location",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 28.r,
                                          value: 3,
                                          child: CustomPopItem(
                                            icon: Assets.icons.personBoxOutline,
                                            title: "Update Face Scan",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 28.r,
                                          value: 4,
                                          child: CustomPopItem(
                                            icon: Assets.icons.contactOutline,
                                            title: "Update Phone",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 28.r,
                                          value: 5,
                                          child: CustomPopItem(
                                            icon:
                                                Assets.icons.personClockOutline,
                                            title: "Set Work Time",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 28.r,
                                          value: 2,
                                          child: CustomPopItem(
                                            icon: Assets
                                                .icons.deletePersonOutline,
                                            title: "Deactivate",
                                            color: Colors.red,
                                          ),
                                        ),
                                      ];
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          if (!state.isActive &&
                              state.deactiveteam.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.deactiveteam.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final user = state.deactiveteam[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: CircleAvatar(
                                      backgroundColor: context.color.outline,
                                      radius: 22,
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: CachedNetworkImage(
                                          imageUrl: user.imageUrl ?? '',
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Icon(
                                            Icons.person,
                                            color: context.color.white,
                                          ),
                                          errorWidget: (_, __, ___) => Icon(
                                            Icons.person,
                                            color: context.color.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(user.employeeName.capitalize),
                                  subtitle: Text(
                                    user.phoneNumber,
                                    style: TextStyle(color: context.color.hint),
                                  ),
                                  trailing: CustomPopupMenu(
                                    padding: EdgeInsets.zero,
                                    onSelected: (index) async {
                                      switch (index) {
                                        case 0:
                                          router.push(
                                              TeamReportRoute(team: user));
                                          break;
                                        case 1:
                                          router.push(
                                              AssignLocationRoute(team: user));
                                          break;
                                        case 2:
                                          _active(context, user);
                                          break;
                                        case 3:
                                          _showFaceScanDialog(context, user);
                                          break;
                                        case 4:
                                          router.push(
                                              ChangeTeamPhoneRoute(team: user));
                                          break;
                                        case 5:
                                          router.push(
                                              SetWorkTimeRoute(team: user));
                                          break;
                                        case 6:
                                          _delete(context, user);
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem<int>(
                                          height: 35,
                                          value: 0,
                                          child: CustomPopItem(
                                            icon: Assets.icons.copyOutline,
                                            title: "Reports",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 35,
                                          value: 1,
                                          child: CustomPopItem(
                                            icon: Assets.icons.locationOutline,
                                            title: "Assign Location",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 35,
                                          value: 2,
                                          child: CustomPopItem(
                                            icon: Assets.icons.checkOutline,
                                            title: "Active",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 35,
                                          value: 3,
                                          child: CustomPopItem(
                                            icon: Assets.icons.personBoxOutline,
                                            title: "Update Face Scan",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 35,
                                          value: 4,
                                          child: CustomPopItem(
                                            icon: Assets.icons.contactOutline,
                                            title: "Update Phone",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 35,
                                          value: 5,
                                          child: CustomPopItem(
                                            icon:
                                                Assets.icons.personClockOutline,
                                            title: "Set Work Time",
                                          ),
                                        ),
                                        PopupMenuItem<int>(
                                          height: 35,
                                          value: 6,
                                          child: CustomPopItem(
                                            icon: Assets.icons.deleteOutline,
                                            color: context.color.warning,
                                            title: "Delete",
                                          ),
                                        ),
                                      ];
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          return SizedBox(
                            height: 0.35.sh,
                            child: Center(
                              child: Text(
                                "No data available",
                                style: TextStyle(
                                  color: context.color.font,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showFaceScanDialog(BuildContext context, TeamModel team) async {
    await showAdaptiveDialog(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      builder: (_) => UploadFaceScanWidget(
        onChange: (image) {
          context
              .read<TeamBloc>()
              .add(UpdateEmployeeFace(image: image, team: team));
        },
      ),
    );
  }

  _deactive(BuildContext context, TeamModel team) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<TeamBloc, TeamState>(
          listener: (context, state) {
            if (state.status != Status.loading) {
              router.maybePop();
              return;
            }
          },
          builder: (context, state) {
            return ActionDialogWidget(
              actionText: 'Deactive',
              title: 'Deactive Employee',
              text: 'Are you sure you want to Deactive ${team.employeeName}?',
              onTap: () {
                final teamBloc = context.read<TeamBloc>();
                final user = context.read<AuthEmrBloc>().state.user!;
                teamBloc.add(
                  ArchiveTeamEvent(
                    team: team,
                    action: false,
                    user: user,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  _active(BuildContext context, TeamModel team) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<TeamBloc, TeamState>(
          listener: (context, state) {
            if (state.status != Status.loading) {
              router.maybePop();
              return;
            }
          },
          builder: (context, state) {
            return ActionDialogWidget(
              actionText: 'Active',
              title: 'Active Employee',
              text: 'Are you sure you want to Active ${team.employeeName}?',
              actionColor: context.color.primary,
              onTap: () {
                final teamBloc = context.read<TeamBloc>();
                final user = context.read<AuthEmrBloc>().state.user!;
                teamBloc.add(
                  ArchiveTeamEvent(
                    team: team,
                    action: true,
                    user: user,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  _delete(BuildContext context, TeamModel team) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<TeamBloc, TeamState>(
          listener: (context, state) {
            if (state.status != Status.loading) {
              router.maybePop();
              return;
            }
          },
          builder: (context, state) {
            return ActionDialogWidget(
              actionText: 'Delete',
              title: 'Delete Employee',
              text:
                  'Are you sure you want to Delete ${team.employeeName} permanently?',
              onTap: () {
                final teamBloc = context.read<TeamBloc>();
                final user = context.read<AuthEmrBloc>();
                teamBloc.add(
                    DeleteEmployeeEvent(team: team, user: user.state.user!));
              },
            );
          },
        );
      },
    );
  }
}

class TabBarWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final bool isSelected;
  const TabBarWidget({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      isSelected ? context.color.primary : Colors.transparent,
                  width: 1.0,
                ),
              ),
            ),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: !isSelected ? context.color.primary : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
