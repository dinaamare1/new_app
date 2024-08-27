import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';
import 'package:new_app/features/grocery/presentation/Home/bloc/home_bloc.dart';
import 'package:new_app/features/grocery/presentation/Home/bloc/home_state.dart';
import 'package:new_app/features/grocery/presentation/details/details%20page/detail_page.dart'; // Import the details page

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Burger',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  suffixIcon: const Icon(Icons.tune_outlined),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocConsumer<HomeBloc, HomePageState>(
                  listener: (context, state) {
                    if (state.status == HomePageStatusEnum.homeError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error loading groceries')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.status == HomePageStatusEnum.homeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == HomePageStatusEnum.homeLoaded) {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 23,
                        ),
                        itemCount: state.grocerys?.length ?? 0,
                        itemBuilder: (context, index) {
                          final grocery = state.grocerys![index];
                          return GroceryItemCard(
                            grocery: grocery,
                            height: 400, // Adjust this value as needed
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No groceries available.'));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroceryItemCard extends StatelessWidget {
  final Grocery grocery;
  final double height;

  const GroceryItemCard({
    required this.grocery,
    this.height = 700, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(id: grocery.id, grocery: grocery),
          ),
        );
      },
      child: Container(
        height: height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(grocery.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              grocery.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  grocery.rating.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '€${grocery.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
