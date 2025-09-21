import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherNewsScreen extends StatefulWidget {
  @override
  _WeatherNewsScreenState createState() => _WeatherNewsScreenState();
}

class _WeatherNewsScreenState extends State<WeatherNewsScreen> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;

  final String apiKey = "2ff5c46111e476da27a91bf4bae7cd4c";

  Future<void> _fetchWeather() async {
    if (_cityController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final city = _cityController.text.trim();
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() => _weatherData = json.decode(response.body));
      } else {
        setState(() => _weatherData = null);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("City not found")));
      }
    } catch (e) {
      setState(() => _weatherData = null);
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildWeatherCard() {
    if (_weatherData == null) return Text("Search for a city to see weather");

    final cityName = _weatherData!['name'];
    final temp = _weatherData!['main']['temp'];
    final desc = _weatherData!['weather'][0]['description'];

    return Card(
      color: Colors.green[300],
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              cityName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "$temp °C",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              desc,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather News")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Enter city name",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.green[700]),
                  onPressed: _fetchWeather,
                ),
              ),
              onSubmitted: (_) => _fetchWeather(),
            ),
            SizedBox(height: 20),
            _isLoading ? CircularProgressIndicator() : _buildWeatherCard(),
          ],
        ),
      ),
    );
  }
}
