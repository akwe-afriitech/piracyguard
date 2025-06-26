import 'package:flutter/material.dart';
import 'package:piracyguard_test_app/screens/Authentiction/reset_password.dart';
import 'package:piracyguard_test_app/screens/Home/home_screen.dart';

import '../../services/auth_methods.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custum_textField.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPass = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: pColor1),),
          CustomTextFormField(
            icon: Icons.email,
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomTextFormField(
            icon: Icons.lock,
            controller: passwordController,
            hintText: 'Password',
            obscureText: showPass,
            suffixIcon: showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            onPressed: (){
              setState(() {
                if(showPass){
                  setState(() {
                    showPass = false;
                  });
                }else{
                  setState(() {
                    showPass = true;
                  });
                }
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.only(right: size.width*0.1),
                child: TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const ResetPassword();
                      }));

                    },
                    child: const Text('Forgot Password?',style: TextStyle(color: Colors.red),)
                ),
              ),
            ],
          ),
          CustomButton(
            text: 'Login',
            onPressed: () async {
              bool res = await AuthMethods().signInWithEmailAndPass(context,
                  emailController.text.trim(),
                  passwordController.text.trim()
              );
              if(res){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                  return const HomeScreen();
                }));
              }
            },
            color: pColor1,
            textColor: Colors.white,
            icon: Icons.email,
          ),
          SizedBox(height: 30,),
          const Text('- Or Continue with -',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),),
          CustomButton2(
              text: 'Google',
              onPressed: (){
                AuthMethods().signInWithGoogle(context);
              },
              color: Colors.white,
              image: 'assets/google.png',
              borderColor: pColor1,
              textColor: pColor1
          )
        ],
      ),
    );
  }
}
