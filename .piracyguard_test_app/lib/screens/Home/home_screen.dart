import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piracyguard_test_app/screens/Authentiction/verification_page.dart';
import 'package:piracyguard_test_app/services/auth_methods.dart';
import 'package:piracyguard_test_app/utils/colors.dart';
import 'package:piracyguard_test_app/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
AuthMethods _authMethods = AuthMethods();

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piracy Guard', style: TextStyle(color: Colors.white),),
        backgroundColor: pColor1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return CircularProgressIndicator(color: pColor1,);
              }
              String name = snapshot.data!['displayName'];
              bool isBlocked = snapshot.data!['isBlocked'];
              String email = snapshot.data!['email'];
              String license = snapshot.data!['license'];

              if(isBlocked){
                setState(() {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return const Verification();
                  }));
                });
              }

              return snapshot.data!.exists ? Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Text(name),
                        license != '' ? Icon(Icons.verified, color: pColor1, size: 18,) : Icon(Icons.verified, color: Colors.black87, size: 18,),
                      ],
                    ),
                    subtitle: Text(email),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/user.png'),
                    ),
                  ),
                  license == '' ? CustomButton(
                      text: 'Verify Account',
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const Verification();
                        }));
                      },
                      color: pColor1,
                      icon: Icons.verified_user_rounded,
                      textColor: Colors.white
                  ):
                      Text('You are a verified user')
                ],
              ) : CircularProgressIndicator(color: pColor1,);
            }
          ),
          CustomButton(
              text: 'Logout',
              onPressed: (){
                _authMethods.signOut(context);
              },
              color: pColor1,
              icon: Icons.logout,
              textColor: Colors.white
          )
        ],
      ),
    );
  }
}


