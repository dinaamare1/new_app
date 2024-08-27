import 'package:equatable/equatable.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class FetchGroceryfromlocalEvent extends CartEvent {
  const FetchGroceryfromlocalEvent();
}