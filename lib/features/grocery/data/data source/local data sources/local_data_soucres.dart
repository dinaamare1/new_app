import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:new_app/core/Failure/failure.dart';
import 'package:new_app/features/grocery/data/data%20source/local%20data%20sources/local_contrats.dart';
import 'package:new_app/features/grocery/data/models/grocery_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroceryLocalDataSources implements LocalContract {
  final SharedPreferences sharedPreferences;

  GroceryLocalDataSources({required this.sharedPreferences});

  static const String CACHED_GROCERIES = 'CACHED_GROCERIES';
  static const String CART_ITEMS = 'CART_ITEMS';

  @override
  Future<Either<Failure, List<GroceryModel>>> getCachedGroceries() async {
    try {
      final jsonString = sharedPreferences.getString(CACHED_GROCERIES);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        final groceries = jsonList.map((json) => GroceryModel.fromJson(json)).toList();
        return Right(groceries);
      } else {
        return Left(CacheFailure("No cached data"));
      }
    } catch (e) {
      return Left(CacheFailure("error getting cached data"));
    }
  }

  @override
  Future<Either<Failure, GroceryModel>> getCachedGrocery(String id) async {
  try {
    final jsonString = sharedPreferences.getString(CACHED_GROCERIES);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      GroceryModel? foundGrocery;

      for (var json in jsonList) {
        final grocery = GroceryModel.fromJson(json);
        if (grocery.id == id) {
          foundGrocery = grocery;
          break;
        }
      }

      if (foundGrocery != null) {
        return Right(foundGrocery);
      } else {
        return Left(CacheFailure("Could not find grocery with id: $id"));
      }
    } else {
      return Left(CacheFailure("No cached data to retrieve from"));
    }
  } catch (e) {
    return Left(CacheFailure("Error getting a single element: $e"));
  }
}


  @override
  Future<void> cacheGroceries(List<GroceryModel> groceries) async {
    final jsonString = json.encode(groceries.map((grocery) => grocery.toJson()).toList());
    await sharedPreferences.setString(CACHED_GROCERIES, jsonString);
  }

  @override
  Future<Either<Failure, GroceryModel>> addToCart(GroceryModel grocery) async {
    final jsonString = sharedPreferences.getString(CART_ITEMS);
    List<dynamic> jsonList = jsonString != null ? json.decode(jsonString) : [];
    jsonList.add(grocery.toJson());
    await sharedPreferences.setString(CART_ITEMS, json.encode(jsonList));
    return Right(grocery);
  }

  @override
  Future<Either<Failure, List<GroceryModel>>> getCartItems() async {
    try {
      final jsonString = sharedPreferences.getString(CART_ITEMS);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        final cartItems = jsonList.map((json) => GroceryModel.fromJson(json)).toList();
        return Right(cartItems);
      } else {
        return Left(CacheFailure("no items in cart"));
      }
    } catch (e) {
      return Left(CacheFailure("error getting cart items"));
    }
  }
}
