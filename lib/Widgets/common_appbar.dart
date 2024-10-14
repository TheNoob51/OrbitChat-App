import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/Login%20Page/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

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
        final String? email = snapshot.data![1];

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
                const Row(
                  children: [
                    Gap(10),
                    Text(
                      "OrbitChat",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                PopupMenuButton(
                  offset: const Offset(0, 50),
                  splashRadius: 20.0,
                  elevation: 3.2,
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, $userName",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              email ?? "No email available",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text("Log out"),
                          onTap: () async {
                            await AuthService().signOut();
                            Fluttertoast.showToast(
                                msg: "Logged Out",
                                gravity: ToastGravity.BOTTOM);
                            //print(context.widget);
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                        ),
                      ),
                    ];
                  },
                ),
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
