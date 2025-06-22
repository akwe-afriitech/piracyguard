import 'package:flutter/material.dart';
import 'package:piracyguard_test_app/screens/Authentiction/sign_up.dart';

import '../../utils/colors.dart';
import 'login.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height*0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: size.width*0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: pColor1)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: tabController,
                        indicator: const BoxDecoration(
                          color: pColor1
                        ),
                        labelPadding: EdgeInsets.all(10),
                        labelColor: Colors.white,
                        unselectedLabelColor: pColor1,
                        tabs:
                        const [
                          Text('Login',style: TextStyle(fontSize: 18),),
                          Text('Signup',style: TextStyle(fontSize: 18)
                        )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                    controller: tabController,
                      children:const [
                        Center(child: Login()),
                        Center(child: Signup())
                      ]
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
