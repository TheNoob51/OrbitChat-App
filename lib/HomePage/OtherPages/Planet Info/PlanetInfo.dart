import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'PlanetDetails.dart'; // Assuming you have PlanetDetails imported here

class PlanetInfo extends StatefulWidget {
  const PlanetInfo({super.key});

  @override
  State<PlanetInfo> createState() => _PlanetInfoState();
}

class _PlanetInfoState extends State<PlanetInfo> {
  List<dynamic> planets = [];

  @override
  void initState() {
    super.initState();
    loadPlanetData();
  }

  Future<void> loadPlanetData() async {
    // Load the JSON file from assets
    final String response = await rootBundle
        .loadString('lib/HomePage/OtherPages/Planet Info/planet_details.json');
    final data = await json.decode(response);
    setState(() {
      planets = data['planets'];
      print(planets); // Adjust this based on your JSON structure
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // Set the background to an image
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cover/planet_cover.jpg"),
            fit: BoxFit.cover,

            // image: NetworkImage(
            //     "https://torange.biz/photofxnew/181/IMAGE/rotation-contrast-stained-bright-blue-181766.jpg"),
          ),
        ),
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              title: const Text(
                "PLANETS",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              backgroundColor:
                  Colors.transparent, // Make the AppBar transparent
              elevation: 0, // Remove the shadow under the AppBar
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: planets.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Swiper(
                      itemCount: planets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final planet = planets[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to a new page for the selected planet
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlanetDetailPage(planet: planet)),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Hero(
                                tag: planet['name'], // Tag for Hero animation
                                child: Image.asset(
                                  planet['image']['icon'],
                                  height: 400,
                                  width: 400,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              Positioned(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.125,
                                child: Text(
                                  planet['name'],
                                  style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      pagination: const SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                              color: Colors.white, activeColor: Colors.purple)),
                      control: null,
                      scrollDirection: Axis.horizontal,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
