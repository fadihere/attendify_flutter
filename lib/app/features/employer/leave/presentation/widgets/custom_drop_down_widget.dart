import 'package:flutter/material.dart';

class CustomDropdownButtonFormField extends FormField<String> {
  final List<DropdownMenuItem<String>>? items;
  final ValueChanged<String?>? onChanged;
  final InputDecoration? decoration;
  final double? dropdownWidth;

  CustomDropdownButtonFormField({
    super.key,
    String? value,
    this.items,
    this.onChanged,
    this.decoration,
    this.dropdownWidth, // Default width if not specified
  }) : super(
          initialValue: value,
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: decoration ??
                  const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
              isEmpty: value == null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isDense: true,
                  onChanged: onChanged,
                  items: items,
                  selectedItemBuilder: (BuildContext context) {
                    return items?.map<Widget>((DropdownMenuItem<String> item) {
                          return SizedBox(
                            width: dropdownWidth,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: item.child,
                            ),
                          );
                        }).toList() ??
                        [];
                  },
                  dropdownColor: Colors.white,
                  itemHeight: kMinInteractiveDimension,
                  menuMaxHeight: 150,
                ),
              ),
            );
          },
        );
}
