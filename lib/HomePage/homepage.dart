import 'package:devfolio_genai/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
          ButtonUI(name: "Log Out", onPressed: onPressed)
        ],
      ),
    );
  }
}
