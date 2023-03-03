import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireservices/provider/auth_provider.dart';
import 'package:fireservices/screens/home_screen.dart';
import 'package:fireservices/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GoogleAuthScreen extends StatelessWidget {
  const GoogleAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return const HomeScreen();
        }
        return Scaffold(
          body: Consumer<AuthProvider>(
            builder: (context,model,_) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      authbutton(icon: FontAwesomeIcons.google, text: 'Google',ontap: (){
                        model.signInWithGoogle();
                      },)
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }
}
