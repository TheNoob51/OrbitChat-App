import 'package:devfolio_genai/HomePage/OtherPages/Photo%20of%20the%20Day/photo_of_day.dart';
import 'package:devfolio_genai/HomePage/OtherPages/Planet%20Info/planetInfo.dart';
import 'package:devfolio_genai/HomePage/OtherPages/Space%20News/SpaceNewsPage.dart';
import 'package:devfolio_genai/HomePage/OtherPages/Temp_Mars/TempOfMars.dart';
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
        'imageUrl':
            "https://img.freepik.com/premium-photo/satellite-orbiting-earth-day-sunlight-metallic-surface-satellite-silent-beauty-space-technology-against-background-blue-planet-earth-ozone_507704-10981.jpg", // Placeholder image
        'page': const PhotoOfTheDayPage(), // Add the respective page
      },
      {
        'title': "Planet information",
        'imageUrl':
            "https://img3.wallspic.com/crops/5/0/9/4/5/154905/154905-solar_system-planet-atmosphere-world-nature-1920x1080.jpg", // Placeholder image
        'page': const PlanetInfo(), // Add the respective page
      },
      {
        'title': "Temperature of Mars",
        'imageUrl':
            "https://www.universetoday.com/wp-content/uploads/2017/11/2-msubiologist.jpg", // Placeholder image
        'page': const TemperatureOfMarsPage(), // Add the respective page
      },
      {
        'title': "Space News",
        'imageUrl':
            "https://static.independent.co.uk/2024/02/28/10/newFile-1.jpg", // Placeholder image
        'page': SpaceNewsPage(), // Add the respective page
      },
      {
        'title': "Astronomy Picture",
        'imageUrl':
            "https://science.nasa.gov/wp-content/uploads/2023/09/swift_M31_mosaic_1600.webp?w=1024", // Placeholder image
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

class AstronomyPicturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Astronomy Picture")),
      body: const Center(child: Text("Astronomy Picture Page")),
    );
  }
}
