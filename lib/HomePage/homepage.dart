import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/Login%20Page/loginpage.dart';
import 'package:devfolio_genai/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //for experimental purpose
  void onPressed() {
    print("Log Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Hello World"),
          const Gap(20),
          ButtonUI(
              name: "Log Out",
              onPressed: () async {
                await AuthService().signOut();
                Fluttertoast.showToast(
                    msg: "Logged Out", gravity: ToastGravity.BOTTOM);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              })
        ],
      ),
    );
  }
}
