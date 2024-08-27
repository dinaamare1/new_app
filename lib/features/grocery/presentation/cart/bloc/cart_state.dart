
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';

enum CardPageStatusEnum { initial, loading, loaded, error,deleted }

class CartPageState {
  final CardPageStatusEnum status;
  final List<Grocery>? grocery ;
  const CartPageState({
    this.status = CardPageStatusEnum.initial,
    this.grocery,
  });
  CartPageState copyWith({
    CardPageStatusEnum? status,
    List<Grocery>? grocery,
  }) {
    return CartPageState(
      status: status ?? this.status,
      grocery: grocery ?? this.grocery,
    );
  }
}