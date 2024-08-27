import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  const Failure(this.message);
  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;
  ValidationFailure(this.message) : super(message);
}
class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message) : super(message);
}
class CacheFailure extends Failure {
  final String message;
  CacheFailure(this.message) : super(message);
}