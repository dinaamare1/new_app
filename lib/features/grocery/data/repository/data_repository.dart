import 'package:dartz/dartz.dart';
import 'package:new_app/core/Failure/failure.dart';
import 'package:new_app/core/network/network_info.dart';
import 'package:new_app/features/grocery/data/data%20source/local%20data%20sources/local_contrats.dart';
import 'package:new_app/features/grocery/data/data%20source/local%20data%20sources/local_data_soucres.dart';
import 'package:new_app/features/grocery/data/data%20source/remote%20data%20sources/remote_contrat.dart';
import 'package:new_app/features/grocery/data/data%20source/remote%20data%20sources/remote_data_sources.dart';
import 'package:new_app/features/grocery/data/models/grocery_model.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';
import 'package:new_app/features/grocery/domain/repository/grocery_repository.dart';

class GroceryRepositoryImpl implements GroceryRepository {
  final RemoteContract remoteDataSource;
  final LocalContract localDataSource;
  final NetworkInfo networkInfo;

  GroceryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Grocery>>> getGroceries() async {
    print("here");
    final isConnected = await networkInfo.isConnected();
    print('Network Connected: $isConnected');
    if (isConnected) {
        print("here2");
        final remoteGroceries = await remoteDataSource.getGroceries();
        print("result: $remoteGroceries");
        remoteGroceries.fold(
          (failure) => throw failure,
          (groceries) async {
            await localDataSource.cacheGroceries(groceries);
          },
        );
        return remoteGroceries.map((groceryModels) =>
            groceryModels.map<Grocery>((model) => model as Grocery).toList());
    } else {
      return localDataSource.getCachedGroceries()
        .then((result) => result.map((groceryModels) =>
          groceryModels.map<Grocery>((model) => model as Grocery).toList()));
    }
  }

  @override
  Future<Either<Failure, Grocery>> getGrocery(String id) async {
    if (await networkInfo.isConnected()) {
      try {
        final remoteGrocery = await remoteDataSource.getGrocery(id);
        return remoteGrocery.map<Grocery>((model) => model as Grocery);
      } catch (e) {
        return Left(ServerFailure("Error fetching grocery from server"));
      }
    } else {
      return localDataSource.getCachedGrocery(id)
        .then((result) => result.map<Grocery>((model) => model as Grocery));
    }
  }

  @override
  Future<Either<Failure, Grocery>> addToCart(Grocery grocery) async {
    try {
      final groceryModel = grocery as GroceryModel;
      await localDataSource.addToCart(groceryModel);
      return Right(grocery);
    } catch (e) {
      return Left(CacheFailure("Error adding to cart"));
    }
  }

  @override
  Future<Either<Failure, List<Grocery>>> getCart() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      return cartItems.map((groceryModels) =>
          groceryModels.map<Grocery>((model) => model as Grocery).toList());
    } catch (e) {
      return Left(CacheFailure("Error retrieving cart items"));
    }
  }
}
