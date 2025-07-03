import 'package:flutter/material.dart';

import '../utils/colors.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color color;
  final IconData icon;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.icon,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width* 0.1,vertical: 18),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient:  LinearGradient(colors: [ pColor1, color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color: Colors.white,),
            const SizedBox(width: 3.0,),
            Text(
              text,
              style: TextStyle(
                fontSize: 17,
                color: textColor
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final String image;
  final Color borderColor;
  const CustomButton2({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.image,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 10, horizontal: size.width*0.1),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:color,
          side: BorderSide(color: borderColor),
          minimumSize: const Size(
            double.infinity,
            45,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image,height: 25,width: 25,),
            const SizedBox(width: 3,),
            Text(
              text,
              style: TextStyle(
                  fontSize: 17,
                  color: textColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
