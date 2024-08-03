// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:attendify_lite/app/features/employee/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:attendify_lite/app/features/employee/logs/presentation/bloc/logs_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.gr.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/gen/assets.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/bottom_bar_notch.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

@RoutePage()
class BaseEmpPage extends StatefulWidget {
  const BaseEmpPage({super.key});

  @override
  State<BaseEmpPage> createState() => _BaseEmpPageState();
}

class _BaseEmpPageState extends State<BaseEmpPage> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _connectivitySubscription;
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.none)) {
      context.read<HomeBloc>().add(CheckInternetEvent());
    }
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        context.read<HomeBloc>().add(CheckInternetEvent());
      }
    } on SocketException catch (_) {
      context.read<HomeBloc>().add(CheckInternetEvent());
    }
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    final authBloc = context.read<AuthEmpBloc>();
    final logsBloc = context.read<LogsBloc>();
    final homeBloc = context.read<HomeBloc>();

    homeBloc.add(FetchLastTransactionEvent(user: authBloc.state.user!));
    logsBloc.add(FetchLogsEvent(user: authBloc.state.user!));
    homeBloc.add(
        LocationPermissionEvent(locationId: authBloc.state.user!.locationId));

    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [LogsRoute(), HomeEmpRoute(), SettingsEmpRoute()],
      builder: (context, child) {
        final router = AutoTabsRouter.of(context);
        return Scaffold(
          body: SafeArea(child: child),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GestureDetector(
            onTap: () => router.setActiveIndex(1),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: context.color.primary.withOpacity(0.3),
              child: CircleAvatar(
                backgroundColor: context.color.primary,
                radius: 35,
                child: Assets.icons.homeFill.svg(
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: context.color.icon.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: BottomAppBar(
              shape: RectangleCircularNotched(radius: 42.0),
              notchMargin: 5,
              color: context.color.scaffoldBackgroundColor,
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
                    label: 'Log\'s',
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
}
