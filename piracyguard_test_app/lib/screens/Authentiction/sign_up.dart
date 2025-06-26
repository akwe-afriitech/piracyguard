import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piracyguard_test_app/screens/Authentiction/verification_page.dart';
import 'package:piracyguard_test_app/screens/Home/home_screen.dart';
import 'package:uuid/uuid.dart';
import '../../services/auth_methods.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custum_textField.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPass = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text('Signup',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: pColor1),),
          const SizedBox(height: 10,),
          CustomTextFormField(
            icon: Icons.person,
            controller: nameController,
            keyboardType: TextInputType.name,
            hintText: 'Full Name',
            obscureText: false,
          ),
          CustomTextFormField(
            icon: Icons.email,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Email',
            obscureText: false,
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
          const SizedBox(height: 10,),
          CustomButton(
            text: 'Signup',
            onPressed: () async {
              if(nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                 await AuthMethods().createUserWithEmailAndPass(context,
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    nameController.text.trim()
                ).then((value) async{
                   try{

                     await userRef.doc(FirebaseAuth.instance.currentUser!.uid).set({
                       'displayName': nameController.text.trim(),
                       'license': '',
                       'email' : emailController.text.trim(),
                       'uid': FirebaseAuth.instance.currentUser!.uid,
                       'createdAt': DateTime.now().toString(),
                       'isBlocked': false,
                     });
                     await FirebaseFirestore.instance.collection('tracking').doc(FirebaseAuth.instance.currentUser!.uid).set({
                       'displayName': nameController.text.trim(),
                       'type': 'New User',
                       'license': '',
                       'isVerified': false,
                       'uid': FirebaseAuth.instance.currentUser!.uid,
                       'createdAt': DateTime.now().toString(),
                       "isBlocked": false
                     }).then((value) => {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                         return const Verification();
                       }))
                     });
                   }catch(e){
                     print(e);
                     showSnackBar(context, e.toString());
                   }
                 });
              }else{
                showSnackBar(context, "You must enter a name,email and password");
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
