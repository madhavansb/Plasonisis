import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CropPricesScreen extends StatefulWidget {
  const CropPricesScreen({Key? key}) : super(key: key);

  @override
  _CropPricesScreenState createState() => _CropPricesScreenState();
}

class _CropPricesScreenState extends State<CropPricesScreen> {
  List<dynamic> _prices = [];
  bool _loading = true;
  String _error = "";

  Future<void> _fetchDailyPrices() async {
    try {
      final response = await http.get(
        Uri.parse("http://172.16.9.32:5002/daily_prices"),
      );

      if (response.statusCode == 200) {
        setState(() {
          _prices = json.decode(response.body);
          _loading = false;
        });
      } else {
        setState(() {
          _error = "Server error: ${response.statusCode}";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to load data: $e";
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDailyPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Crop Prices"),
        backgroundColor: Colors.green[700],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Text(
                    _error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _prices.length,
                  itemBuilder: (context, index) {
                    final item = _prices[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shadowColor: Colors.green[200],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["commodity"] ?? "Unknown",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "APMC: ${item["apmc"] ?? "N/A"} | State: ${item["state"] ?? "N/A"}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Unit: ${item["unit"] ?? ""} | Date: ${item["date"] ?? ""}",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _priceBox("Min", item["min_price"], Colors.red[200]!),
                                _priceBox(
                                    "Modal", item["modal_price"], Colors.yellow[200]!),
                                _priceBox("Max", item["max_price"], Colors.green[200]!),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _priceBox(String label, dynamic price, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 2),
          Text(
            "₹${price ?? "-"}",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
