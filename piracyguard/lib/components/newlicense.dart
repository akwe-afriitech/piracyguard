import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class NewLicenseScreen extends StatefulWidget {
  @override
  _NewLicenseScreenState createState() => _NewLicenseScreenState();
}

class _NewLicenseScreenState extends State<NewLicenseScreen> {
  List<String> activeKeys = [];
  List<String> expiredKeys = [];


  void _generateNewKey() async{
    const int keyLength = 8;
    const String allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random random = Random();

    String randomPart = String.fromCharCodes(Iterable.generate(
        keyLength, (_) => allowedChars.codeUnitAt(random.nextInt(allowedChars.length))));

    String newKey = '$randomPart-${DateTime.now().millisecondsSinceEpoch}';
    
    await FirebaseFirestore.instance.collection('license').doc(newKey).set({
      'key':newKey,
      'isRevoked': false
    });
    
  }

  void _copyToClipboard(String key) {
    Clipboard.setData(ClipboardData(text: key));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Key copied to clipboard')),
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: size.width*0.05),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _generateNewKey,
              child: const Text('Generate New Key'),
            ),
          ),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('license').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: size.width*0.05),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Active Keys', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                              String key = snapshot.data!.docs[index]['key'];
                              bool isRevoked = snapshot.data!.docs[index]['isRevoked'];
                              return !isRevoked ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(key, style: const TextStyle(fontFamily: 'monospace',fontSize: 12))),
                                    TextButton(
                                        onPressed: (){
                                          _copyToClipboard(key);
                                        },
                                        child: const Text('Copy')
                                    ),
                                    TextButton(
                                        onPressed: () async{
                                          await FirebaseFirestore.instance.collection('license').doc(key).update({
                                            'isRevoked': true
                                          });
                                        },
                                        child: const Text('Revoke')
                                    ),
                                  ],
                                ),
                              ): SizedBox.shrink();
                            }
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: size.width*0.05),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Expired Keys', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                              String key = snapshot.data!.docs[index]['key'];
                              bool isRevoked = snapshot.data!.docs[index]['isRevoked'];
                              return isRevoked ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(key, style: const TextStyle(fontFamily: 'monospace',fontSize: 12))),
                                    TextButton(
                                        onPressed: (){
                                          _copyToClipboard(key);
                                        },
                                        child: const Text('Copy')
                                    ),
                                    TextButton(
                                        onPressed: () async{
                                          await FirebaseFirestore.instance.collection('license').doc(key).update({
                                            'isRevoked': false
                                          });
                                        },
                                        child: const Text('Undo',style: TextStyle(color: Colors.grey),)
                                    ),
                                    InkWell(
                                        child: Icon(Icons.delete,color: Colors.red,),
                                      onTap: () async{
                                        await FirebaseFirestore.instance.collection('license').doc(key).delete();
                                      },
                                    )
                                  ],
                                ),
                              ): SizedBox.shrink();
                            }
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
        ),
        // const Spacer(),
      ],
    );
  }
}