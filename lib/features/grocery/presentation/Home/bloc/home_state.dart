import 'package:equatable/equatable.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';

enum HomePageStatusEnum { homeInitial, homeLoading, homeLoaded, homeError,homeLoggedOut }

class HomePageState extends Equatable {
  final HomePageStatusEnum status;
  final List<Grocery>? grocerys;


  const HomePageState({
    this.status = HomePageStatusEnum.homeInitial,
    this.grocerys,
  });
  HomePageState copyWith(
   { HomePageStatusEnum? status,
    List<Grocery>? grocerys,
    String? name,}
  ) {
    return HomePageState(
      status: status ?? this.status,
      grocerys: grocerys ?? this.grocerys,
    );
  }
  
  @override
  List<Object?> get props => [status, grocerys];
}
