import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FetchWeather {
  void fetchWeatherData({location, startDate, endDate}) async {
     String? apiKey = dotenv.env['API_KEY'];
    try {
      final weatherData =
          await fetchWeatherApi(apiKey!, location, startDate, endDate);
      printWeatherData(weatherData);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherApi(
      String apiKey, String location, String startDate, String endDate) async {
    const String baseUrl =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline';
    final Uri url = Uri.parse(
        '$baseUrl/$location/$startDate/$endDate?unitGroup=metric&key=$apiKey&include=obs');

    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return {
        'location': jsonResponse['resolvedAddress'],
        'days': jsonResponse['days'],
      };
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  void printWeatherData(Map<String, dynamic> weatherData) {
    print(weatherData);
    for (var day in weatherData['days']) {
      print("\nDate: ${day['datetime']}");
      print("  Max Temp: ${day['tempmax']}°C");
      print("  Min Temp: ${day['tempmin']}°C");
      print("  Average Temp: ${day['temp'] ?? 'N/A'}°C");
      print("  Feels Like: ${day['feelslike'] ?? 'N/A'}°C");
      print("  Humidity: ${day['humidity'] ?? 'N/A'}%");
      print("  Conditions: ${day['conditions'] ?? 'N/A'}");
      print("  Description: ${day['description'] ?? 'N/A'}");
      print("  Sunrise: ${day['sunrise'] ?? 'N/A'}");
      print("  Sunset: ${day['sunset'] ?? 'N/A'}");
    }
  }
}
