import 'package:flutter/material.dart';
import '../services/auth_methods.dart';
import 'colors.dart';


chooseImage(BuildContext context,{required VoidCallback onCamera,required VoidCallback onGallery}){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Please choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onCamera,
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.camera,),
                    ),
                    Text('Camera')
                  ],
                ),
              ),
              const SizedBox(height: 10.0,),
              InkWell(
                onTap: onGallery,
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.image),
                    ),
                    Text('Gallery')
                  ],
                ),
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',style: TextStyle(color: pColor2),)),
            ],
          ),
        );
      }
  );
}
showLogoutDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
            backgroundColor: Colors.white,
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Do you want to logout?',textAlign: TextAlign.center,),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: (){
                        AuthMethods().signOut(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Yes',style: TextStyle(color: pColor2))
                  ),
                  SizedBox(),
                  InkWell(
                      onTap: ()=> Navigator.pop(context),
                      child: Text('No',style: TextStyle(color: pColor2))
                  )
                ],
              ),
            )
        );
      }
  );
}
