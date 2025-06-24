import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

class AstronomyPictureLibrary extends StatefulWidget {
  const AstronomyPictureLibrary({super.key});

  @override
  State<AstronomyPictureLibrary> createState() =>
      _AstronomyPictureLibraryState();
}

class _AstronomyPictureLibraryState extends State<AstronomyPictureLibrary> {
  List<String> _imageUrls = [];
  String? _enlargedImageUrl;
  String _searchQuery = "";
  bool _isSearching = false;
  final TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;
  bool _noResults = false; // To handle no result state

  @override
  void initState() {
    super.initState();
    _searchImages("space");
  }

  // Fetch images from NASA API
  Future<void> _searchImages(String query) async {
    setState(() {
      _isLoading = true;
      _isSearching = true;
      _noResults = false; // Reset the no result state
    });

    final String nasaApiUrl =
        'https://images-api.nasa.gov/search?q=$query&media_type=image';
    try {
      final response = await http.get(Uri.parse(nasaApiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['collection']['items'];
        final List<String> urls = [];

        for (var item in items) {
          final links = item['links'];
          if (links != null && links.isNotEmpty) {
            urls.add(links[0]['href']);
          }
        }

        setState(() {
          _imageUrls = urls;
          _noResults = _imageUrls.isEmpty; // Set no result state
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print(e);
      setState(() {
        _noResults = true; // In case of an error, show no results
      });
    } finally {
      setState(() {
        _isSearching = false;
        _isLoading = false;
      });
    }
  }

  // Show the enlarged image
  void _showEnlargedImage(String url) {
    setState(() {
      _enlargedImageUrl = url;
    });
  }

  // Close the enlarged image when clicked outside
  void _closeEnlargedImage() {
    setState(() {
      _enlargedImageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NASA Image Library'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 10),
              _isLoading
                  ? _buildLoadingIndicator()
                  : _noResults
                      ? _buildErrorMessage(context)
                      : _buildImageGrid(),
            ],
          ),
          if (_enlargedImageUrl != null) _buildEnlargedImage(),
        ],
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search for space objects...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            textEditingController.clear();
                            _searchQuery = "";
                            _searchImages("space");
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _searchQuery.isNotEmpty
                ? () {
                    _searchImages(_searchQuery);
                  }
                : null,
            child: const Text("Search"),
          ),
        ],
      ),
    );
  }

  // Grid view to display images
  Widget _buildImageGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 images per row
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _imageUrls.length,
          itemBuilder: (context, index) {
            final imageUrl = _imageUrls[index];
            return GestureDetector(
              onTap: () => _showEnlargedImage(imageUrl),
              child: Hero(
                tag: imageUrl, // Use Hero animation with tag
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Loading indicator widget
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Error message when no images are found
  Widget _buildErrorMessage(context) {
    final double heig = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        children: [
          Gap(heig * 0.21),
          const Icon(
            Icons.hide_image,
            size: 80,
            color: Colors.grey,
          ),
          const Gap(20),
          const Text(
            "No images match your search.\n Please check your input.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget to display enlarged image with Hero animation
  Widget _buildEnlargedImage() {
    return GestureDetector(
      onTap: _closeEnlargedImage, // Close on tap outside image
      child: Container(
        color: Colors.white.withOpacity(0.8), // Dark background
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {}, // Prevent closing when tapping on the image itself
          child: Hero(
            tag: _enlargedImageUrl!, // Hero animation with same tag
            child: CachedNetworkImage(
              imageUrl: _enlargedImageUrl!,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
