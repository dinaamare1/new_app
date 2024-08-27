import 'package:equatable/equatable.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';

sealed class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchProductEvent extends DetailsEvent {
  final String id;
  const FetchProductEvent({required this.id});
}
class AddToCartEvent extends DetailsEvent {
  final Grocery grocery;
  const AddToCartEvent({required this.grocery});
  
}