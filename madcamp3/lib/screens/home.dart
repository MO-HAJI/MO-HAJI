import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/widgets.dart' as flutter;
import 'package:image_picker/image_picker.dart' as image_picker;

import '../service/api_google_vision.dart';
import '../service/api_gpt.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  String? script;
  String keyword = ' ';

  VisonApi visionApi = VisonApi();
  GptApi gptApi = GptApi();

  Future<void> _selectImage() async {
    final image_picker.ImagePicker picker = image_picker.ImagePicker();
    final image_picker.XFile? pickedFile =
        await picker.pickImage(source: image_picker.ImageSource.gallery);

    if (pickedFile != null) {
      final String? extractedScript =
          await visionApi.extractLabels(File(pickedFile.path));
      final String extractedKeyword = await gptApi.getKeyword(extractedScript!);

      setState(() {
        _selectedImage = File(pickedFile.path);
        script = extractedScript;
        keyword = extractedKeyword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final extractedTextImage = _selectedImage != null
        ? flutter.Image.file(
            _selectedImage!,
            height: 200,
          )
        : Icon(
            Icons.image,
            size: 100,
          );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          extractedTextImage,
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _selectImage();
            },
            child: Text('음식 추가'),
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          Text(
            '음식: ' + keyword, // 변경
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
