import 'package:flutter/material.dart';

import '../utils/colors.dart';


class CustomTextField extends StatelessWidget {
  String? errorText;
  TextEditingController controller;
  String labelText;
  CustomTextField({
   required this.controller,
   required  this.errorText,
   required this.labelText,
});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              errorText: errorText,
              errorStyle: TextStyle(color: Colors.red),
              suffixIcon: controller.text.isNotEmpty ? IconButton(
                icon: Icon(Icons.clear,color: pColor2,),
                onPressed: controller.clear,
              ) : null,
              labelText: labelText,
            labelStyle: TextStyle(color: pColor2)
          ),
        ),
         Divider(thickness: 2,height: 1,),
      ],
    );

  }
}

class CustomTextFormField extends StatelessWidget {
  IconData icon;
  String hintText;
  TextEditingController controller;
  IconData? suffixIcon;
  VoidCallback? onPressed;
  TextInputType? keyboardType;
  bool obscureText;
  CustomTextFormField({
    required this.icon,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    required this.obscureText,
    this.onPressed,
    this.keyboardType
  });


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height*0.03,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.35),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0,3)
                  ),
                ]
            ),
            child: TextFormField(
              keyboardType: keyboardType,
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(icon, color: pColor2,),
                suffixIcon: IconButton(icon: Icon(suffixIcon, color: obscureText ? Colors.grey : pColor2,), onPressed: onPressed,),
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

