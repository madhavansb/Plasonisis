import 'package:flutter/material.dart';
import 'crop_prices_screen.dart';
import 'disease_diagnosis_screen.dart';
//import 'scheme_details_screen.dart';
import 'agri_news_screen.dart';
import 'weather_news_screen.dart';
import 'ai_chatbot_screen.dart'; // Optional for bottom right floating button

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      'title': 'Crop Prices',
      'color': Colors.green,
      'icon': Icons.attach_money,
      'screen': CropPricesScreen(),
    },
    {
      'title': 'Disease Diagnosis',
      'color': Colors.redAccent,
      'icon': Icons.healing,
      'screen': DiseaseDiagnosisScreen(),
    },
    {
      'title': 'Agri News',
      'color': Colors.blueAccent,
      'icon': Icons.newspaper,
      'screen': AgriNewsScreen(),
    },
    {
      'title': 'Weather News',
      'color': Colors.lightBlue,
      'icon': Icons.cloud,
      'screen': WeatherNewsScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plasonisis'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => feature['screen'],
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                color: feature['color'].withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(feature['icon'], size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        feature['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AIChatbotScreen()),
          );
        },
      ),
    );
  }
}
