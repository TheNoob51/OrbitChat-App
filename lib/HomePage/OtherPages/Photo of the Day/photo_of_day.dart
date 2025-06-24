import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PhotoOfTheDayPage extends StatefulWidget {
  const PhotoOfTheDayPage({super.key});

  @override
  State<PhotoOfTheDayPage> createState() => _PhotoOfTheDayPageState();
}

class _PhotoOfTheDayPageState extends State<PhotoOfTheDayPage> {
  final String _apiKey =
      'HjyHDR50S6xYti2hIrqZrffvhkGM5ZP5NzHc5oXX'; // Replace with your NASA API key
  Map<String, dynamic>? _photoData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPhotoOfTheDay();
  }

  Future<void> _fetchPhotoOfTheDay() async {
    final url = 'https://api.nasa.gov/planetary/apod?api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _photoData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load APOD');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error fetching APOD: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_photoData == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load data")),
      );
    }

    DateTime dateP = DateTime.parse(_photoData!['date']);
    String formattedDate = DateFormat('MMM d, yyyy').format(dateP);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 117, 115, 115),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: const Text("Photo of the Day"),
            pinned: false, // Allow the app bar to scroll completely
            floating: false, // App bar will not reappear on scroll up
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: _photoData!['media_type'] == 'image'
                  ? CachedNetworkImage(
                      imageUrl: _photoData!['url'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Container(
                      color: const Color.fromARGB(255, 117, 115, 115),
                      child: const Center(
                        child: Text(
                          "Video of the Day",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                        indent: 150,
                        endIndent: 150,
                      ),
                      const Gap(10),
                      Text(
                        _photoData!['title'] ?? "No title",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedDate,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _photoData!['explanation'] ?? "No explanation",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
