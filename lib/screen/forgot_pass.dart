import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();

  resetPassword(String email) async {
    if (email == '') {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Email Verification'),
            content: const Text('Please Enter the Email to reset password.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'ok',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          );
        },
      );
    } else {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Email',
                    labelText: 'Email Address',
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).textTheme.bodySmall!.color,
                      ),
                      onPressed: () {
                        resetPassword(emailController.text);
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
