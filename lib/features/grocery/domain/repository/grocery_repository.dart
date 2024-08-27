import 'package:dartz/dartz.dart';
import 'package:new_app/core/Failure/failure.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';

abstract class GroceryRepository {
  Future<Either<Failure, List<Grocery>>> getGroceries();
  Future<Either<Failure, Grocery>> getGrocery(String id);
  Future<Either<Failure,Grocery >> addToCart(Grocery grocery);
  Future<Either<Failure, List<Grocery>>> getCart();
  
}