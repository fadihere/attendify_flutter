import 'package:attendify_lite/core/bloc/user_cubit/user_cubit.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/routes/app_router_observer.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc/theme_cubit/theme_cubit.dart';

class AttendifyLite extends StatefulWidget {
  const AttendifyLite({super.key});

  @override
  State<AttendifyLite> createState() => _AttendifyLiteState();
}

class _AttendifyLiteState extends State<AttendifyLite>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<UserCubit>().init();
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    // context.read<ThemeCubit>().updateAppTheme();
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: routerKey,
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          context.select((ThemeCubit themeCubit) => themeCubit.state.themeMode),
      localizationsDelegates: const [CountryLocalizations.delegate],
      routerConfig: router.config(
        navigatorObservers: () => [AppRouterObserver()],
      ),
    );
  }
}

final routerKey = GlobalKey<ScaffoldMessengerState>();
