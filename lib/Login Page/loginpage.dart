import 'package:devfolio_genai/Login%20Page/Widgets/button.dart';
import 'package:devfolio_genai/Login%20Page/Widgets/textfield_login.dart';
import 'package:devfolio_genai/Sign%20Up/signup.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void onTab() {
    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');
  }

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
              ButtonUI(name: "Login", onPressed: onTab),
              TextButton(
                onPressed: () {
                  // Handle forgot password logic here
                },
                child: const Text('Forgot Password?'),
              ),
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
