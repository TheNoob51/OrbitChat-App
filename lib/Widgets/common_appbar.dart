import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/Login%20Page/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  Future<String?> _fetchUserName() async {
    String? name = await AuthService().getUserName();
    return name ?? "No name found";
  }

  Future<String> _fetchEmail() async {
    return AuthService().getCurrentUser()?.email ?? "No email available";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_fetchUserName(), _fetchEmail()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return AppBar(title: const Text("Error loading data"));
        }

        final String? userName = snapshot.data![0];
        // final String? email = snapshot.data![1];

        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B3D91), // Space Cadet
                  Color(0xFF1D2951), // Prussian Blue
                  Color(0xFF2E3A59), // Gunmetal
                  Color(0xFF4B0082), // Indigo
                  Color(0xFF6A5ACD), // Slate Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const Gap(10),
                        Text(
                          "Hello, $userName",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                // const Spacer(),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     shape: const CircleBorder(),
                //   ),
                //   onPressed: () async {
                //     await AuthService().signOut();
                //     Fluttertoast.showToast(
                //         msg: "Logged Out", gravity: ToastGravity.BOTTOM);
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //         builder: (context) => const LoginScreen()));
                //   },
                //   child: const Padding(
                //     padding: EdgeInsets.all(5.0),
                //     child: Icon(Icons.logout),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
