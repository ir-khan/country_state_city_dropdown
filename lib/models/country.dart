import 'state_model.dart';

class Country {
  final int id;
  final String name;
  final List<StateModel> states;

  Country({required this.id, required this.name, required this.states});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      states:
          (json['states'] as List).map((e) => StateModel.fromJson(e)).toList(),
    );
  }
}
