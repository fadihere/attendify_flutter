part of 'camera_bloc.dart';

sealed class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class InitCameraEvent extends CameraEvent {
  final CameraLensDirection direction;

  const InitCameraEvent({this.direction = CameraLensDirection.front});

  @override
  List<Object?> get props => [direction];
}

class ToggleCameraEvent extends CameraEvent {}

class CaptureImageEvent extends CameraEvent {}
