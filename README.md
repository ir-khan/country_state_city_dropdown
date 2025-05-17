# 🌍 Country State City Dropdown

A Flutter package that provides dynamic, cascading dropdowns for selecting **Country**, **State**, and **City** using local JSON data. Built with full customizability and search functionality.

## ✨ Features

✅ Cascading dropdowns (Country → State → City)  
✅ Built-in search with `OverlayEntry`  
✅ No external dependencies  
✅ Form-friendly and highly customizable  
✅ Dark mode/theme support  
✅ Easy integration

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
            spacing: 10,
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

This project is licensed under the MIT License.

---

Made with ❤️ by @ir-khan
