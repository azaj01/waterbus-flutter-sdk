// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/core/api/base/usecase.dart';
import 'package:waterbus_sdk/core/api/user/repositories/user_repository.dart';
import 'package:waterbus_sdk/types/error/failures.dart';

@injectable
class UploadAvatar implements UseCase<String, UploadAvatarParams> {
  final UserRepository repository;

  UploadAvatar(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadAvatarParams params) async {
    return await repository.uploadImageToS3(
      uploadUrl: params.uploadUrl,
      image: params.image,
    );
  }
}

class UploadAvatarParams extends Equatable {
  final String uploadUrl;
  final Uint8List image;

  const UploadAvatarParams({
    required this.uploadUrl,
    required this.image,
  });

  @override
  List<Object> get props => [uploadUrl, image];
}
