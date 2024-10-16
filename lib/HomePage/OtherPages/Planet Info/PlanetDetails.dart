import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PlanetDetailPage extends StatelessWidget {
  final dynamic planet;

  const PlanetDetailPage({super.key, required this.planet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Collapsing SliverAppBar
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            expandedHeight: 350.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                planet['image']['cover'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Remaining content after the app bar
          SliverList(
            delegate: SliverChildListDelegate([
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
                    // Planet logo and title
                    Row(
                      children: [
                        Text(
                          planet['name'],
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Hero(
                          tag: planet['name'],
                          child: Image.asset(
                            width: 100,
                            height: 100,
                            planet['image']['icon'],
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),

                    const Gap(20),
                    // Planet description
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Description",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Gap(5),
                        Text(
                          planet['description'],
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    const Gap(30),

                    // Planet details in a 3x2 Table
                    const Text("Details",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Gap(10),
                    Table(
                      defaultColumnWidth:
                          MediaQuery.of(context).size.width > 600
                              ? const FlexColumnWidth(0.5)
                              : const FlexColumnWidth(1),
                      border: TableBorder.all(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid),
                      children: [
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Discovered By"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(planet['discoveredBy']),
                          ),
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Discovered Year"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(planet['discoveredYear']),
                          ),
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Distance from Sun"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(planet['distanceFromSun']),
                          ),
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Distance from Earth"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(planet['distanceFromEarth']),
                          ),
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Radius"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(planet['radius']),
                          ),
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Temperature (Min/Max)"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${planet['temperature']['min']}°C / ${planet['temperature']['max']}°C"),
                          ),
                        ]),
                      ],
                    ),

                    const Gap(30),

                    // Planet moons
                    const Text("Moons",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Gap(10),
                    Column(
                      children: planet['moons'].isEmpty
                          ? [
                              Center(
                                  child: const Text(
                                      "No moons found for this planet"))
                            ]
                          : List.generate(planet['moons'].length, (index) {
                              final moon = planet['moons'][index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(moon['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Discovered By: ${moon['discoveredBy']}"),
                                    Text(
                                        "Discovered Year: ${moon['discoveredYear']}"),
                                    Text("Radius: ${moon['radius']} km"),
                                  ],
                                ),
                              );
                            }),
                    ),
                    const Gap(20),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
