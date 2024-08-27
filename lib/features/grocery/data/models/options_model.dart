import 'package:new_app/features/grocery/domain/entities/options_entity.dart';

class OptionsModel extends OptionsEntity {
  OptionsModel({
    required String id,
    required String name,
    required double price,
  }) : super(
          id: id,
          name: name,
          price: price,
        );

  factory OptionsModel.fromJson(Map<String, dynamic> json) {
    return OptionsModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
