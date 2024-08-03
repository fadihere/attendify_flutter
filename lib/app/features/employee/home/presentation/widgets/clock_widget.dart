import 'package:attendify_lite/core/bloc/time_cubit/time_cubit.dart';
import 'package:attendify_lite/core/bloc/time_cubit/time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/gen/fonts.gen.dart';

class ClockWidget extends StatefulWidget {
  final Color? color;
  const ClockWidget({super.key, this.color});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeCubit, TimeState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                text: state.time.substring(0, state.time.length - 2),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 48,
                    height: 1,
                    color: widget.color,
                    fontFamily: FontFamily.hellix),
                children: [
                  const WidgetSpan(child: SizedBox(width: 5)),
                  TextSpan(
                    text: state.time
                        .substring(state.time.length - 2, state.time.length),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: widget.color,
                        fontFamily: FontFamily.hellix),
                  )
                ],
              ),
            ),
            Text(
              '${state.day}, ${state.dMy}',
              style: TextStyle(
                  fontSize: 17,
                  color: widget.color,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.hellix),
            )
          ],
        );
      },
    );
  }
}
