import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

class PhotoOfTheDayPage extends StatefulWidget {
  const PhotoOfTheDayPage({super.key});

  @override
  _PhotoOfTheDayPageState createState() => _PhotoOfTheDayPageState();
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
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _photoData == null
              ? const Center(child: Text("Failed to load data"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _photoData!['media_type'] == 'image'
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(_photoData!['url']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 200,
                                  width: double.infinity,
                                ),
                              ),
                            )
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(_photoData!['url']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 200,
                                  width: double.infinity,
                                  child: const Center(
                                    child: Text(
                                      "Video of the Day",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        backgroundColor: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const Gap(16),
                      Text(
                        _photoData!['title'] ?? "No title",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Date: ${_photoData!['date'] ?? "Unknown"}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _photoData!['explanation'] ?? "No explanation",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Custom AppBar to match the homepage style
  AppBar _buildCustomAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.transparent, // Customize app bar color
      elevation: 0, // Remove shadow
      centerTitle: true,
      title: const Text(
        "Photo of the Day",
        style: TextStyle(color: Colors.white),
      ),
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
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() {
              _isLoading = true;
              _fetchPhotoOfTheDay();
            });
          },
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }
}
