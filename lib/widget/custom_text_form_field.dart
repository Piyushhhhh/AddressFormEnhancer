import 'dart:async';
import 'package:benjamin/controler/address_form_controler.dart';
import 'package:benjamin/widget/outlined_input_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Custom TextFormField with additional features like suggestions and dropdown.
class CustomTextFormField extends StatefulWidget {
  final String? labelText; // Label text for the TextFormField.
  final Widget? label; // Optional label widget for more customization.
  final String? initialValue; // Initial text value of the field.
  final FormFieldValidator<String>?
      validator; // Validator function for validation.
  final TextCapitalization textCapitalization; // Text capitalization style.
  final int? maxLength; // Maximum allowed length of the input.
  final TextInputAction?
      textInputAction; // Action to perform when pressing input action button.
  final ValueChanged<String>?
      onChanged; // Callback when the input value changes.
  final FormFieldSetter<String>? onSaved; // Callback when saving the form.
  final List<TextInputFormatter>?
      inputFormatters; // Input formatters for custom text input.
  final TextInputType? keyboardType; // Keyboard type for the input.
  final Iterable<String>?
      autofillHints; // Autofill hints for better user experience.
  final bool readOnly; // Whether the field is read-only.
  final List<String> suggestions; // List of suggestions for autocomplete.
  final TextEditingController?
      textEditingController; // Controller for text field.
  final List<String>? dropdownItems; // List of items for dropdown menu.

  const CustomTextFormField({
    super.key,
    this.labelText,
    this.label,
    this.initialValue,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.inputFormatters,
    this.keyboardType,
    this.autofillHints,
    this.readOnly = false,
    this.suggestions = const [],
    this.dropdownItems,
    this.textEditingController,
  });

  @override
  State createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final _key = GlobalKey<FormFieldState>(); // Key for the FormField state.
  late TextEditingController _controller; // Controller for managing text input.
  final _focusNode = FocusNode(); // Focus node for managing focus events.
  Timer? _debounce; // Timer for debounce mechanism.
  bool _hasError = false; // Flag to track validation error state.
  List<String> _filteredSuggestions = []; // List to hold filtered suggestions.

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with provided or new controller.
    if (widget.textEditingController != null) {
      _controller = widget.textEditingController ?? TextEditingController();
    } else {
      _controller = TextEditingController();
    }
    // Add listener to the controller for text changes.
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Dispose of resources when widget is disposed.
    _debounce?.cancel(); // Cancel debounce timer if active.
    _controller.dispose(); // Dispose of text controller.
    _focusNode.dispose(); // Dispose of focus node.
    super.dispose();
  }

  /// Listener callback for text changes in the text field.
  void _onTextChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel(); // Cancel debounce timer if active.
    }
    // Set a debounce timer to filter suggestions after a delay.
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        setState(() {
          if (_controller.text.length >= 2) {
            // Filter suggestions based on input text.
            _filteredSuggestions = widget.suggestions
                .where((suggestion) => suggestion
                    .toLowerCase()
                    .contains(_controller.text.toLowerCase()))
                .toList();
          } else {
            _filteredSuggestions =
                []; // Clear suggestions if input length is less than 2.
          }
        });
      },
    );
  }

  /// Validator function to validate the input value.
  String? _validate(String? value) {
    final result = widget.validator
        ?.call(value); // Validate using provided validator function.

    bool newHasError =
        result != null; // Check if validation result indicates an error.
    // Update error state if it has changed.
    if (newHasError != _hasError) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _hasError = newHasError;
        });
      });
    }

    return result; // Return validation result.
  }

  /// Callback when a suggestion item is tapped.
  void _onSuggestionTap(String suggestion) {
    final addressFormModel = Provider.of<AddressController>(context,
        listen: false); // Access form model using Provider.
    setState(() {
      _controller.text =
          suggestion; // Set text field value to selected suggestion.
      addressFormModel
          .updateEntireAdress(suggestion); // Update address in form model.
      _filteredSuggestions = []; // Clear suggestions list.
    });

    // Delayed state update to ensure UI reflects changes.
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {});
    });

    // Unfocus the text field to dismiss keyboard and suggestions.
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.unfocus();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine suffix icon based on field state and error status.
    final Widget? suffixIcon;
    if (widget.readOnly) {
      suffixIcon = null; // No suffix icon if field is read-only.
    } else {
      if (_hasError) {
        suffixIcon = const Icon(Icons.warning,
            color: Colors.red); // Warning icon for validation error.
      } else if (_controller.text.isNotEmpty && _focusNode.hasFocus) {
        // Dropdown or clear icon based on input state.
        suffixIcon = Transform(
          transform: Matrix4.translationValues(0, 8, 0),
          child: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            icon: Icon(
              widget.dropdownItems == null
                  ? Icons.clear
                  : Icons.arrow_drop_down,
              color: Colors.black,
            ),
            onPressed: () {
              _controller.clear(); // Clear text field.
              widget.onChanged?.call(""); // Trigger onChanged callback.
            },
          ),
        );
      } else {
        suffixIcon = null; // No suffix icon in default state.
      }
    }

    // Build the TextFormField with provided properties and customizations.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TextFormField(
              key: _key,
              controller: _controller,
              focusNode: _focusNode,
              onTapOutside: (event) {
                // Dismiss keyboard when tapping outside the form fields
                FocusManager.instance.primaryFocus?.unfocus();
              },
              style: const TextStyle(fontSize: 14, color: Colors.black),
              validator: _validate,
              autovalidateMode:
                  null, // Disable auto-validation for manual control.
              textCapitalization: widget.textCapitalization,
              maxLength: widget.maxLength,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onSaved: widget.onSaved,
              inputFormatters: [
                ...?widget.inputFormatters,
                LengthLimitingTextInputFormatter(
                    100), // Limit total characters to 100.
                FilteringTextInputFormatter.allow(RegExp(
                    r'^[a-zA-Z0-9\s.,#\-]+$')), // Allow only letters, numbers, spaces, commas, dots, hashes, and dashes.
              ],
              keyboardType: widget.keyboardType,
              autofillHints: widget.autofillHints,
              readOnly: widget.readOnly,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.05),
                border: OutlinedInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: widget.readOnly
                    ? null
                    : OutlinedInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                        innerBorderSide: BorderSide(
                          color: Colors.black.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                labelText: widget.labelText,
                label: widget.label,
                labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
                floatingLabelStyle:
                    const TextStyle(fontSize: 12, color: Colors.black),
                errorStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.5),
                ),
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.5),
                ),
                suffixIcon: widget.dropdownItems == null
                    ? suffixIcon
                    : PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width - 42,
                          maxHeight: MediaQuery.of(context).size.height / 2.5,
                        ),
                        offset: const Offset(
                            0, 60), // Offset to position the dropdown menu.
                        onSelected: (String value) {
                          _controller.text =
                              value; // Set text field value on selection.
                        },
                        itemBuilder: (BuildContext context) {
                          return (widget.dropdownItems ?? [])
                              .map<PopupMenuItem<String>>(
                                (String value) => PopupMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList();
                        },
                      ),
                counter: const SizedBox.shrink(), // Hide counter widget.
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ],
        ),
        // Display suggestions list when available and field is focused.
        if (_filteredSuggestions.isNotEmpty && _focusNode.hasFocus)
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredSuggestions[index]),
                  onTap: () {
                    _onSuggestionTap(_filteredSuggestions[
                        index]); // Handle tap on suggestion item.
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
