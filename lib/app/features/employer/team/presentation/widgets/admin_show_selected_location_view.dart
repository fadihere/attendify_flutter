// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/utils/widgets/buttons.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../place_picker/entities/location_result.dart';

class AdminShowSelectedLocationView extends StatefulWidget {
  AdminShowSelectedLocationView({
    super.key,
    required this.locationResult,
  });

  LocationResult locationResult;

  @override
  State<AdminShowSelectedLocationView> createState() =>
      _AdminShowSelectedLocationViewState();
}

class _AdminShowSelectedLocationViewState
    extends State<AdminShowSelectedLocationView> {
  // int employerID;
  String? selectedValue;

  int? selectedID;

  late String lat;

  late String long;
  late TextEditingController controller;

  void addLocationName(BuildContext context, LocationResult result, radius) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        TextEditingController locationNameController =
            TextEditingController(text: result.name ?? "");

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Location Name",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(9),
                CustomTextFormField(
                  hintText: "hint here",
                  controller: locationNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                const Gap(15),
                AppButtonWidget(
                  margin: EdgeInsets.zero,
                  onTap: () {},
                  text: "SAVE",
                  color: context.color.primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double radius = 100.0;

  @override
  void initState() {
    controller = TextEditingController(text: widget.locationResult.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void increaseRadius() {
      setState(() {
        radius += 50.0;
      });
    }

    void decreaseRadius() {
      setState(() {
        if (radius != 0) {
          radius -= 50.0;
        }
      });
    }

    Set<Circle> circles = {
      Circle(
        circleId: const CircleId("1"),
        center: LatLng(widget.locationResult.latLng!.latitude,
            widget.locationResult.latLng!.longitude),
        radius: radius,
        fillColor: context.color.primary.withOpacity(0.5),
        strokeColor: Colors.transparent,
      )
    };

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark),
          // titleSpacing: 1,
          backgroundColor: Colors.transparent,
          leadingWidth: width / 12,
          leading: IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.symmetric(horizontal: width / 22),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          title: TextField(
            controller: controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                fillColor: context.color.whiteBlack),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: widget.locationResult.latLng!, zoom: 16),
              // onMapCreated: (GoogleMapController controller) {
              //   _controller.complete(controller);
              // },
              onCameraMove: null,
              circles: circles,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: height * 0.15, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          increaseRadius();
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Radius"),
                              Icon(
                                Icons.add,
                                color: Color(0xff222222),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          decreaseRadius();
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Radius"),
                              Icon(
                                Icons.remove,
                                color: Color(0xff222222),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              right: 0,
              left: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: height * 0.068,
                child: ElevatedButton.icon(
                  onPressed: () {
                    addLocationName(context, widget.locationResult, Radius);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "CONFIRM LOCATION",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(
                      Color.fromRGBO(99, 158, 255, 1),
                    ),
                    shape: const MaterialStatePropertyAll(
                      StadiumBorder(),
                    ),
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.only(
                        top: height * 0.021,
                        bottom: height * 0.02,
                        left: width * 0.052,
                        right: width * 0.063,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
