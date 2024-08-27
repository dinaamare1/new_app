import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:new_app/core/Failure/failure.dart';
import 'package:http/http.dart' as http;
import 'package:new_app/features/grocery/data/data%20source/remote%20data%20sources/remote_contrat.dart';
import 'package:new_app/features/grocery/data/models/grocery_model.dart';

class GroceryRemoteDataSources implements RemoteContract {
  final http.Client client;

  GroceryRemoteDataSources({required this.client});

  @override
  Future<Either<Failure, List<GroceryModel>>> getGroceries() async {
    try {
      final response = await client.get(
        Uri.parse("https://g5-flutter-learning-path-be.onrender.com/api/v1/groceries"),
      );

      if (response.statusCode == 200) {

        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse['data'];

        final groceries = jsonList.map((json) {
          return GroceryModel.fromJson(json);
        }).toList();
        return Right(groceries);
      } else {
        return Left(ServerFailure("Error ${response.statusCode}"));
      }
    } catch (e) {
      return Left(ServerFailure("An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, GroceryModel>> getGrocery(String id) async {
    try {
      final response = await client.get(
        Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/groceries/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final grocery = GroceryModel.fromJson(jsonResponse['data']);
        return Right(grocery);
      } else {
        return Left(ServerFailure("Error ${response.statusCode}"));
      }
    } catch (e) {
      return Left(ServerFailure("An unexpected error occurred"));
    }
  }
}
