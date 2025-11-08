import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/chef_followers_entity.dart';
import '../../repositories/chef_repository.dart';

class FetchChefFollowersUseCase
    implements
        UseCase<ChefFollowersEntity, FetchChefFollowersParams> {
  final ChefRepository repository;

  FetchChefFollowersUseCase(this.repository);

  @override
  Future<Either<Failure, ChefFollowersEntity>> call(
      FetchChefFollowersParams params) {
    return repository.fetchFollowers(params.userId, params.userType);
  }
}

class FetchChefFollowersParams {
  final String userId;
  final String userType;

  const FetchChefFollowersParams({
    required this.userId,
    required this.userType,
  });
}

