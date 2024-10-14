import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/GenerativeAIModule/generativeai.dart';
import 'package:devfolio_genai/Chat%20Window/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
