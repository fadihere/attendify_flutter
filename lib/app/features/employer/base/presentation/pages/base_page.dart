import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/home/presentation/bloc/adm_home_bloc.dart';
import 'package:attendify_lite/app/features/employer/location/presentation/bloc/pick_location_bloc.dart';
import 'package:attendify_lite/app/features/employer/notifications/presentation/blocs/noti_emr_bloc.dart';
import 'package:attendify_lite/app/features/employer/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/team_bloc/team_bloc.dart';
import 'package:attendify_lite/app/shared/widgets/bottom_bar_notch.dart';
import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../leave/presentation/bloc/leave_emr_bloc.dart';

@RoutePage()
class BaseEmrPage extends StatefulWidget {
  const BaseEmrPage({super.key});

  @override
  State<BaseEmrPage> createState() => _BaseEmrPageState();
}

class _BaseEmrPageState extends State<BaseEmrPage> {
  @override
  void initState() {
    final authBloc = context.read<AuthEmrBloc>();
    final teamBloc = context.read<TeamBloc>();
    final homeBloc = context.read<AdmHomeBloc>();
    final locationBloc = context.read<PickLocationBloc>();
    final settingsBloc = context.read<SettingsEmrBloc>();
    final notiBloc = context.read<NotiEmrBloc>();
    final employerID = authBloc.state.user!.employerId;
    authBloc.add(SaveTokenEvent(employerID: employerID));

    teamBloc.add(GetMyTeamEvent(user: authBloc.state.user!));
    homeBloc
      ..add(GetAttendenceSummaryEvent(employerId: employerID))
      ..add(GetRequestsEvent(employerId: employerID));
    locationBloc.add(FetchAllLocationsEvent(employerID: employerID));
    settingsBloc.add(FetchOfficeHrsEvent(employerID: employerID));
    notiBloc.add(FetchNotificationsEvent(employerID: employerID));
    context
        .read<LeaveEmrBloc>()
        .add(FetchLeavesPolicyEvent(employerID: employerID));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [TeamEmrRoute(), AdmHomeRoute(), AdmSettingsRoute()],
      builder: (context, child) {
        final router = AutoTabsRouter.of(context);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: RefreshIndicator(
            onRefresh: () async => _init(),
            child: SafeArea(child: child),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GestureDetector(
            onTap: () => router.setActiveIndex(1),
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: context.color.primary.withOpacity(0.3),
              child: CircleAvatar(
                backgroundColor: context.color.primary,
                radius: 35,
                child: Assets.icons.homeFill.svg(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: boxShadow(context),
            ),
            child: BottomAppBar(
              shape: RectangleCircularNotched(radius: 42.0),
              notchMargin: 5,
              color: context.color.container,
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                selectedItemColor: context.color.primary,
                unselectedItemColor: context.color.icon,
                currentIndex: router.activeIndex,
                elevation: 0,
                unselectedFontSize: 12,
                selectedFontSize: 12,
                type: BottomNavigationBarType.fixed,
                onTap: router.setActiveIndex,
                items: [
                  BottomNavigationBarItem(
                    label: 'My Team',
                    icon: Assets.icons.logsOutline.svg(
                      colorFilter: ColorFilter.mode(
                        context.color.icon,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: Assets.icons.logsOutline.svg(
                      colorFilter: ColorFilter.mode(
                        context.color.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const BottomNavigationBarItem(label: '', icon: Offstage()),
                  BottomNavigationBarItem(
                    label: 'Settings',
                    icon: Assets.icons.settings.svg(
                      colorFilter: ColorFilter.mode(
                        context.color.icon,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: Assets.icons.settings.svg(
                      colorFilter: ColorFilter.mode(
                        context.color.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _init() {
    final authBloc = context.read<AuthEmrBloc>();
    final teamBloc = context.read<TeamBloc>();
    final homeBloc = context.read<AdmHomeBloc>();
    final locationBloc = context.read<PickLocationBloc>();
    final settingsBloc = context.read<SettingsEmrBloc>();
    final notiBloc = context.read<NotiEmrBloc>();
    final employerID = authBloc.state.user!.employerId;
    authBloc.add(SaveTokenEvent(employerID: employerID));

    teamBloc.add(GetMyTeamEvent(user: authBloc.state.user!));
    homeBloc
      ..add(GetAttendenceSummaryEvent(employerId: employerID))
      ..add(GetRequestsEvent(employerId: employerID));
    locationBloc.add(FetchAllLocationsEvent(employerID: employerID));
    settingsBloc.add(FetchOfficeHrsEvent(employerID: employerID));
    notiBloc.add(FetchNotificationsEvent(employerID: employerID));
    context
        .read<LeaveEmrBloc>()
        .add(FetchLeavesPolicyEvent(employerID: employerID));
  }
}
