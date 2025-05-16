import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/country.dart';
import '../models/state_model.dart';
import '../models/city.dart';

class CountryStateCityPicker extends StatefulWidget {
  final void Function(Country)? onCountryChanged;
  final void Function(StateModel)? onStateChanged;
  final void Function(City)? onCityChanged;
  final double spacing;

  const CountryStateCityPicker({
    super.key,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    this.spacing = 12,
  });

  @override
  State<CountryStateCityPicker> createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  List<Country> countries = [];
  Country? _selectedCountry;
  StateModel? _selectedState;
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'packages/country_state_city_dropdown/assets/data/country_state_city.json',
      );
      final List<dynamic> jsonList = json.decode(jsonStr);
      countries = jsonList.map((e) => Country.fromJson(e)).toList();
      setState(() {});
    } catch (e) {
      debugPrint('Error loading country/state/city data: $e');
    }
  }

  Future<List<Country>> _getCountries(String filter, LoadProps? props) async {
    return countries
        .where((c) => c.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Future<List<StateModel>> _getStates(String filter, LoadProps? props) async {
    final states = _selectedCountry?.states ?? [];
    return states
        .where((s) => s.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Future<List<City>> _getCities(String filter, LoadProps? props) async {
    final cities = _selectedState?.cities ?? [];
    return cities
        .where((c) => c.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: widget.spacing,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownSearch<Country>(
          items: _getCountries,
          itemAsString: (c) => c.name,
          selectedItem: _selectedCountry,
          compareFn: (a, b) => a.id == b.id,
          onChanged: (country) {
            setState(() {
              _selectedCountry = country;
              _selectedState = null;
              _selectedCity = null;
            });
            if (country != null) widget.onCountryChanged?.call(country);
          },
          enabled: countries.isNotEmpty,
          popupProps: const PopupProps.menu(showSearchBox: true),
        ),
        DropdownSearch<StateModel>(
          items: _getStates,
          itemAsString: (s) => s.name,
          selectedItem: _selectedState,
          compareFn: (a, b) => a.id == b.id,
          onChanged: (state) {
            setState(() {
              _selectedState = state;
              _selectedCity = null;
            });
            if (state != null) widget.onStateChanged?.call(state);
          },
          enabled: _selectedCountry != null,
          popupProps: const PopupProps.menu(showSearchBox: true),
        ),
        DropdownSearch<City>(
          items: _getCities,
          itemAsString: (c) => c.name,
          selectedItem: _selectedCity,
          compareFn: (a, b) => a.id == b.id,
          onChanged: (city) {
            setState(() {
              _selectedCity = city;
            });
            if (city != null) widget.onCityChanged?.call(city);
          },
          enabled: _selectedState != null,

          popupProps: const PopupProps.menu(showSearchBox: true),
        ),
      ],
    );
  }
}
