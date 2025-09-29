import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AirQualityScreen(),
    );
  }
}

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  int? aqi;
  double? temperature;
  double? humidity;
  double? windSpeed;
  double? pressure;
  String city = "Bangkok";
  bool loading = true;

  // TODO: ใส่ Token ของคุณเองตรงนี้
  final String token = "e7308c1a378808c98cd0d3f9a2c72dfc85c531e8";

  Future<void> fetchAirQuality() async {
    setState(() {
      loading = true;
    });

    final url = Uri.parse(
        "https://api.waqi.info/feed/here/?token=e7308c1a378808c98cd0d3f9a2c72dfc85c531e8");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          aqi = data['data']['aqi'];
          temperature = data['data']['iaqi']['t']['v']?.toDouble();
          humidity = data['data']['iaqi']['h']['v']?.toDouble();
          windSpeed = data['data']['iaqi']['w']['v']?.toDouble();
          pressure = data['data']['iaqi']['p']['v']?.toDouble();
          loading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      debugPrint("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAirQuality();
  }

  String getAqiStatus(int value) {
    if (value <= 50) return "Good";
    if (value <= 100) return "Moderate";
    if (value <= 150) return "Unhealthy for Sensitive Groups";
    if (value <= 200) return "Unhealthy";
    if (value <= 300) return "Very Unhealthy";
    return "Hazardous";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      body: SafeArea(
        child: Center(
          child: loading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      city,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "AQI: $aqi",
                      style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),
                    ),
                    Text(
                      getAqiStatus(aqi ?? 0),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.thermostat),
                                    Text("${temperature ?? '-'} °C"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.water_drop),
                                    Text("${humidity ?? '-'} %"),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.air),
                                    Text("${windSpeed ?? '-'} m/s"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.speed),
                                    Text("${pressure ?? '-'} hPa"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: fetchAirQuality,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Refresh"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}