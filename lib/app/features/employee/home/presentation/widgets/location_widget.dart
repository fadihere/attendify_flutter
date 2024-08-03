import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employee/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/enums/status.dart';
import 'package:attendify_lite/core/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/gen/assets.gen.dart';

class CurrentLocationWidget extends StatelessWidget {
  final HomeBloc homeBloc;
  final AuthEmpBloc authBloc;
/*   final String? name;

  final VoidCallback? onTurn; */
  const CurrentLocationWidget(
      {super.key, required this.authBloc, required this.homeBloc
      /*  this.onTurn,
    required this.name, */
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.isConnected) {
          return Text(state.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ));
        }
        if (state.isMock || !state.isLocPermissionEnabled) {
          return /*  state.isFetchingLocation == Status.loading
              ? const SizedBox()
              : */
              Text(
            state.locMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.locationFill.svg(
              width: 15,
              height: 15,
              colorFilter: const ColorFilter.mode(
                Colors.red,
                BlendMode.srcIn,
              ),
            ),
            const Gap(5),
            Row(
              children: [
                Text(
                  'Location:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.hellix),
                ),
                const Gap(10),
                state.isFetchingLocation == Status.loading
                    ? SizedBox(
                        width: 15.r,
                        height: 15.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ))
                    : state.isFetchingLocation == Status.success
                        ? Text(
                            state.currentLocName,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: FontFamily.hellix),
                          )
                        : state.isFetchingLocation == Status.error
                            ? _TryAgainButton(onTap: () {
                                homeBloc.add(LocationPermissionEvent(
                                    locationId:
                                        authBloc.state.user!.locationId));
                              })
                            : const SizedBox()
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TryAgainButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _TryAgainButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.color.primary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Turn on",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: context.color.primary,
          ),
        ),
      ),
    );
  }
}
