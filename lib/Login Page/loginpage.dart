import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/HomePage/homepage.dart';
import 'package:devfolio_genai/Login%20Page/Forget%20Password/forget_password.dart';
import 'package:devfolio_genai/Widgets/button.dart';
import 'package:devfolio_genai/Widgets/textfield_login.dart';
import 'package:devfolio_genai/Sign%20Up/signup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isloading = false;

  //for experimental purpose
  void onTab() {
    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');
  }

  void despose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    //sign up the user which is an async function
    String resAuth = await AuthService().loginUser(
        email: emailController.text, password: passwordController.text);

    //if signup is successful, then lead to homepage
    //else throw error
    if (resAuth == "Success") {
      setState(() {
        isloading = true;
      });
      Fluttertoast.showToast(msg: "Logged in", gravity: ToastGravity.BOTTOM);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Homepage()));
    } else {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: resAuth, gravity: ToastGravity.BOTTOM);
    }
  }

  final String forget = 'Forgot Password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Gap(MediaQuery.of(context).size.height * 0.30),
              const Text(
                'Welcome to EduApp',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              TextFieldForLogin(
                  label: "Email",
                  iconfor: Icons.email,
                  textEditingController: emailController,
                  isPass: false),
              const Gap(20),
              TextFieldForLogin(
                label: "Password",
                iconfor: Icons.password,
                textEditingController: passwordController,
                isPass: true,
              ),
              const Gap(20),
              ButtonUI(name: "Login", onPressed: loginUser),
              const Gap(10),
              ForgotPassword(),
              Gap(MediaQuery.of(context).size.height * 0.12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ));
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
