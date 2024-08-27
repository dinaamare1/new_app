import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/features/grocery/domain/usecase/add_grocery_to_cart_usecase.dart';
import 'package:new_app/features/grocery/domain/usecase/get_all_grocery_usecase.dart';
import 'package:new_app/features/grocery/domain/usecase/get_cart_usecase.dart';
import 'package:new_app/features/grocery/domain/usecase/get_single_grocery_usecase.dart';
import 'package:new_app/features/grocery/presentation/Home/bloc/home_bloc.dart';
import 'package:new_app/features/grocery/presentation/cart/bloc/cart_bloc.dart';
import 'package:new_app/features/grocery/presentation/cart/cart%20page/cart_page.dart';
import 'package:new_app/features/grocery/presentation/details/bloc/details_bloc.dart';
import 'package:new_app/service_provider.dart';
import 'package:new_app/spalsh_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(
            getGroceriesUsecase: locator<GetGroceriesUsecase>(),
          )..add(const FetchAllGrocery()),
        ),
        BlocProvider(
          create: (context) => DetailsBloc(
            addGroceryToCartUsecase: locator<AddGroceryToCartUsecase>(),
            getSingleGroceryUsecase: locator<GetSingleGroceryUsecase>(),)
            ,
        ),
        BlocProvider(
          create: (context) => CartBloc(
            getCartUsecase: locator<GetCartUsecase>(),)
            ,
        ),
        

      ],
      child: 
       MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CartPage(),
        color: Colors.white,
      
    )
    );
  }
}
