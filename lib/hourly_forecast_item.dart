import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final List<Map<String, dynamic>> hourlyData; // List of hourly data

  const HourlyForecastItem({
    super.key,
    required this.hourlyData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 146, // Fixed height for horizontal scrolling
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyData.length,
        itemBuilder: (context, index) {
          final data = hourlyData[index];
          return SizedBox(
            width: 130,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '${data['time']}',
                        style: const TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Image.network(
                        'https://openweathermap.org/img/wn/${data['icon']}@2x.png',
                        width: 45,
                        height: 45,
                      ), // Icon
                      const SizedBox(height: 6),
                      Text(
                        '${data['temp']} K',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ), // Mapping each item to a widget
    );
  }
}
