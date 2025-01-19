import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/core/fetch_weather.dart';
import 'package:weather_app/widgets/history_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController cityController =
      TextEditingController(text: "Chennai");
  Map<String, dynamic> weatherData = {};
  late String selectedCity;
  late Map<String, String> dates;
  late List<String> days;

  Map<String, String> getNextSixDays() {
    DateTime today = DateTime.now();
    Map<String, String> dateToDayMap = {};

    for (int i = 0; i < 6; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      String formattedDate =
          '${nextDay.year.toString().padLeft(4, '0')}-${nextDay.month.toString().padLeft(2, '0')}-${nextDay.day.toString().padLeft(2, '0')}';
      String dayOfWeek = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
      ][nextDay.weekday % 7];
      dateToDayMap[formattedDate] = dayOfWeek;
    }

    return dateToDayMap;
  }

  Future renderWeatherData() async {
    FetchWeather fetchWeather = FetchWeather();
    dates = getNextSixDays();
    days = dates.values.toList();
    try {
      final data = await fetchWeather.fetchWeatherApi(
          'ZP4LY6C64PYCYNSQVVBPDJXQA',
          cityController.text,
          dates.keys.first,
          dates.keys.last);
      setState(() {
        weatherData = data;
        selectedCity = cityController.text;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weather: $e')),
      );
    }
  }

  @override
  void initState() {
    renderWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = screenHeight * 0.7;

    Map<String, Color> colors = {
      "Clear": const Color.fromARGB(250, 72, 192, 247), // Bright blue sky
      "Partially cloudy": const Color.fromARGB(215, 57, 4, 59), // Purple
      "Overcast": const Color.fromARGB(220, 169, 169, 169), // Soft gray
      "Light rain": const Color.fromARGB(
          220, 135, 206, 250), // Light blue with a touch of gray
      "Heavy rain": const Color.fromARGB(220, 70, 130, 180), // Steel blue
      "Thunderstorms": const Color.fromARGB(220, 105, 105, 105), // Dark gray
      "Snow": const Color.fromARGB(246, 170, 225, 231), // Light icy blue
      "Fog": const Color.fromARGB(200, 211, 211, 211), // Misty light gray
      "Windy": const Color.fromARGB(220, 170, 222, 229), // Pale sky blue
      "Hazy": const Color.fromARGB(
          220, 255, 228, 181), // Soft pale yellow (hazy sunlight)
    };

    if (weatherData.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: containerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(60),
              ),
              color: weatherData['days'][0]['conditions'] != ""
                  ? colors["${weatherData['days'][0]['conditions']}"]
                  : Colors.red,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40,left: 40,right: 40,bottom: 10),
                    child: TextField(
                      controller: cityController,
                      style: GoogleFonts.rubik(
                          color: Colors.white, fontSize: 20, letterSpacing: 2),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Enter your city',
                        labelStyle: GoogleFonts.rubik(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_forward,
                              color: Colors.white),
                          onPressed: () {
                            final input = cityController.text.trim();
                            if (input.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('City name cannot be empty.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (RegExp(r'^\d+$').hasMatch(input)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('City name cannot contain numbers.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (RegExp(r'[0-9]').hasMatch(input)) {
                              print("contains numbers and letters");
                            } else {
                              // Input is valid
                              print('City: ${input.toUpperCase()}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Current City: ${input.toUpperCase()}'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              renderWeatherData();
                              print(weatherData["days"][0]);
                            }
                          },
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    weatherData['days'][0]['temp'] != 0.0 && weatherData['days'][0]['temp']!=null
                        ? "${weatherData['days'][0]['temp']}°C"
                        : "Error",
                    style: GoogleFonts.rubik(
                      fontSize: 80,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Image.asset(
                    weatherData['days'][0]['conditions'] != ""
                        ? "assets/${weatherData['days'][0]['conditions']}.png"
                        : "assets/Sad.png",
                    width: 150,
                    height: 100,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${weatherData['days'][0]['conditions']}",
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 10,
                      height: 2.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Text(
                    selectedCity.toUpperCase(),
                    style: GoogleFonts.rubik(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    days[0],
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 5,
                    ),
                  ),
                  Text(
                    "${weatherData['days'][0]['datetime']}",
                    style: GoogleFonts.rubik(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: Text(" Next 6 Days",
                    style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2)),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.6),
              itemCount: 6,
              itemBuilder: (context, index) {
                final temp = weatherData['days'][index]['temp'];
                final tempString =
                    temp != null && temp != 0.0 ? temp.toString() : "-";
                final icon = weatherData['days'][0]['conditions'] != ""
                    ? "assets/${weatherData['days'][0]['conditions']}.png"
                    : "assets/Sad.png";
                return HistoryCard(
                  temp: tempString,
                  day: days[index].substring(0, 3),
                  cardColor:
                      colors["${weatherData['days'][0]['conditions']}"] ??
                          Colors.red,
                  icon: icon,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
