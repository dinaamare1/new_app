import 'package:new_app/features/grocery/domain/entities/options_entity.dart';
class Grocery {
  final String id;
  final String title;
  final String imageUrl;
  final double rating;
  final double price;
  final double discount;
  final String Description;
  final List<OptionsEntity> option;

  Grocery({required this.id, required this.title, required this.imageUrl, required this.rating, required this.price, required this.discount, required this.Description, required this.option});
}