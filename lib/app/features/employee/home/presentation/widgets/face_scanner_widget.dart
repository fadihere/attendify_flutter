import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:gap/gap.dart';
import 'package:m7_livelyness_detection/index.dart';

import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/utils/res/constants.dart';

class FaceScannerWidget extends StatelessWidget {
  const FaceScannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: AppSize.sidePadding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    child: const Text(
                      AppConstants.capturePhoto,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  IconButton(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.cancel,
                        color: context.color.icon,
                      ),
                      onPressed: () {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
              AspectRatio(
                aspectRatio: 9 / 15,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: M7LivelynessDetectionScreen(
                    config: M7DetectionConfig(
                      allowAfterMaxSec: true,
                      captureButtonColor: context.color.primaryColor,
                      steps: [
                        M7LivelynessStepItem(
                          step: M7LivelynessStep.blink,
                          isCompleted: false,
                        ),
                      ],
                      startWithInfoScreen: false,
                    ),
                  ),
                ),
              ),
              const Gap(18)
            ],
          ),
        ),
      ],
    );
  }
}
