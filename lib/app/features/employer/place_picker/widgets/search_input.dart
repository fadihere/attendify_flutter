import 'dart:async';

import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  final ValueChanged<String> onSearchInput;

  const SearchInput(this.onSearchInput, {super.key});

  @override
  State<StatefulWidget> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
  TextEditingController editController = TextEditingController();

  Timer? debouncer;

  bool hasSearchEntry = false;

  //SearchInputState();

  @override
  void initState() {
    super.initState();
    editController.addListener(onSearchInputChange);
  }

  @override
  void dispose() {
    editController.removeListener(onSearchInputChange);
    editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (editController.text.isEmpty) {
      debouncer?.cancel();
      widget.onSearchInput(editController.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer?.cancel();
    }

    debouncer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchInput(editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: CustomTextFormField(
        fillColor: context.color.dialogBackgroundColor,
        hintText: 'Search location here...',
        suffixIcon: hasSearchEntry
            ? GestureDetector(
                child: const Icon(Icons.clear),
                onTap: () {
                  editController.clear();
                  setState(() {
                    hasSearchEntry = false;
                  });
                },
              )
            : null,
        controller: editController,
        onChanged: (value) {
          setState(() {
            hasSearchEntry = value.isNotEmpty;
          });
        },
      ),
    );

    /*  SizedBox(width: 8),
          if (this.hasSearchEntry)
            GestureDetector(
              child: Icon(Icons.clear),
              onTap: () {
                this.editController.clear();
                setState(() {
                  this.hasSearchEntry = false;
                });
              },
            ), */
  }
}
