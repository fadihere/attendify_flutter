// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'camera_bloc.dart';

class CameraState extends Equatable {
  final Status status;
  final CameraController? controller;
  final CameraLensDirection direction;
  final File? image;

  const CameraState({
    this.controller,
    this.direction = CameraLensDirection.front,
    this.status = Status.initial,
    this.image,
  });
  @override
  List<Object?> get props => [controller, direction, status, image];

  CameraState copyWith({
    Status? status,
    CameraController? controller,
    CameraLensDirection? direction,
    File? image,
  }) {
    return CameraState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
      direction: direction ?? this.direction,
      image: image ?? this.image,
    );
  }

  @override
  bool get stringify => true;
}
