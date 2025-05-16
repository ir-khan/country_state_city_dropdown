# 🌍 Country State City Dropdown

A Flutter package to provide cascading dropdowns for **Country**, **State**, and **City** selections using your own JSON data. This widget is theme-adaptive and works well with light and dark themes.

## ✨ Features

- 🌐 Country, State, City dropdowns
- 🔄 Dynamic population based on selection
- 🎨 Theme adaptive
- 📦 Easily integratable in forms

## 🚀 Getting Started

Add the dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  country_state_city_dropdown: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## 📦 Usage

Here’s a basic example of how to use the package:

```dart
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
            spacing: 30,
          ),
        ),
      ),
    );
  }
}
```

This will show 3 dropdowns that dynamically update based on previous selections.

## 📁 Example

Check the `/example` folder for a complete working demo.

## 📄 License

MIT License

---

Made with ❤️ in Flutter
