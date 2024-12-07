import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:whether_app/additonal_info.dart';
import 'package:whether_app/hourly_forecast_item.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({
    super.key,
    required this.screenWidth,
    required this.currentTemp,
    required this.skyIcon,
    required this.skyCondition,
    required this.hourlyData,
    required this.humidityData,
    required this.pressureData,
    required this.windSpeedData,
  });

  final double screenWidth;
  final double currentTemp;
  final dynamic skyIcon;
  final dynamic skyCondition;
  final List<Map<String, dynamic>> hourlyData;
  final int humidityData;
  final int pressureData;
  final double windSpeedData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = screenWidth * 0.9;
          double cardHeight = cardWidth * 0.7;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // Main card
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: cardWidth.clamp(200, 500),
                    height: cardHeight.clamp(150, 300),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      elevation: 10,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '${currentTemp.toString()} K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.network(
                                'https://openweathermap.org/img/wn/$skyIcon@2x.png',
                                width: 150,
                                height: 90,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                skyCondition, // Icon from the API
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height:
                        10), // space between main card and Whether forecast text

                const SafeArea(
                  // Weather forecast Text
                  child: Row(
                    children: [
                      Text(
                        'Hourly Forecast',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height:
                        5), // Space between weather forecast text and its card

                HourlyForecastItem(hourlyData: hourlyData),

                const SizedBox(
                    height:
                        10), // Space between HourlyForecastItem text and Additonal information text

                const SafeArea(
                  // Additional Information Text
                  child: Row(
                    children: [
                      Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height:
                        10), // space between Additional Information text and AdditionalInfoItems

                AdditionalInfoItems(
                  // class AdditionalInfoItems
                  humidity: humidityData,
                  pressure: pressureData,
                  windSpeed: windSpeedData,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
