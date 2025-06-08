import 'package:devfolio_genai/Providers/auth_provider.dart';
// import 'package:devfolio_genai/Landing%20Home%20Page/Main_Home.dart'; // No longer needed for navigation here
import 'package:devfolio_genai/Login%20Page/Forget%20Password/forget_password.dart';
// import 'package:devfolio_genai/Widgets/button.dart'; // ButtonUI will be part of Consumer
import 'package:devfolio_genai/Widgets/button.dart';
import 'package:devfolio_genai/Widgets/dividerwithtext.dart';
import 'package:devfolio_genai/Widgets/textfield_login.dart';
import 'package:devfolio_genai/Sign%20Up/signup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // bool isloading = false; // Replaced by AuthProvider.isLoading

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   double screenWidth = MediaQuery.of(context).size.width;
  //   double screenHeight = MediaQuery.of(context).size.height;
  //   double responsiveFontSize = screenWidth * 0.07;
  //   return Scaffold(
  //     body: Container(
  //       alignment: Alignment.center,
  //       decoration: const BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [
  //             Color(0xFF0B3D91), // Space Cadet
  //             Color(0xFF1D2951), // Prussian Blue
  //             Color(0xFF2E3A59), // Gunmetal
  //             Color(0xFF4B0082), // Indigo
  //             Color(0xFF6A5ACD), // Slate Blue
  //           ],
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //         ),
  //       ),
  //       child: SingleChildScrollView(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(16),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black26.withOpacity(0.2),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 5),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Image.asset(
  //                 'assets/images/logo/logo2.png',
  //                 height: MediaQuery.of(context).size.height * 0.25,
  //                 width: MediaQuery.of(context).size.height * 0.25,
  //               ),
  //               Text(
  //                 'Welcome to OrbitChat',
  //                 style: TextStyle(
  //                   fontSize: responsiveFontSize,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //               const Gap(10),
  //               const Text(
  //                 'Login to continue',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //               const Gap(30),
  //               TextFieldForLogin(
  //                 label: "Email",
  //                 iconfor: Icons.email_outlined,
  //                 textEditingController: emailController,
  //                 isPass: false,
  //               ),
  //               const Gap(20),
  //               TextFieldForLogin(
  //                 label: "Password",
  //                 iconfor: Icons.lock_outline,
  //                 textEditingController: passwordController,
  //                 isPass: true,
  //               ),
  //               const Gap(10),
  //               const Align(
  //                 alignment: Alignment.centerRight,
  //                 child: ForgotPassword(),
  //               ),
  //               const Gap(10),
  //               ButtonUI(name: "Login", onPressed: loginUser),
  //               const Gap(20),
  //               DividerWithText(
  //                   text: "OR",
  //                   color: Colors.grey[300]!,
  //                   textStyle:
  //                       TextStyle(color: Colors.grey[500]!, fontSize: 12)),
  //               const Gap(10),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   ElevatedButton(
  //                     style: ButtonStyle(
  //                       backgroundColor:
  //                           WidgetStateProperty.all<Color>(Colors.white),
  //                       shape: WidgetStateProperty.all<CircleBorder>(
  //                         const CircleBorder(),
  //                       ),
  //                     ),
  //                     onPressed: googleSignIn,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: Image.network(
  //                         'https://img.icons8.com/color/452/google-logo.png',
  //                         height: 30,
  //                       ),
  //                     ),
  //                   ),
  //                   ElevatedButton(
  //                     style: ButtonStyle(
  //                       backgroundColor:
  //                           WidgetStateProperty.all<Color>(Colors.white),
  //                       shape: WidgetStateProperty.all<CircleBorder>(
  //                         const CircleBorder(),
  //                       ),
  //                     ),
  //                     onPressed: signInAnoy,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: Image.network(
  //                         'https://img.icons8.com/?size=100&id=pETkiIKt6qBf&format=png&color=000000',
  //                         height: 30,
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               const Gap(20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Text("Don't have an account?"),
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => const SignUpPage()));
  //                     },
  //                     child: const Text(
  //                       'Sign Up',
  //                       style: TextStyle(
  //                         color: Colors.blueAccent,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive font sizes
    double responsiveWelcomeFontSize = screenWidth * 0.07;
    double responsiveLoginHintFontSize = screenWidth * 0.04;

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Show toast if there's an error message
          if (authProvider.errorMessage != null && !authProvider.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Fluttertoast.showToast(
                  msg: authProvider.errorMessage!,
                  gravity: ToastGravity.BOTTOM);
              // Clear the error message after showing it
              authProvider.clearErrorMessage();
            });
          }

          return Container(
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
            // Removed SingleChildScrollView to prevent scrolling
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                    mainAxisSize: MainAxisSize
                        .min, // Ensures column takes minimum space
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Image sizing adjusted to be more responsive and save vertical space
                      Image.asset(
                        'assets/images/logo/logo2.png',
                        height: screenHeight * 0.20, // Adjusted percentage
                        width: screenHeight * 0.20, // Adjusted percentage
                      ),
                      Text(
                        'Welcome to OrbitChat',
                        style: TextStyle(
                          fontSize: responsiveWelcomeFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        'Login to continue',
                        style: TextStyle(
                          fontSize: responsiveLoginHintFontSize, // Using responsive size
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
                      authProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ButtonUI(
                              name: "Login",
                              onPressed: () {
                                if (emailController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  authProvider.signInWithEmailPassword(
                                      emailController.text,
                                      passwordController.text);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Email and password cannot be empty",
                                      gravity: ToastGravity.BOTTOM);
                                }
                              }),
                      const Gap(20),
                      DividerWithText(
                          text: "OR",
                          color: Colors.grey[300]!,
                          textStyle: TextStyle(
                              color: Colors.grey[500]!, fontSize: 12)),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.white),
                              shape: WidgetStateProperty.all<CircleBorder>(
                                const CircleBorder(),
                              ),
                            ),
                            onPressed: authProvider.isLoading
                                ? null
                                : () => authProvider.signInWithGoogle(),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/images/logo/google-logo.png',
                                height: 30, // Fixed height for social icons
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.white),
                              shape: WidgetStateProperty.all<CircleBorder>(
                                const CircleBorder(),
                              ),
                            ),
                            onPressed: authProvider.isLoading
                                ? null
                                : () => authProvider.signInAnonymously(),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/images/logo/anon-logo.png',
                                height: 30, // Fixed height for social icons
                              ),
                            ),
                          )
                        ],
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: authProvider.isLoading ? null : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
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
        },
      ),
    );
  }
}
