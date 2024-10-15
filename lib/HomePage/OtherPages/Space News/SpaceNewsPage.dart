import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SpaceNewsPage extends StatefulWidget {
  const SpaceNewsPage({super.key});

  @override
  State<SpaceNewsPage> createState() => _SpaceNewsPageState();
}

class _SpaceNewsPageState extends State<SpaceNewsPage> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetchSpaceNews();
  }

  Future<void> fetchSpaceNews() async {
    final url = Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['results'];
        });
      } else {
        setState(() {
          articles = [];
        });
      }
    } catch (e) {
      setState(() {
        articles = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image from assets
          Positioned.fill(
            child: Image.asset(
              'assets/images/cover/space_news_bg.png', // Update the path to your image asset
              fit: BoxFit.cover,
            ),
          ),
          // Content overlay with the AppBar and articles list
          Column(
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: articles.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          final imageUrl = article['image_url'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  final articleUrl = article['url'];
                                  if (articleUrl != null) {
                                    _launchURL(articleUrl);
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imageUrl.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0),
                                        ),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article['title'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Published on: ${article['published_at']?.split('T')[0] ?? 'N/A'}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            article['summary'] ?? 'No Summary',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.only(
          top: 40.0, bottom: 10), // Adds padding for the status bar
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6), // Transparent black gradient
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: "Go back",
          ),
          const Text(
            "Space News",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color for AppBar over the image
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                articles = [];
                fetchSpaceNews();
              });
            },
            tooltip: "Refresh Space News",
          ),
        ],
      ),
    );
  }

  // Function to open the URL in a browser
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
