import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/HomePage/homepage.dart';
import 'package:devfolio_genai/Login%20Page/Forget%20Password/forget_password.dart';
import 'package:devfolio_genai/Widgets/button.dart';
import 'package:devfolio_genai/Widgets/dividerwithtext.dart';
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
  // void onTab() {
  //   print('Email: ${emailController.text}');
  //   print('Password: ${passwordController.text}');
  // }

  void googleSignIn() async {
    String resGo = await AuthService().signInWithGoogle();
    if (resGo == "Success") {
      setState(() {
        isloading = true;
      });
      Fluttertoast.showToast(
          msg: "Logged in using Google Account", gravity: ToastGravity.BOTTOM);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Homepage()));
    } else {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: resGo, gravity: ToastGravity.BOTTOM);
    }
  }

  void signInAnoy() async {
    String resAn = await AuthService().signInAnonymously();
    if (resAn == "Success") {
      setState(() {
        isloading = true;
      });
      Fluttertoast.showToast(
          msg: "Logged in Anoymously", gravity: ToastGravity.BOTTOM);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Homepage()));
    } else {
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: resAn, gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo/logo2.png',
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.height * 0.25,
                ),
                const Text(
                  'Welcome to OrbitChat',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Gap(10),
                const Text(
                  'Login to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const Gap(30),
                TextFieldForLogin(
                  label: "Email",
                  iconfor: Icons.email_outlined,
                  textEditingController: emailController,
                  isPass: false,
                ),
                const Gap(20),
                TextFieldForLogin(
                  label: "Password",
                  iconfor: Icons.lock_outline,
                  textEditingController: passwordController,
                  isPass: true,
                ),
                const Gap(10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: ForgotPassword(),
                ),
                const Gap(10),
                ButtonUI(name: "Login", onPressed: loginUser),
                const Gap(20),
                DividerWithText(
                    text: "OR",
                    color: Colors.grey[300]!,
                    textStyle:
                        TextStyle(color: Colors.grey[500]!, fontSize: 12)),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        shape: WidgetStateProperty.all<CircleBorder>(
                          const CircleBorder(),
                        ),
                      ),
                      onPressed: googleSignIn,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                          'https://img.icons8.com/color/452/google-logo.png',
                          height: 30,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        shape: WidgetStateProperty.all<CircleBorder>(
                          const CircleBorder(),
                        ),
                      ),
                      onPressed: signInAnoy,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                          'https://img.icons8.com/?size=100&id=pETkiIKt6qBf&format=png&color=000000',
                          height: 30,
                        ),
                      ),
                    )
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
