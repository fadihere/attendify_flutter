// ignore_for_file: public_member_api_docs, sort_constructors_first, invalid_use_of_visible_for_testing_member
import 'package:attendify_lite/app/features/employer/singular/presentation/bloc/singular_bloc.dart';
import 'package:attendify_lite/core/config/routes/app_router.dart';
import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../widgets/pin_button.dart';

@RoutePage()
class SetupPin1Page extends StatefulWidget {
  final String title;
  const SetupPin1Page({
    super.key,
    required this.title,
  });

  @override
  State<SetupPin1Page> createState() => _SetupPin1PageState();
}

class _SetupPin1PageState extends State<SetupPin1Page> {
  @override
  void initState() {
    context.read<SingularBloc>().emit(const SingularState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.color.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Set a pin",
            style: TextStyle(color: context.color.white),
          ),
          leading: router.canPop()
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: router.maybePop,
                )
              : const Offstage(),
        ),
        body: BlocBuilder<SingularBloc, SingularState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.color.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.all(10),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: index < state.pin.length
                            ? context.color.white
                            : context.color.white.withOpacity(0.2),
                      ),
                    ),
                  ).toList(),
                ),
                const Gap(50),
                Column(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: PinButton(
                              number: 1 + (3 * i) + index,
                              onChange: (number) {
                                if (number != null) {
                                  context
                                      .read<SingularBloc>()
                                      .add(AddSetup1Event(pin: number));
                                  return;
                                }
                                context
                                    .read<SingularBloc>()
                                    .add(ClearPin1Event());
                              },
                            ),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Gap(80),
                        PinButton(
                          number: 0,
                          onChange: (number) {},
                        ),
                        PinButton(
                          icon: Icons.backspace_rounded,
                          onChange: (number) {
                            if (number != null) {
                              context
                                  .read<SingularBloc>()
                                  .add(AddSetup1Event(pin: number));
                              return;
                            }
                            context.read<SingularBloc>().add(ClearPin1Event());
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            );
          },
        ));
  }
}
