import 'package:dartz/dartz.dart';
import 'package:new_app/core/Failure/failure.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';
import 'package:new_app/features/grocery/domain/repository/grocery_repository.dart';

class AddGroceryToCartUsecase {
  final GroceryRepository groceryRepository;

  AddGroceryToCartUsecase({required this.groceryRepository});

  Future<Either<Failure,Grocery>> execute(Grocery grocery) async {
    return groceryRepository.addToCart(grocery);
  }
}