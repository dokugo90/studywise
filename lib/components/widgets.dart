import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get_it/get_it.dart';

import '../utils/styles.dart';

class PrimaryTextField extends StatefulWidget {
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
 final TextInputType? keyboardType;
 final String hintText;
 final Color fillColor;
 final Color hintColor;
  PrimaryTextField(
      {super.key,
      this.onChanged,
      this.controller,
      this.keyboardType,
      required this.hintText,
      required this.fillColor,
      required this.hintColor});

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool darkMode = GetIt.instance.get<ThemeService>().darkMode;
  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: widget.hintColor,
            fontWeight: FontWeight.w700,
            fontSize: 17),
        filled: true,
        fillColor: widget.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
      ),
      cursorColor: mainColor,
    );
  }
}
