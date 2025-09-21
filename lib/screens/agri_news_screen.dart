import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgriNewsScreen extends StatefulWidget {
  @override
  _AgriNewsScreenState createState() => _AgriNewsScreenState();
}

class _AgriNewsScreenState extends State<AgriNewsScreen> {
  List newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAgriNews();
  }

  Future<void> fetchAgriNews() async {
    try {
      final response = await http.get(
        Uri.parse("http://your_ip:5000/api/agri-news"), // Use your LAN IP
      );

      if (response.statusCode == 200) {
        setState(() {
          newsList = json.decode(response.body) as List;
          isLoading = false;
        });
        print("Fetched ${newsList.length} articles"); // Debug
      } else {
        print("Failed to load news: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching news: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agri News'),
        backgroundColor: Colors.green[700],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : newsList.isEmpty
              ? Center(child: Text('No news available'))
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (news['urlToImage'] != null && news['urlToImage'] != "")
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  news['urlToImage'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: Center(child: Icon(Icons.broken_image)),
                                  ),
                                ),
                              ),
                            SizedBox(height: 10),
                            Text(
                              news['title'] ?? 'No Title',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(news['description'] ?? 'No Description'),
                            SizedBox(height: 5),
                            Text(
                              news['publishedAt'] != null
                                  ? news['publishedAt'].substring(0, 10)
                                  : '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
