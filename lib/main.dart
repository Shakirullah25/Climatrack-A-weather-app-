import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whether_app/weather_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;

// Declaring Global Constants to be accessible across the app
const String apiKey = '8de39ff94b2842916114bc1d7851011f';
String selectedCity = 'Lagos'; // default city
final List<String> statesInNigeria = [
  // Lists of states to choose from in the dropdown button
  "Lagos",
  "Adamawa",
  "Akwa Ibom",
  "Anambra",
  "Bauchi",
  "Bayelsa",
  "Benue",
  "Borno",
  "Cross River",
  "Delta",
  "Ebonyi",
  "Edo",
  "Ekiti",
  "Enugu",
  "Gombe",
  "Imo",
  "Jigawa",
  "Kaduna",
  "Kano",
  "Katsina",
  "Kebbi",
  "Kogi",
  "Kwara",
  "Abia",
  "Nasarawa",
  "Niger",
  "Ogun",
  "Ondo",
  "Osun",
  "Oyo",
  "Plateau",
  "Rivers",
  "Sokoto",
  "Taraba",
  "Yobe",
  "Zamfara",
  "FCT (Abuja)",
];

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const WeatherAppScreen());
}

class WeatherAppScreen extends StatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  State<WeatherAppScreen> createState() => _WeatherAppScreenState();
}

class _WeatherAppScreenState extends State<WeatherAppScreen> {
  Future<Map<String, dynamic>> fetchCurrentWeatherData(String city) async {
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city,nigeria&APPID=$apiKey';
    try {
      final response = await http
          .get(
        Uri.parse(apiUrl),
      )
          .timeout(
        const Duration(seconds: 5), // 10-secs timeout for the HTTP request
        onTimeout: () {
          throw TimeoutException(
              "The connection has timed out. Please try again.");
        },
      );

      // checking if the status was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw 'An unexpected error occurred';
      }
    } on SocketException catch (_) {
      throw 'No Internet connection. Please check your connection and try again.';
    } catch (e) {
      throw 'Failed to load weather data: $e';
    }
  }

  @override
  void initState() {
    super.initState();
    initializationOfApp();
  }

  void initializationOfApp() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  late Future<
      Map<String,
          dynamic>> _weatherDataFuture = fetchCurrentWeatherData(
      selectedCity); // late variable to store fetchCurrentWeatherData for Future

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _weatherDataFuture = fetchCurrentWeatherData(
          selectedCity); // assigning the fetchCurrentWeatherData to the variable
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Weather in $selectedCity',
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFFCECBD4),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: body(screenWidth),
      ),
    );
  }


// Body of the app

  FutureBuilder<Map<String, dynamic>> body(double screenWidth) {
    return FutureBuilder(
        future: _weatherDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/connection.png',
                    height: 150,
                    width: 200,
                    color: Colors.grey,
                    alignment: Alignment.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Looks like you're not connected to the internet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10), // Space between the error texts
                  const Text(
                    "Let's get you back online!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                      height: 20), // space between text and the retry button
                  ElevatedButton.icon(
                    label: const Text('Try again'),
                    onPressed: () {
                      setState(() {
                        _weatherDataFuture =
                            fetchCurrentWeatherData(selectedCity);
                      }); // Retry fetching data
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0078D3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    icon: const Center(
                        child: Icon(
                      Icons.refresh,
                    )),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data;

          final weatherCondition = data!['list'][0];

          // Safe extraction of data with default values
          final currentTemp = (weatherCondition['main']['temp'] as num)
              .toDouble(); // Ensuring it's double
          final skyCondition =
              weatherCondition['weather'][0]['main'] ?? 'Unknown';
          final skyIcon =
              weatherCondition['weather'][0]['icon'] ?? '01d'; // Default icon
          final humidityData = (weatherCondition['main']['humidity'] as num)
              .toInt(); // Convert to int
          final pressureData = (weatherCondition['main']['pressure'] as num)
              .toInt(); // Convert to int
          final windSpeedData = (weatherCondition['wind']['speed'] as num)
              .toDouble(); // Ensure it's double

          // Extract hourly data (first 6 entries)
          List<Map<String, dynamic>> hourlyData = [];
          for (int i = 0; i < 6; i++) {
            final hourlyWeather = data['list'][i + 1];
            final time = DateTime.parse(hourlyWeather['dt_txt']);

            hourlyData.add(
              {
                'time': DateFormat('h:mm a').format(time),
                'temp': (hourlyWeather['main']['temp'] as num).toString(),
                'icon': hourlyWeather['weather'][0]['icon'] ?? '01d',
              },
            );
          }

          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.blueGrey,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select city',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(22),
                    menuMaxHeight: 320,

                    // dropdownColor: Colors.grey,
                    //isExpanded: true,
                    value: selectedCity,
                    onChanged: (String? newCity) {
                      if (newCity != null) {
                        setState(() {
                          selectedCity = newCity;
                          _weatherDataFuture = fetchCurrentWeatherData(
                              selectedCity); // Refetch data
                        });
                      }
                    },
                    items: statesInNigeria
                        .map<DropdownMenuItem<String>>((String states) {
                      return DropdownMenuItem<String>(
                        value: states,
                        child: Text(states),
                      );
                    }).toList(),
                  ),
                  WeatherScreen(
                    screenWidth: screenWidth,
                    currentTemp: currentTemp,
                    skyIcon: skyIcon,
                    skyCondition: skyCondition,
                    hourlyData: hourlyData,
                    humidityData: humidityData,
                    pressureData: pressureData,
                    windSpeedData: windSpeedData,
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}
