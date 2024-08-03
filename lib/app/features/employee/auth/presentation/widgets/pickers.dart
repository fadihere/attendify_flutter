import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/gen/fonts.gen.dart';

void countryCodePicker(
  BuildContext context, {
  required void Function(Country) onSelect,
}) {
  return showCountryPicker(
    context: context,
    useSafeArea: true,
    showPhoneCode: true,
    countryListTheme: CountryListThemeData(
      flagSize: 25,
      searchTextStyle: const TextStyle(
        fontFamily: FontFamily.hellix,
      ),
      backgroundColor: context.color.scaffoldBackgroundColor,
      textStyle: TextStyle(fontSize: 16, color: context.color.font),
      bottomSheetHeight: 1.sh,
      borderRadius: BorderRadius.circular(32),
      inputDecoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 30,
          top: 15,
          bottom: 15,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          color: context.color.hint,
          fontFamily: FontFamily.hellix,
        ),
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: context.color.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: context.color.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: context.color.outline,
          ),
        ),
      ),
    ),
    onSelect: onSelect,
  );
}
