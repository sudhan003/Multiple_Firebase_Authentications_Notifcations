import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireservices/provider/auth_provider.dart';
import 'package:fireservices/screens/home_screen.dart';
import 'package:fireservices/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';

class EmailAuthScreen extends StatelessWidget {
  const EmailAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        hinttext: 'Email',
                        prefixicon: Icons.email_outlined,
                        controller: model.emailController,
                      ),
                      if (model.authType == AuthType.signup)
                        CustomTextField(
                          hinttext: 'UserName',
                          prefixicon: Icons.person,
                          controller: model.usernameController,
                        ),
                      CustomTextField(
                        hinttext: 'Password',
                        prefixicon: Icons.password,
                        controller: model.passwordController,
                      ),
                      TextButton(
                        onPressed: () {
                          model.authenticate();

                        },
                        child: model.authType == AuthType.signup
                            ? const Text(
                                'Sign up',
                              )
                            : const Text(
                                'log in',
                              ),
                      ),
                      TextButton(
                          onPressed: () {
                            model.setAuthType();
                          },
                          child: model.authType ==
                                  AuthType
                                      .signup // if the model.authType eqauls to AuthType.signup then show "Already......" else "Create ....."
                              ? const Text('Already have an account?')
                              : const Text('Create an account!')),
                      if(model.authType == AuthType.login)
                      TextButton(
                          onPressed: () {
                            model.resetPassword(context);
                          },
                          child: const Text('Reset password')),
                    ],
                  ),
                ),
              );
            } else {
              return const HomeScreen();
            }
          });
    });
  }
}
