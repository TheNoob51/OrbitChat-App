import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/HomePage/homepage.dart';
import 'package:devfolio_genai/Login%20Page/Widgets/button.dart';
import 'package:devfolio_genai/Login%20Page/Widgets/textfield_login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailSignupController = TextEditingController();
  final TextEditingController passwordSignupController =
      TextEditingController();
  final TextEditingController confirmpasswordSignupController =
      TextEditingController();
  final TextEditingController nameSignupController = TextEditingController();
  bool isloading = false;

  void signUpUser() async {
    if (passwordSignupController.text != confirmpasswordSignupController.text) {
      Fluttertoast.showToast(
          msg: "Passwords do not match", gravity: ToastGravity.BOTTOM);
      return;
    }

    String resAuth = await AuthService().signUpUser(
        name: nameSignupController.text,
        email: emailSignupController.text,
        password: passwordSignupController.text);

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(150),
                const Text("Sign Up",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Gap(20),
                TextFieldForLogin(
                    label: "Name",
                    iconfor: Icons.person,
                    textEditingController: nameSignupController,
                    isPass: false),
                const Gap(20),
                TextFieldForLogin(
                    label: "Email",
                    iconfor: Icons.email,
                    textEditingController: emailSignupController,
                    isPass: false),
                const Gap(20),
                TextFieldForLogin(
                  label: "Password",
                  iconfor: Icons.password,
                  textEditingController: passwordSignupController,
                  isPass: true,
                ),
                const Gap(20),
                TextFieldForLogin(
                    label: "Confirm Password",
                    iconfor: Icons.password_sharp,
                    textEditingController: confirmpasswordSignupController,
                    isPass: true),
                const Gap(20),
                ButtonUI(name: "Sign Up", onPressed: signUpUser),
                Gap(MediaQuery.of(context).size.height * 0.07),
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
    );
  }
}
