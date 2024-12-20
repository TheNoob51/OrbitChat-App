import 'package:devfolio_genai/Widgets/button.dart';
import 'package:devfolio_genai/Widgets/textfield_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        fpdialogBox(context);
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }

  void fpdialogBox(BuildContext context) {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Forgot Your Password',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 19),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_rounded)),
                    )
                  ],
                ),
                const Gap(20),
                TextFieldForLogin(
                    label: "Email",
                    iconfor: Icons.email,
                    textEditingController: emailController,
                    isPass: false),
                const Gap(20),
                ButtonUI(
                    name: "Submit",
                    onPressed: () async {
                      await auth
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        Fluttertoast.showToast(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            msg: 'Password reset link sent to your email',
                            gravity: ToastGravity.BOTTOM);
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            msg: error.toString(),
                            gravity: ToastGravity.BOTTOM);
                      });
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
