import 'package:flutter/material.dart';
import 'package:country_state_city_dropdown/country_state_city_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Country State City Picker')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CountryStateCityPicker(
            onCountryChanged: (country) => print("Country: ${country.name}"),
            onStateChanged: (state) => print("State: ${state.name}"),
            onCityChanged: (city) => print("City: ${city.name}"),
            spacing: 10,
          ),
        ),
      ),
    );
  }
}
