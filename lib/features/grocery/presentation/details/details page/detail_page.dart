import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';
import 'package:new_app/features/grocery/presentation/Home/home%20page/home_page.dart';
import 'package:new_app/features/grocery/presentation/details/bloc/details_bloc.dart';
import 'package:new_app/features/grocery/presentation/details/bloc/details_event.dart';

class DetailPage extends StatefulWidget {
  final String id;
  final Grocery grocery;

  const DetailPage({Key? key, required this.id, required this.grocery}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _quantity = 1;
  Map<String, bool> _selectedOptions = {};

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  void _updateOptionSelection(String optionId, bool? isSelected) {
    setState(() {
      _selectedOptions[optionId] = isSelected ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<DetailsBloc>().add(FetchProductEvent(id: widget.id));
  }

  double _calculateTotalPrice(Grocery grocery) {
    double basePrice = grocery.price * (1 - (grocery.discount / 100));
    double optionsPrice = grocery.option
        .where((option) => _selectedOptions[option.id] == true)
        .fold(0.0, (sum, option) => sum + option.price);
    return (basePrice + optionsPrice) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsBloc, DetailsPageState>(
      listener: (context, state) {
        if (state.status == DetailsPageStatusEnum.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error loading details')),
          );
        } else if (state.status == DetailsPageStatusEnum.added) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added to basket')),
          );
        } else if (state.status == DetailsPageStatusEnum.notadded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add item to basket')),
          );
        }
      },
      builder: (context, state) {
        if (state.status == DetailsPageStatusEnum.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == DetailsPageStatusEnum.loaded) {
          final grocery = state.grocery!;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            grocery.imageUrl,
                            width: double.infinity,
                            height: 286,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                grocery.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  if (grocery.discount > 0)
                                    Text(
                                      '€${grocery.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '€${_calculateTotalPrice(grocery).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 24.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    '${grocery.rating}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      'See all reviews',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                grocery.Description,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20.0),
                              if (grocery.option.isNotEmpty) ...[
                                const Text(
                                  'Additional details',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: .0),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: grocery.option.length,
                                  itemBuilder: (context, index) {
                                    final option = grocery.option[index];
                                    return ListTile(
                                      title: Row(
                                        children: [
                                          Text(option.name),
                                          const SizedBox(width: 10),
                                          const Spacer(),
                                          Text(
                                            '€${option.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Checkbox(
                                        value: _selectedOptions[option.id] ?? false,
                                        onChanged: (value) {
                                          _updateOptionSelection(option.id, value);
                                        },
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 35.0,
                    left: 18,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            );
                        },
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 0.20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _decrementQuantity,
                          icon: const Icon(Icons.remove),
                          padding: EdgeInsets.zero,
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed: _incrementQuantity,
                          icon: const Icon(Icons.add),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DetailsBloc>().add(AddToCartEvent(grocery: grocery));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.shopping_cart, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Add to Basket', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
