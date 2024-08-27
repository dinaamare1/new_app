import 'package:new_app/features/grocery/data/models/options_model.dart';
import 'package:new_app/features/grocery/domain/entities/grocery_entity.dart';

class GroceryModel extends Grocery {
  GroceryModel({
    required String id,
    required String title,
    required String imageUrl,
    required double rating,
    required double price,
    required double discount,
    required String description, // Corrected the field name
    required List<OptionsModel> options, // Corrected to be a list of options
  }) : super(
          id: id,
          title: title,
          imageUrl: imageUrl,
          rating: rating,
          price: price,
          discount: discount,
          Description: description, // Use correct field name in super
          option: options, // Use correct field name in super
        );

  factory GroceryModel.fromJson(Map<String, dynamic> json) {
    return GroceryModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num).toDouble(), // Ensure double type
      price: (json['price'] as num).toDouble(),   // Ensure double type
      discount: (json['discount'] as num).toDouble(), // Ensure double type
      description: json['description'], // Corrected field name
      options: (json['options'] as List<dynamic>).map((optionJson) {
        return OptionsModel.fromJson(optionJson);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'rating': rating,
      'price': price,
      'discount': discount,
      'description': Description, // Corrected field name
      'options': option.map((opt) => (opt as OptionsModel).toJson()).toList(),
    };
  }
}
