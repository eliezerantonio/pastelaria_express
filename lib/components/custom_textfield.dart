import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key key,
    this.hintText,
    @required this.prefixIcon,
    @required this.onSaved,
    @required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.initialValue,
    this.validator,
  }) : super(key: key);

  String hintText;
  Widget prefixIcon;
  String labelText;
  bool obscureText = false;
  void Function(String) onSaved;
  String Function(String) validator;
  TextInputType keyboardType;
  String initialValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(3),
        prefixIconColor: Colors.white,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.pink[300],
                      Colors.orange[300],
                    ])),
            child: prefixIcon,
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey[400])),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.pink[300])),
        labelText: labelText,
      ),
    );
  }
}
