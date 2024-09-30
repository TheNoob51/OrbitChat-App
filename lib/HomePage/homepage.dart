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
  String? userName;
  bool isLoading = true; // To track the loading state

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Fetch user name from Firestore
  Future<void> _fetchUserName() async {
    String? name = await AuthService().getUserName();
    setState(() {
      userName = name ?? "No name found";
      isLoading = false; // Set loading to false once data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the data is being fetched
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Display the loading spinner
        ),
      );
    }

    final email = AuthService().getCurrentUser()?.email ?? "No email available";

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello, $userName!", style: TextStyle(fontSize: 20)),
            Text("Email: $email", style: TextStyle(fontSize: 16)),
            Text("UID: ${AuthService().getCurrentUser()?.uid}",
                style: TextStyle(fontSize: 16)),
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
      ),
    );
  }
}
