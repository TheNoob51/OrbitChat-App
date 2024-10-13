import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/GenerativeAIModule/generativeai.dart';
import 'package:devfolio_genai/HomePage/key.dart';
import 'package:devfolio_genai/Login%20Page/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? userName;
  bool isLoading = true; // To indicate the screen loading state
  bool isApiLoading = false; // To indicate API loading state
  final List<GeminiMessage> messages = [
    GeminiMessage(
        isUser: false,
        message: "Welcome to OrbitChat! , How can I assist you today?",
        time: DateTime.now()),
  ];

  Future<void> sendRecieveMessage(String message) async {
    // Add user message to the list
    setState(() {
      messages.add(
          GeminiMessage(time: DateTime.now(), message: message, isUser: true));
      isApiLoading = true; // Start loading the API response
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    // Add the AI response message
    setState(() {
      messages.add(GeminiMessage(
          time: DateTime.now(),
          message: response.text ?? "No Message",
          isUser: false));
      isApiLoading = false; // Stop loading after receiving the response
    });
  }

  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);

  TextEditingController promptController = TextEditingController();

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
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the data is being fetched
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final email = AuthService().getCurrentUser()?.email ?? "No email available";

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Aligns all items to the left
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Ensures the text is left-aligned
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            const Gap(
                                10), // Add a small gap between icon and text
                            Text(
                              "Hello, $userName",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        Text(
                          "Email: $email",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () async {
                            await AuthService().signOut();
                            Fluttertoast.showToast(
                                msg: "Logged Out",
                                gravity: ToastGravity.BOTTOM);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(Icons.logout),
                          )),
                    ),
                  ],
                ),
                const Gap(10),
              ],
            ),
          ),

          // Chat Messages Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length +
                  (isApiLoading
                      ? 1
                      : 0), // Add a slot for the loading indicator
              itemBuilder: (context, index) {
                if (index == messages.length && isApiLoading) {
                  return Center(
                    child: LoadingAnimationWidget.newtonCradle(
                      color: Colors.purple,
                      size: 60.0,
                    ),
                  );
                  // return const Center(
                  //   child:
                  //       CircularProgressIndicator(), // Loading indicator for API
                  // );
                }

                final message = messages[index];
                bool isUser = message.isUser;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1)
                            : Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft: isUser
                              ? const Radius.circular(15)
                              : const Radius.circular(0),
                          bottomRight: isUser
                              ? const Radius.circular(0)
                              : const Radius.circular(15),
                        ),
                      ),
                      child: MarkdownBody(
                        data: message.message,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                          color: isUser ? Colors.purple[700] : Colors.black,
                        )),
                      )),
                );
              },
            ),
          ),

          // Chat Input Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 25,
                  child: TextField(
                    controller: promptController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(const CircleBorder()),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                  ),
                  icon: const Icon(Icons.send, size: 30, color: Colors.white),
                  onPressed: () {
                    if (promptController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please enter a message",
                          gravity: ToastGravity.BOTTOM);
                      return;
                    }
                    sendRecieveMessage(promptController.text);
                    promptController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
