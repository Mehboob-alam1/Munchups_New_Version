import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/data_repository.dart';

class UpdateProfileParams {
  final Map<String, dynamic> body;
  final String? imagePath;

  const UpdateProfileParams({required this.body, this.imagePath});
}

class UpdateProfileUseCase
    implements UseCase<Map<String, dynamic>, UpdateProfileParams> {
  final DataRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      UpdateProfileParams params) {
    return repository.updateProfile(params.body, params.imagePath);
  }
}

