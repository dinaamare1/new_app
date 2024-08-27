import 'package:dartz/dartz.dart';
import 'package:new_app/core/Failure/failure.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';
import 'package:new_app/features/grocery/domain/repository/grocery_repository.dart';

class GetCartUsecase {
  final GroceryRepository groceryRepository;

  GetCartUsecase({required this.groceryRepository});

  Future<Either<Failure, List<Grocery>>> execute() {
    return groceryRepository.getCart();
  }
}