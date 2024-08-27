import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:new_app/features/grocery/data/data%20source/local%20data%20sources/local_contrats.dart';
import 'package:new_app/features/grocery/data/data%20source/local%20data%20sources/local_data_soucres.dart';
import 'package:new_app/features/grocery/data/data%20source/remote%20data%20sources/remote_data_sources.dart';
import 'package:new_app/features/grocery/data/repository/data_repository.dart';
import 'package:new_app/features/grocery/domain/repository/grocery_repository.dart';
import 'package:new_app/features/grocery/domain/usecase/add_grocery_to_cart_usecase.dart';
import 'package:new_app/features/grocery/domain/usecase/get_all_grocery_usecase.dart';
import 'package:new_app/features/grocery/domain/usecase/get_cart_usecase.dart';
import 'package:new_app/features/grocery/domain/usecase/get_single_grocery_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';


var locator = GetIt.instance;

Future<void> setUp() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  locator.registerLazySingleton<http.Client>(() => http.Client());

  locator.registerSingleton<Connectivity>(Connectivity());
  locator.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(connectivity: locator<Connectivity>()),
  );
  locator.registerLazySingleton<LocalContract>(
    () => GroceryLocalDataSources(sharedPreferences: locator<SharedPreferences>()),
  );
  locator.registerLazySingleton<GroceryLocalDataSources>(
    () => locator<LocalContract>() as GroceryLocalDataSources,
  );

  locator.registerLazySingleton<GroceryRemoteDataSources>(
    () => GroceryRemoteDataSources(client: locator<http.Client>()),
  );

  locator.registerLazySingleton<GroceryRepository>(
    () => GroceryRepositoryImpl(
      localDataSource: locator<GroceryLocalDataSources>(),
      networkInfo: locator<NetworkInfo>(),
      remoteDataSource: locator<GroceryRemoteDataSources>(),
    ),
  );

  locator.registerLazySingleton<GetGroceriesUsecase>(
    () => GetGroceriesUsecase(groceryRepository: locator<GroceryRepository>()),
  );
  locator.registerLazySingleton<GetCartUsecase>(
    () => GetCartUsecase(groceryRepository: locator<GroceryRepository>()),
  );
  locator.registerLazySingleton<AddGroceryToCartUsecase>(
    () => AddGroceryToCartUsecase(groceryRepository: locator<GroceryRepository>()),
  );
  locator.registerLazySingleton<GetSingleGroceryUsecase>(
    () => GetSingleGroceryUsecase(groceryRepository: locator<GroceryRepository>()),
  );
}

