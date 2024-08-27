import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';
import 'package:new_app/features/grocery/domain/usecase/add_grocery_to_cart_usecase.dart';
import 'package:new_app/features/grocery/domain/usecase/get_single_grocery_usecase.dart';
import 'package:new_app/features/grocery/presentation/details/bloc/details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsPageState> {
  final GetSingleGroceryUsecase getSingleGroceryUsecase;
  final AddGroceryToCartUsecase addGroceryToCartUsecase;

  DetailsBloc({ 
    required this.getSingleGroceryUsecase,
    required this.addGroceryToCartUsecase,

  }) : super(const DetailsPageState()) {
    on<FetchProductEvent>(_fetch);
    on<AddToCartEvent>(_addToCart);
    
  }
  FutureOr<void> _fetch(FetchProductEvent event, Emitter<DetailsPageState> emit) async {
    emit(state.copyWith(status: DetailsPageStatusEnum.loading));
    final result = await getSingleGroceryUsecase.execute(event.id);
    result.fold(
      (failure) => emit(state.copyWith(status: DetailsPageStatusEnum.error)),
      (grocery) => emit(state.copyWith(status: DetailsPageStatusEnum.loaded, grocery: grocery)),
    );
  }


  FutureOr<void> _addToCart(AddToCartEvent event, Emitter<DetailsPageState> emit) async {
    final result = await addGroceryToCartUsecase.execute(event.grocery);
    result.fold(
      (failure) => emit(state.copyWith(status: DetailsPageStatusEnum.notadded)),
      (grocery) => emit(state.copyWith(status: DetailsPageStatusEnum.added, grocery: grocery)),
    );
  }
}