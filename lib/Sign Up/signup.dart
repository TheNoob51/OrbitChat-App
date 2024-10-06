import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/HomePage/homepage.dart';
import 'package:devfolio_genai/Widgets/button.dart';
import 'package:devfolio_genai/Widgets/textfield_login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //all the controllers for the textfields
  final TextEditingController emailSignupController = TextEditingController();
  final TextEditingController passwordSignupController =
      TextEditingController();
  final TextEditingController confirmpasswordSignupController =
      TextEditingController();
  final TextEditingController nameSignupController = TextEditingController();
  bool isloading = false;

  @override
  void dispose() {
    emailSignupController.dispose();
    passwordSignupController.dispose();
    confirmpasswordSignupController.dispose();
    nameSignupController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    //check if the confirm password and password are same
    if (passwordSignupController.text != confirmpasswordSignupController.text) {
      Fluttertoast.showToast(
          msg: "Passwords do not match", gravity: ToastGravity.BOTTOM);
      return;
    }

    String resAuth = await AuthService().signUpUser(
      name: nameSignupController.text,
      email: emailSignupController.text,
      password: passwordSignupController.text,
    );

    //if signup is successful, then lead to homepage
    //else throw error
    if (resAuth == "Success") {
      setState(() {
        isloading = true;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Homepage()));
    } else {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: resAuth, gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B3D91), // Space Cadet
              Color(0xFF1D2951), // Prussian Blue
              Color(0xFF2E3A59), // Gunmetal
              Color(0xFF4B0082), // Indigo
              Color(0xFF6A5ACD), // Slate Blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(20),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const Gap(30),
                      TextFieldForLogin(
                        label: "Name",
                        iconfor: Icons.person,
                        textEditingController: nameSignupController,
                        isPass: false,
                      ),
                      const Gap(20),
                      TextFieldForLogin(
                        label: "Email",
                        iconfor: Icons.email,
                        textEditingController: emailSignupController,
                        isPass: false,
                      ),
                      const Gap(20),
                      TextFieldForLogin(
                        label: "Password",
                        iconfor: Icons.lock,
                        textEditingController: passwordSignupController,
                        isPass: true,
                      ),
                      const Gap(20),
                      TextFieldForLogin(
                        label: "Confirm Password",
                        iconfor: Icons.lock_outline,
                        textEditingController: confirmpasswordSignupController,
                        isPass: true,
                      ),
                      const Gap(30),
                      ButtonUI(name: "Sign Up", onPressed: signUpUser),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
