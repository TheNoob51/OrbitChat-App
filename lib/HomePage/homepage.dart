import 'package:devfolio_genai/HomePage/OtherPages/Astronomy%20Picture/AstronomyPictureLibrary.dart';
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
            "assets/images/cover/photo_of_day_cover.png", // Placeholder image
        'page': const PhotoOfTheDayPage(), // Add the respective page
      },
      {
        'title': "Planet information",
        'imageUrl':
            "assets/images/cover/planet_info_cover.jpg", // Placeholder image
        'page': const PlanetInfo(), // Add the respective page
      },
      {
        'title': "Temperature of Mars",
        'imageUrl':
            "assets/images/cover/mars_temp_cover.jpg", // Placeholder image
        'page': const TemperatureOfMarsPage(), // Add the respective page
      },
      {
        'title': "Space News",
        'imageUrl':
            "assets/images/cover/space_news_cover.png", // Placeholder image
        'page': const SpaceNewsPage(), // Add the respective page
      },
      {
        'title': "Astronomy Picture Gallery",
        'imageUrl':
            "assets/images/cover/astronomy_photo_cover.png", // Placeholder image
        'page': const AstronomyPictureLibrary(), // Add the respective page
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Icon(Icons.explore),
                  Gap(10),
                  Text(
                    "Explore",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
                child: Image.asset(item['imageUrl'], fit: BoxFit.cover),
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

