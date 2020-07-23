import 'package:flutter/material.dart';
import 'package:pulserun_app/theme/theme.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final Function onChanged;

  TextFieldWidget({
    this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    //final model = Provider.of<HomeModel>(context);

    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      cursorColor: GlobalTheme.mediumBlue,
      style: TextStyle(
        color: GlobalTheme.mediumBlue,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: GlobalTheme.mediumBlue),
        focusColor: GlobalTheme.mediumBlue,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: GlobalTheme.mediumBlue),
        ),
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: GlobalTheme.mediumBlue,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            //model.isVisible = !model.isVisible;
          },
          child: Icon(
            suffixIconData,
            size: 18,
            color: GlobalTheme.mediumBlue,
          ),
        ),
      ),
    );
  }
}
