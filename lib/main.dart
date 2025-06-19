import 'package:devfolio_genai/Landing%20Home%20Page/Main_Home.dart';
import 'package:devfolio_genai/Providers/auth_provider.dart';
import 'package:devfolio_genai/Providers/theme_provider.dart';
import 'package:devfolio_genai/firebase_options.dart';
import 'package:devfolio_genai/Login%20Page/loginpage.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // No longer directly used here
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'OrbitChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode,
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading && auth.currentUser == null) { // Show loading only during initial auth check
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (auth.currentUser != null) {
            return const MainPage();
          } else {
            // You could also display auth.errorMessage here if needed,
            // though LoginScreen is a more typical place.
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
