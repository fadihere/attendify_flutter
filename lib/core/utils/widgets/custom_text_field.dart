import 'package:attendify_lite/core/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final bool? enabled;
  final bool borderEnabled;
  final String? labelText;
  final String? hintText;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String? value)? validator;
  final TextCapitalization? textCapitalization;
  final Widget? prefixIcon;
  final Color? labelCustomColor;
  final bool obscureText;
  final double borderRadius;
  final bool isDense;
  final Color? fillColor;
  final int? maxLength;
  final bool enableInteractiveSelection;

  const CustomTextFormField(
      {super.key,
      this.controller,
      this.labelText,
      this.onTap,
      this.readOnly,
      this.enabled,
      this.maxLines,
      this.validator,
      this.suffixIcon,
      this.keyboardType,
      this.onChanged,
      this.hintText,
      this.minLines,
      this.textCapitalization,
      this.inputFormatters,
      this.prefixIcon,
      this.labelCustomColor,
      this.obscureText = false,
      this.borderRadius = 32,
      this.isDense = true,
      this.borderEnabled = true,
      this.fillColor,
      this.maxLength,
      this.enableInteractiveSelection = true});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: enableInteractiveSelection,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 16,
      ),
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      controller: controller,
      inputFormatters: inputFormatters,
      onTap: onTap,
      validator: validator,
      readOnly: readOnly ?? false,
      cursorColor: context.color.primary,
      minLines: minLines ?? 1,
      maxLength: maxLength,
      cursorErrorColor: context.color.primary,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        disabledBorder: InputBorder.none,
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIconConstraints: BoxConstraints(
          maxWidth: prefixIcon == null ? 20 : 60,
          minWidth: prefixIcon == null ? 20 : 60,
        ),
        isDense: isDense,
        suffixIconConstraints: BoxConstraints(
          maxWidth: suffixIcon == null ? 20 : 90,
          minWidth: suffixIcon == null ? 20 : 60,
        ),
        prefixIcon:
            Center(child: Transform.scale(scale: 1.0, child: prefixIcon)),
        fillColor: fillColor ?? context.color.scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.only(
          left: 30,
          right: 20,
          top: 12,
          bottom: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: context.color.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: context.color.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: context.color.outline,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: context.color.primary,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: context.color.primary,
          ),
        ),
        filled: true,
        suffixIcon: suffixIcon,
        suffixIconColor: Colors.black,
        labelText: labelText,
        floatingLabelStyle: const TextStyle(fontSize: 12),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: context.color.hint,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
            fontSize: 14,
            // fontWeight: FontWeight.bold,
            color: context.color.hint,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
