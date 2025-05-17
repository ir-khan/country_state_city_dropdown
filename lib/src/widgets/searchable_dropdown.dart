import 'package:flutter/material.dart';

/// A generic searchable dropdown widget implemented using an
/// editable TextFormField combined with an overlay dropdown list.
///
/// Allows users to type and filter from a list of items, and select
/// an item from the filtered results. Suitable for any data type `T`
/// with customizable display, styling, and interaction.
///
///
/// ### Features:
/// - Search/filter dropdown items dynamically based on user input.
/// - Overlay dropdown positioned right below the text field.
/// - Customizable item display with optional itemBuilder.
/// - Handles empty results with a customizable empty widget.
/// - Can be enabled/disabled.
/// - Customizable styles, decorations, and icons.
///
///
/// ### Usage:
/// ```dart
/// SearchableDropdown<String>(
///   items: ['Apple', 'Banana', 'Cherry'],
///   selectedItem: 'Banana',
///   itemAsString: (item) => item,
///   onChanged: (item) => print('Selected: $item'),
///   decoration: InputDecoration(labelText: 'Select fruit'),
/// )
/// ```
///
///
/// ### Important:
/// - The widget uses a [TextEditingController] internally to track
///   user input and filter the list.
/// - Selection updates the input text and triggers `onChanged`.
/// - Overlay is shown when the text field is focused, and hides
///   on losing focus or item selection.
/// - Can be customized with [itemBuilder] to render custom widgets
///   for dropdown items.
///
class SearchableDropdown<T> extends StatefulWidget {
  /// The list of all selectable items.
  final List<T> items;

  /// The currently selected item.
  final T? selectedItem;

  /// Converts an item of type `T` into a string to display.
  final String Function(T) itemAsString;

  /// Callback when user selects an item from dropdown.
  final void Function(T?) onChanged;

  /// Decoration applied to the input TextFormField.
  final InputDecoration decoration;

  /// Whether the dropdown is enabled or disabled.
  final bool enabled;

  /// Optional custom builder to display each dropdown list item.
  final Widget Function(T)? itemBuilder;

  /// Text style for the input field.
  final TextStyle? textStyle;

  /// Text style for dropdown list items.
  final TextStyle? listItemTextStyle;

  /// Suffix icon shown inside the TextFormField.
  final Icon? suffixIcon;

  /// Widget to show when no filtered results are found.
  final Widget? emptyResultWidget;

  /// Optional validator for form validation.
  final FormFieldValidator<String>? validator;

  /// Creates a searchable dropdown with customizable properties.
  const SearchableDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.itemAsString,
    required this.onChanged,
    this.decoration = const InputDecoration(),
    this.enabled = true,
    this.itemBuilder,
    this.textStyle,
    this.listItemTextStyle,
    this.suffixIcon,
    this.emptyResultWidget,
    this.validator,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final LayerLink _layerLink = LayerLink();

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();

    _filteredItems = widget.items;

    // Initialize controller text if selected item exists.
    if (widget.selectedItem != null) {
      _controller.text = widget.itemAsString(widget.selectedItem as T);
    }

    // Show overlay when text field gains focus.
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && widget.enabled) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });

    // Filter items when user types in the text field.
    _controller.addListener(_onTextChanged);
  }

  /// Filters the items based on the current text input.
  void _onTextChanged() {
    final query = _controller.text.toLowerCase();

    setState(() {
      _filteredItems =
          widget.items
              .where(
                (item) =>
                    widget.itemAsString(item).toLowerCase().contains(query),
              )
              .toList();
    });

    _refreshOverlay();
  }

  /// Inserts the dropdown overlay into the Overlay stack.
  void _showOverlay() {
    _removeOverlay(); // Remove any existing overlay first
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Removes the dropdown overlay if visible.
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Marks the overlay to rebuild when filtered items change.
  void _refreshOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry?.markNeedsBuild();
    });
  }

  /// Builds the dropdown overlay with filtered items.
  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 5),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child:
                      _filteredItems.isEmpty
                          ? widget.emptyResultWidget ??
                              const ListTile(title: Text('No results found'))
                          : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              return InkWell(
                                onTap: () {
                                  _controller.text = widget.itemAsString(item);
                                  widget.onChanged(item);
                                  _focusNode.unfocus();
                                },
                                child:
                                    widget.itemBuilder?.call(item) ??
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        widget.itemAsString(item),
                                        style: widget.listItemTextStyle,
                                      ),
                                    ),
                              );
                            },
                          ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void didUpdateWidget(covariant SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller text if selected item changes externally.
    if (widget.selectedItem != oldWidget.selectedItem) {
      _controller.text =
          widget.selectedItem != null
              ? widget.itemAsString(widget.selectedItem as T)
              : '';
    }

    // Update filtered items if the items list changes externally.
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
      _refreshOverlay();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        style: widget.textStyle,
        validator: widget.validator,
        decoration: widget.decoration.copyWith(
          suffixIcon: widget.suffixIcon ?? const Icon(Icons.arrow_drop_down),
        ),
        readOnly: false, // Allow typing for search/filter
      ),
    );
  }
}
