
import 'package:fireservices/screens/email_auth_screen.dart';
import 'package:fireservices/screens/phone_auth_screen.dart';
import 'package:fireservices/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../google_auth_screen.dart';

class authscreen extends StatelessWidget {
  const authscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        centerTitle:true ,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            authbutton(icon: Icons.mail,  text: 'Email/Password',ontap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const EmailAuthScreen()));
            },),
            authbutton(icon: Icons.phone, text: 'Phone',ontap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const PhoneAuthScreen()));
            },),
            authbutton(icon: FontAwesomeIcons.google, text:"Google",ontap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const GoogleAuthScreen()));
            },)
          ],
        ),
      ),
    );
  }
}
