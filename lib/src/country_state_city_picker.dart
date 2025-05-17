import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/country.dart';
import 'models/state_model.dart';
import 'models/city.dart';
import 'widgets/searchable_dropdown.dart';

/// A widget that allows users to pick Country, State, and City
/// with searchable dropdowns for each level.
///
/// Designed for maximum customization by package users.
class CountryStateCityPicker extends StatefulWidget {
  /// Called when user selects a country.
  final void Function(Country)? onCountryChanged;

  /// Called when user selects a state.
  final void Function(StateModel)? onStateChanged;

  /// Called when user selects a city.
  final void Function(City)? onCityChanged;

  /// Vertical spacing between dropdowns.
  final double spacing;

  /// Decorations for each dropdown's TextFormField.
  final InputDecoration? countryDecoration;
  final InputDecoration? stateDecoration;
  final InputDecoration? cityDecoration;

  /// Custom builders for dropdown list items.
  final Widget Function(Country)? countryItemBuilder;
  final Widget Function(StateModel)? stateItemBuilder;
  final Widget Function(City)? cityItemBuilder;

  /// Widget to show when no search results found.
  final Widget? emptyResultWidget;

  /// Text style inside the TextFormField.
  final TextStyle? textStyle;

  /// Text style for items inside dropdown list.
  final TextStyle? listItemTextStyle;

  /// Icon shown at the end of the TextFormField.
  final Icon? suffixIcon;

  /// Field-specific validators
  final FormFieldValidator<String>? countryValidator;
  final FormFieldValidator<String>? stateValidator;
  final FormFieldValidator<String>? cityValidator;

  const CountryStateCityPicker({
    super.key,
    this.onCountryChanged,
    this.onStateChanged,
    this.onCityChanged,
    this.spacing = 12,
    this.countryDecoration,
    this.stateDecoration,
    this.cityDecoration,
    this.countryItemBuilder,
    this.stateItemBuilder,
    this.cityItemBuilder,
    this.emptyResultWidget,
    this.textStyle,
    this.listItemTextStyle,
    this.suffixIcon,
    this.countryValidator,
    this.stateValidator,
    this.cityValidator,
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

  /// Loads country, state, city data from local JSON file
  /// Adjust asset path if necessary
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

  /// Default InputDecoration for dropdown text fields if user does not provide one.
  InputDecoration _defaultDecoration(String label) {
    return InputDecoration(
      labelText: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: widget.spacing,
      children: [
        // Country dropdown
        SearchableDropdown<Country>(
          items: countries,
          itemAsString: (c) => c.name,
          selectedItem: _selectedCountry,
          onChanged: (country) {
            setState(() {
              _selectedCountry = country;
              _selectedState = null;
              _selectedCity = null;
            });
            if (country != null) widget.onCountryChanged?.call(country);
          },
          decoration: widget.countryDecoration ?? _defaultDecoration("Country"),
          itemBuilder: widget.countryItemBuilder,
          textStyle: widget.textStyle,
          listItemTextStyle: widget.listItemTextStyle,
          suffixIcon: widget.suffixIcon,
          emptyResultWidget: widget.emptyResultWidget,
          validator: widget.countryValidator,
        ),

        // State dropdown
        SearchableDropdown<StateModel>(
          items: _selectedCountry?.states ?? [],
          itemAsString: (s) => s.name,
          selectedItem: _selectedState,
          onChanged: (state) {
            setState(() {
              _selectedState = state;
              _selectedCity = null;
            });
            if (state != null) widget.onStateChanged?.call(state);
          },
          enabled: _selectedCountry != null,
          decoration: widget.stateDecoration ?? _defaultDecoration("State"),
          itemBuilder: widget.stateItemBuilder,
          textStyle: widget.textStyle,
          listItemTextStyle: widget.listItemTextStyle,
          suffixIcon: widget.suffixIcon,
          emptyResultWidget: widget.emptyResultWidget,
          validator: widget.stateValidator,
        ),

        // City dropdown
        SearchableDropdown<City>(
          items: _selectedState?.cities ?? [],
          itemAsString: (c) => c.name,
          selectedItem: _selectedCity,
          onChanged: (city) {
            setState(() {
              _selectedCity = city;
            });
            if (city != null) widget.onCityChanged?.call(city);
          },
          enabled: _selectedState != null,
          decoration: widget.cityDecoration ?? _defaultDecoration("City"),
          itemBuilder: widget.cityItemBuilder,
          textStyle: widget.textStyle,
          listItemTextStyle: widget.listItemTextStyle,
          suffixIcon: widget.suffixIcon,
          emptyResultWidget: widget.emptyResultWidget,
          validator: widget.cityValidator,
        ),
      ],
    );
  }
}
