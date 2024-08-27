part of 'details_bloc.dart';

enum DetailsPageStatusEnum { initial, loading, loaded, error,added ,notadded}

class DetailsPageState {
  final DetailsPageStatusEnum status;
  final Grocery? grocery ;
  const DetailsPageState({
    this.status = DetailsPageStatusEnum.initial,
    this.grocery,
  });
  DetailsPageState copyWith({
    DetailsPageStatusEnum? status,
    Grocery? grocery,
  }) {
    return DetailsPageState(
      status: status ?? this.status,
      grocery: grocery ?? this.grocery,
    );
  }
}