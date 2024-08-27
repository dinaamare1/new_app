import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';
import 'package:new_app/features/grocery/domain/usecase/get_cart_usecase.dart';
import 'package:new_app/features/grocery/domain/usecase/get_single_grocery_usecase.dart';
import 'package:new_app/features/grocery/presentation/cart/bloc/cart_event.dart';
import 'package:new_app/features/grocery/presentation/cart/bloc/cart_state.dart';
import 'package:new_app/features/grocery/presentation/details/bloc/details_event.dart';

class CartBloc extends Bloc<CartEvent, CartPageState> {
final GetCartUsecase getCartUsecase;
  CartBloc({ 
    required this.getCartUsecase,

  }) : super(const CartPageState()) {
    on<FetchGroceryfromlocalEvent>(_fetch);
    
    
  }
  FutureOr<void> _fetch(FetchGroceryfromlocalEvent event, Emitter<CartPageState> emit) async{
    emit(state.copyWith(status: CardPageStatusEnum.loading));
    final result = await getCartUsecase.execute();
    result.fold(
      (failure) => emit(state.copyWith(status: CardPageStatusEnum.error)),
      (grocery) => emit(state.copyWith(status: CardPageStatusEnum.loaded, grocery: grocery)),
    );
  }
}