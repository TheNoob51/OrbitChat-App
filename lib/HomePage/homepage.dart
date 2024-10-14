import 'package:devfolio_genai/HomePage/OtherPages/Photo%20of%20the%20Day/photo_of_day.dart';
import 'package:devfolio_genai/HomePage/OtherPages/Planet%20Info/planetInfo.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the gallery items
    final List<Map<String, dynamic>> galleryItems = [
      {
        'title': "Photo of the Day",
        'imageUrl': "https://via.placeholder.com/300", // Placeholder image
        'page': const PhotoOfTheDayPage(), // Add the respective page
      },
      {
        'title': "Planet information",
        'imageUrl':
            "https://via.placeholder.com/300/FF5733", // Placeholder image
        'page': PlanetInfo(), // Add the respective page
      },
      {
        'title': "Temperature of Mars",
        'imageUrl':
            "https://via.placeholder.com/300/33FF57", // Placeholder image
        'page': TemperatureOfMarsPage(), // Add the respective page
      },
      {
        'title': "Space News",
        'imageUrl':
            "https://via.placeholder.com/300/3357FF", // Placeholder image
        'page': SpaceNewsPage(), // Add the respective page
      },
      {
        'title': "Astronomy Picture",
        'imageUrl':
            "https://via.placeholder.com/300/FF33A8", // Placeholder image
        'page': AstronomyPicturePage(), // Add the respective page
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.explore),
                Text(
                  "Explore",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(20),
            Expanded(
              child: CarouselSlider.builder(
                itemCount: galleryItems.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return _buildCarouselItem(context, galleryItems[itemIndex]);
                },
                options: CarouselOptions(
                  height: 400,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  scrollDirection: Axis.vertical, // Set vertical scrolling
                  enlargeCenterPage: true, // Enlarge the centered item
                  aspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item['page']),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(15), // Rounded corners for the image
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.network(
                  item['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              // Title text
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(85, 0, 0, 0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example pages

class TemperatureOfMarsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Temperature of Mars")),
      body: const Center(child: Text("Temperature of Mars Page")),
    );
  }
}

class SpaceNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Space News")),
      body: const Center(child: Text("Space News Page")),
    );
  }
}

class AstronomyPicturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Astronomy Picture")),
      body: const Center(child: Text("Astronomy Picture Page")),
    );
  }
}
