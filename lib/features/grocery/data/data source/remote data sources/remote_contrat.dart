import 'package:dartz/dartz.dart';
import 'package:new_app/core/Failure/failure.dart';
import 'package:new_app/features/grocery/data/models/grocery_model.dart';

abstract class RemoteContract {
  Future<Either<Failure, List<GroceryModel>>> getGroceries();
  Future<Either<Failure, GroceryModel>> getGrocery(String id);
}