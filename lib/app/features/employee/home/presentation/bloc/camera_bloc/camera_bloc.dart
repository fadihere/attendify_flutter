import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../../../../../../../core/enums/status.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(const CameraState()) {
    on<InitCameraEvent>(_initCamera);
    on<CaptureImageEvent>(_captureImage);
    on<ToggleCameraEvent>(_flipCamera);
  }
  _initCamera(
    InitCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final cameras = await availableCameras();
    final camera =
        cameras.firstWhere((e) => e.lensDirection == event.direction);
    final newState = state.copyWith(
      direction: event.direction,
      controller: CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      ),
    );
    await newState.controller?.initialize();
    await newState.controller
        ?.lockCaptureOrientation(DeviceOrientation.portraitUp);
    emit(newState.copyWith(status: Status.success));
  }

  @override
  Future<void> close() {
    state.controller?.dispose();
    return super.close();
  }

  FutureOr<void> _flipCamera(
    ToggleCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    await state.controller?.dispose();
    if (state.direction == CameraLensDirection.back) {
      add(const InitCameraEvent(direction: CameraLensDirection.front));
      return;
    }
    add(const InitCameraEvent(direction: CameraLensDirection.back));
  }

  FutureOr<void> _captureImage(
    CaptureImageEvent event,
    Emitter<CameraState> emit,
  ) async {
    final file = await state.controller?.takePicture();
    log((file == null).toString());
    if (file == null) return;
    final image = File(file.path);
    emit(state.copyWith(image: image));
  }
}
