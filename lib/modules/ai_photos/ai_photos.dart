import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class ImageChat extends StatefulWidget {
  const ImageChat({Key? key}) : super(key: key);

  @override
  State<ImageChat> createState() => _ImageChatState();
}

class _ImageChatState extends State<ImageChat> {
  XFile? pickedImage;
  String mytext = '';
  bool scanning = false;

  TextEditingController prompt = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=AIzaSyAYPi2MhA6-dAc57k2zFMBqSWxe20et1sI';
  final header = {'Content-Type': 'application/json'};

  Future<void> getImage(ImageSource ourSource) async {
    XFile? result = await _imagePicker.pickImage(source: ourSource);

    if (result != null) {
      setState(() {
        pickedImage = result;
      });
    }
  }

  Future<void> getdata(XFile? image, String promptValue) async {
    setState(() {
      scanning = true;
      mytext = '';
    });

    try {
      List<int> imageBytes = await image!.readAsBytes();
      String base64File = base64.encode(imageBytes);

      final data = {
        "contents": [
          {
            "parts": [
              {"text": promptValue},
              {
                "inlineData": {
                  "mimeType": "image/jpeg",
                  "data": base64File,
                }
              }
            ]
          }
        ],
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: header,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        mytext = result['candidates'][0]['content']['parts'][0]['text'];
      } else {
        mytext = 'Response status : ${response.statusCode}';
      }
    } catch (e) {
      print('Error occurred $e');
      mytext = 'Error occurred: $e';
    }

    setState(() {
      scanning = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                      elevation: 0,
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: mainColor,
                      size: 30.0,
                    ),
                    label: Text(
                      'Camera',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: mainColor),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                      elevation: 0,
                    ),
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    icon: Icon(
                      Icons.image_outlined,
                      color: mainColor,
                      size: 30.0,
                    ),
                    label: Text(
                      'Gallery',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: mainColor),
                    ),
                  )
                ],
              ),
            ),
            pickedImage == null
                ? Container(
                    height: 340,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color.fromARGB(125, 0, 0, 0),
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/lottie/c.json',
                            animate: true,
                          ),
                          Text(
                            'No Image Yet',
                            style: TextStyle(
                                fontSize: 22,
                                color: Color.fromARGB(125, 0, 0, 0)),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 340,
                    child: Center(
                      child: Image.file(
                        File(pickedImage!.path),
                        height: 400,
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            TextField(
              controller: prompt,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: mainColor,
                    width: 2.0,
                  ),
                ),
                hintText: 'Enter your prompt here',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                getdata(pickedImage, prompt.text);
              },
              icon: Icon(
                Icons.bolt_outlined,
                color: Colors.white,
              ),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Answer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
              ),
            ),
            SizedBox(height: 30),
            scanning
                ? Center(
                    child: SpinKitFoldingCube(
                    color: mainColor,
                    size: 20,
                  ))
                : Text(
                    mytext,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
          ],
        ),
      ),
    );
  }
}
