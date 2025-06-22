import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piracyguard_test_app/screens/Home/home_screen.dart';
import 'package:piracyguard_test_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../utils/colors.dart';
import '../../utils/snackbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custum_textField.dart';


class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  TextEditingController licenseController = TextEditingController();
  bool showPass = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String _displayName = '';
  String email = '';
  bool isBlocked = true;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox.shrink(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Verification',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: pColor1),),
              CustomTextFormField(
                icon: Icons.verified_user_sharp,
                controller: licenseController,
                hintText: 'Enter license key',
                obscureText: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.shrink(),
                  Padding(
                    padding: EdgeInsets.only(right: size.width*0.1),
                    child: TextButton(
                        onPressed: _launchUrl,
                        child: const Text('Request license',style: TextStyle(color: Colors.red),)
                    ),
                  ),
                ],
              ),
              CustomButton(
                text: 'Verify',
                onPressed: () async {
                  if(licenseController.text.isNotEmpty){
                    await FirebaseFirestore.instance.collection('license').doc(licenseController.text)
                        .get().then((snapshot) async{
                      if(snapshot.exists){
                        await userRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
                          "license":licenseController.text,
                          "isBlocked": false
                        });
                        await FirebaseFirestore.instance.collection('tracking').doc(FirebaseAuth.instance.currentUser!.uid).set({
                          'displayName': _displayName,
                          'type': 'Verification Successful',
                          'license': licenseController.text,
                          'isVerified': true,
                          "isBlocked": false,
                          'uid': FirebaseAuth.instance.currentUser!.uid,
                          'createdAt': DateTime.now().toString(),
                        });
                        await FirebaseFirestore.instance.collection('verified').doc(FirebaseAuth.instance.currentUser!.uid).set({
                          "verified": true,
                          "uid":FirebaseAuth.instance.currentUser!.uid,
                          "license":licenseController.text
                        }).then((value) => {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return const HomeScreen();
                          }))
                        });;
                        showSnackBar(context, "Verification Successful");
                      }else{
                        showSnackBar(context, "Invalid key, check for possible errors");
                      }
                    });
                  }else{
                    showSnackBar(context, "You must enter the license key");
                  }
                },
                color: pColor1,
                textColor: Colors.white,
                icon: Icons.verified,
              ),
            ],
          ),
          Column(
            children: [
              const Text('- Or -',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45),),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                child: TextButton(
                    onPressed: (){
                      if(isBlocked){
                        showSnackBar(context, 'You have been blocked. Please verify your account to gain access');
                      }else{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                          return const HomeScreen();
                        }));
                      }
                    },
                    child: Text('SKIP', style: TextStyle(fontWeight: FontWeight.bold),)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future _launchUrl() async {
    final Uri _url = Uri.parse('https://wa.me/$adminNum?text=License%20code%20request%20from%0D%0AName:%20$_displayName%0D%0AEmail:%20$email%0D%0Auid:%20$uid');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
  Future _getData() async{
    await userRef.doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((snapshot){
      if(snapshot.exists){
        setState(() {
          _displayName = snapshot.data()!['displayName'];
          email = snapshot.data()!['email'];
          isBlocked = snapshot.data()!['isBlocked'];
        });
      }
    });
  }
}
