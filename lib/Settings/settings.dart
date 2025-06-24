// import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart'; // No longer directly used for user details or signout
// import 'package:devfolio_genai/Login%20Page/loginpage.dart'; // No longer needed for navigation
import 'package:devfolio_genai/Providers/auth_provider.dart';
import 'package:devfolio_genai/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion = '1.0.0';
  @override
  void initState() {
    super.initState();
  }

  // Future<String?> _fetchUserName() async { // Replaced by AuthProvider
  //   String? name = await AuthService().getUserName();
  //   return name ?? "No name found";
  // }

  // Future<String> _fetchEmail() async { // Replaced by AuthProvider
  //   return AuthService().getCurrentUser()?.email ?? "No email available";
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context); // Get AuthProvider

    // Get user details directly from AuthProvider
    final user = authProvider.currentUser;
    final String userName = user?.displayName ??
        user?.email?.split('@')[0] ??
        "User"; // Fallback for username
    final String email = user?.email ?? "Email not available";

    // Show loading indicator if user data is not yet available (e.g. initial load)
    if (authProvider.isLoading && user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
        body: Padding(
      // Removed FutureBuilder as data comes from AuthProvider
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const Gap(16),
          // Username
          Text(
            "Hi, $userName",
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
          const Gap(8),
          // Email
          Text(
            email,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Gap(32),
          // Dark Mode Switch
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.purple),
            title:
                const Text('Dark Mode', style: TextStyle(color: Colors.purple)),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(value),
              activeColor: Colors.purple,
            ),
          ),
          const Gap(16),
          // App Version
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.purple),
            title: const Text('App Version',
                style: TextStyle(color: Colors.purple)),
            trailing: Text(
              appVersion,
              style: const TextStyle(fontSize: 18, color: Colors.purple),
            ),
          ),
          const Gap(32),
          // Logout Button
          ElevatedButton(
            onPressed: () async {
              // await AuthService().signOut(); // Replaced by AuthProvider call
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              Fluttertoast.showToast(
                  msg: "Logged Out", gravity: ToastGravity.BOTTOM);
              // Navigator.of(context).pushReplacement(MaterialPageRoute( // Navigation handled by MyApp
              //     builder: (context) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    )
        // }, // End of FutureBuilder's builder
        // ), // End of FutureBuilder
        );
  }
}
