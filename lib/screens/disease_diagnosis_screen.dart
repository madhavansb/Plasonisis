import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiseaseDiagnosisScreen extends StatefulWidget {
  @override
  _DiseaseDiagnosisScreenState createState() => _DiseaseDiagnosisScreenState();
}

class _DiseaseDiagnosisScreenState extends State<DiseaseDiagnosisScreen> {
  String? disease;
  String? recovery;
  bool isLoading = false;

  void pickAndUploadImage() async {
    var uploadInput = FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((e) async {
        setState(() {
          isLoading = true;
        });

        final request = http.MultipartRequest(
          'POST',
          Uri.parse('http://172.16.9.32:5001/api/disease-diagnosis'),
        );

        request.files.add(http.MultipartFile.fromBytes(
          'image',
          reader.result as List<int>,
          filename: file.name,
        ));

        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final jsonResp = json.decode(respStr);

        setState(() {
          disease = jsonResp['disease'];
          recovery = jsonResp['recovery'];
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Diagnosis'),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: pickAndUploadImage,
                child: Text('Upload Leaf Image'),
              ),
              SizedBox(height: 20),
              if (isLoading) CircularProgressIndicator(),
              if (disease != null && recovery != null) ...[
                Text('Disease: $disease',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700])),
                SizedBox(height: 10),
                Text('Recovery: $recovery', style: TextStyle(fontSize: 16)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
