import 'package:dartz/dartz.dart';
import 'package:new_app/core/Failure/failure.dart';
import 'package:new_app/features/grocery/data/models/grocery_model.dart';

abstract class LocalContract {
  Future<Either<Failure, List<GroceryModel>>> getCachedGroceries();
  Future<Either<Failure, GroceryModel>> getCachedGrocery(String id);
  Future<void> cacheGroceries(List<GroceryModel> groceries);
  Future<Either<Failure, GroceryModel>>  addToCart(GroceryModel grocery);
  Future<Either<Failure, List<GroceryModel>>> getCartItems();
}
