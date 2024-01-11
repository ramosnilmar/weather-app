import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService =
      WeatherService(apiKey: 'a57b20a308a8aecf53daa6a24202d139');
  Weather? _weather;

  _fecthWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  String getWeatherAnimation(String? manCondition) {
    if (manCondition == null) return 'assets/sunny.json';

    switch (manCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'show rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fecthWeather();
  }

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.grey[900]!;
    Color textColor = Colors.grey[500]!;

    if (_weather == null) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Text(
            'loading city...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.location_on,
                color: Colors.grey[400],
                size: 24,
              ),
              const SizedBox(height: 10),
              Text(
                _weather?.cityName.toUpperCase() ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 80),
              Container(
                child: Lottie.asset(
                  getWeatherAnimation(_weather?.mainCondition),
                ),
              ),
              const SizedBox(height: 80),
              Text(
                '${_weather?.temperature.round()}°',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
