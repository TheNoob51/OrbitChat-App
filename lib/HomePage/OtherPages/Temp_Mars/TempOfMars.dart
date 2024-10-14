import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TemperatureOfMarsPage extends StatefulWidget {
  const TemperatureOfMarsPage({super.key});

  @override
  State<TemperatureOfMarsPage> createState() => _TemperatureOfMarsPageState();
}

class _TemperatureOfMarsPageState extends State<TemperatureOfMarsPage> {
  List<dynamic> solsData = [];
  String apiKey = "DEMO_KEY"; // Replace with your NASA API key

  @override
  void initState() {
    super.initState();
    fetchMarsWeather();
  }

  Future<void> fetchMarsWeather() async {
    final url = Uri.parse(
        'https://api.nasa.gov/insight_weather/?api_key=$apiKey&feedtype=json&ver=1.0');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        List<dynamic> solKeys = data['sol_keys'];

        List<dynamic> tempData = solKeys.map((sol) {
          var solData = data[sol];
          return {
            'sol': sol,
            'temperature': solData['AT'] != null
                ? solData['AT']['av'].toStringAsFixed(2)
                : 'N/A',
            'minTemp': solData['AT'] != null
                ? solData['AT']['mn'].toStringAsFixed(2)
                : 'N/A',
            'maxTemp': solData['AT'] != null
                ? solData['AT']['mx'].toStringAsFixed(2)
                : 'N/A',
            'pressure': solData['PRE'] != null
                ? solData['PRE']['av'].toStringAsFixed(2)
                : 'N/A',
            'windSpeed': solData['HWS'] != null
                ? solData['HWS']['av'].toStringAsFixed(2)
                : 'N/A',
            'season': solData['Season'] != null ? solData['Season'] : 'N/A',
            'mostCommonWind':
                solData['WD'] != null && solData['WD']['most_common'] != null
                    ? solData['WD']['most_common']['compass_point']
                    : 'N/A',
          };
        }).toList();

        setState(() {
          solsData = tempData;
        });
      } else {
        // Handle failure
        setState(() {
          solsData = [];
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        solsData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mars Weather"),
        backgroundColor: Colors.deepPurple[400],
        centerTitle: true,
        elevation: 0,
      ),
      body: solsData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                itemCount: solsData.length,
                itemBuilder: (context, index) {
                  final solData = solsData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.black.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Sol ${solData['sol']}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.orangeAccent,
                              thickness: 1,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Average Temp: ${solData['temperature']} °C',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Min Temp: ${solData['minTemp']} °C',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Max Temp: ${solData['maxTemp']} °C',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Pressure: ${solData['pressure']} Pa',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Wind Speed: ${solData['windSpeed']} m/s',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Season: ${solData['season']}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Most Common Wind: ${solData['mostCommonWind']}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
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
    );
  }
}
