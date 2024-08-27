import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';
import 'package:new_app/features/grocery/domain/usecase/get_all_grocery_usecase.dart';
import 'home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomePageState> {
  final GetGroceriesUsecase getGroceriesUsecase;
  
  HomeBloc({required this.getGroceriesUsecase}) : super(const HomePageState(status: HomePageStatusEnum.homeInitial)){

    on<FetchAllGrocery>(_fetch);
     
  }
  FutureOr<void> _fetch(FetchAllGrocery event, Emitter<HomePageState> emit) async {
    emit(state.copyWith(status: HomePageStatusEnum.homeLoading));


    final result = await getGroceriesUsecase.execute();
    print("result2: $result");
    result.fold(
      (failure) => emit(state.copyWith(status: HomePageStatusEnum.homeError)),
      (grocerys) => emit(state.copyWith(status: HomePageStatusEnum.homeLoaded, grocerys: grocerys)),
    );
  }
  }
