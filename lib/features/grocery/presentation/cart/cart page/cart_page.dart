import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/features/grocery/presentation/cart/bloc/cart_bloc.dart';
import 'package:new_app/features/grocery/presentation/cart/bloc/cart_event.dart';
import 'package:new_app/features/grocery/presentation/cart/bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(const FetchGroceryfromlocalEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      body: BlocConsumer<CartBloc, CartPageState>(
        listener: (context, state) {
          if (state.status == CardPageStatusEnum.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error loading cart')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CardPageStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == CardPageStatusEnum.loaded && state.grocery != null) {
            final items = state.grocery!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text('Amount: ${item.price}'),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No items in the cart'));
          }
        },
      ),
    );
  }
}
