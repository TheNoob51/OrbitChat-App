import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:devfolio_genai/Chat%20Window/key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? userName;
  bool isLoading = true; // Indicates the screen loading state
  bool isApiLoading = false; // Indicates API loading state
  final List<GeminiMessage> messages = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  late Query _chatQuery;
  late String _uid;

  final GenerativeModel model =
      GenerativeModel(model: "gemini-pro", apiKey: apiKey);

  final TextEditingController promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    // Fetch current user
    User? user = _authService.getCurrentUser();
    if (user == null) {
      // Handle unauthenticated state, possibly navigate to login
      Fluttertoast.showToast(
        msg: "No user is currently signed in.",
        gravity: ToastGravity.BOTTOM,
      );
      // Optionally, navigate to the login page
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
      setState(() {
        isLoading = false;
      });
      return;
    }

    _uid = user.uid;

    // Reference to the user's chat collection, ordered by time ascending
    _chatQuery = _firestore
        .collection('users')
        .doc(_uid)
        .collection('chats')
        .orderBy('time', descending: false); // Order by time ascending

    // Fetch user name
    String? name = await _authService.getUserName();

    setState(() {
      userName = name ?? "No name found";
      isLoading = false;
    });
  }

  Future<void> sendReceiveMessage(String message) async {
    if (_uid.isEmpty) {
      Fluttertoast.showToast(
        msg: "User not authenticated.",
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Add user message to Firestore
    final userMessage = {
      'message': message,
      'isUser': true,
      'time': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('chats')
        .add(userMessage);

    setState(() {
      isApiLoading = true; // Start loading the API response
    });

    try {
      // Call the AI model
      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      // Add AI response to Firestore
      final aiMessage = {
        'message': response.text ?? "No Message",
        'isUser': false,
        'time': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('chats')
          .add(aiMessage);
    } catch (e) {
      logger.e('AI Response Error: $e');
      Fluttertoast.showToast(
        msg: "Failed to get response from AI.",
        gravity: ToastGravity.BOTTOM,
      );
      // Optionally, log the error or handle it accordingly
    } finally {
      setState(() {
        isApiLoading = false; // Stop loading after receiving the response
      });
    }
  }

  // Method to clear all messages from Firestore
  Future<void> clearMessages() async {
    try {
      QuerySnapshot snapshot = await _chatQuery.get();
      WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      Fluttertoast.showToast(
        msg: "All messages cleared.",
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      logger.e('Clear Messages Error: $e');
      Fluttertoast.showToast(
        msg: "Failed to clear messages.",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while initializing
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
      // appBar: AppBar(
      //   // Removed title and logout button
      //   // Optionally, you can add an icon or leave it blank
      //   title: const Text(''), // Empty title
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chat Messages Section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  logger.e('StreamBuilder Error: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Clear existing messages and rebuild from Firestore
                messages.clear();
                for (var doc in snapshot.data!.docs) {
                  final timeStamp = doc['time'];
                  DateTime time;
                  if (timeStamp != null && timeStamp is Timestamp) {
                    time = timeStamp.toDate();
                  } else {
                    time = DateTime.now();
                  }

                  messages.add(GeminiMessage(
                    isUser: doc['isUser'] ?? false,
                    message: doc['message'] ?? '',
                    time: time,
                  ));
                }

                // Scroll to bottom after messages are loaded
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController, // Attach ScrollController
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (isApiLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && isApiLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: LoadingAnimationWidget.newtonCradle(
                            color: Colors.purple,
                            size: 60.0,
                          ),
                        ),
                      );
                    }

                    final message = messages[index];
                    bool isUser = message.isUser;
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
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
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            MarkdownBody(
                              data: message.message,
                              selectable: true,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(
                                  color: isUser
                                      ? Colors.purple[700]
                                      : Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Chat Input Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
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
                const SizedBox(width: 8),
                IconButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(const CircleBorder()),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                  ),
                  icon: const Icon(Icons.send, size: 30, color: Colors.white),
                  onPressed: () {
                    String message = promptController.text.trim();
                    if (message.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please enter a message",
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }
                    sendReceiveMessage(message);
                    promptController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // Floating Action Button to Clear Messages
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            // Confirm before clearing messages
            bool? confirm = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Clear All Messages'),
                  content: const Text(
                      'Are you sure you want to delete all messages? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );

            if (confirm != null && confirm) {
              await clearMessages();
            }
          },
          tooltip: 'Clear All Messages',
          backgroundColor: Colors.red,
          child: const Icon(Icons.delete),
        ),
      ),
    );
  }
}

// GeminiMessage Model
class GeminiMessage {
  final bool isUser;
  final String message;
  final DateTime time;

  GeminiMessage({
    required this.isUser,
    required this.message,
    required this.time,
  });
}
