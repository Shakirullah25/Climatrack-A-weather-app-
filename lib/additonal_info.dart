import 'package:flutter/material.dart';

class AdditionalInfoItems extends StatelessWidget {
  final int humidity;
  final int pressure;
  final double windSpeed;

  const AdditionalInfoItems({
    super.key,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: [
              const Icon(
                Icons.water_drop,
                size: 32,
              ),
              const SizedBox(height: 5),
              const Text(
                'Humidity',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$humidity%', // Show humidity percentage
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.air,
                size: 32,
              ),
              const SizedBox(height: 5),
              const Text(
                'Wind Speed',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${windSpeed.toString()} m/s', // Display wind speed in m/s
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.beach_access,
                size: 32,
              ),
              const SizedBox(height: 5),
              const Text(
                'Pressure',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$pressure hPa', // Display pressure in hectopascal
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
