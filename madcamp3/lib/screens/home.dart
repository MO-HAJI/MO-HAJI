import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/widgets.dart' as flutter;
import 'package:image_picker/image_picker.dart' as image_picker;

class VisionApiExample extends StatefulWidget {
  @override
  _VisionApiExampleState createState() => _VisionApiExampleState();
}

class _VisionApiExampleState extends State<VisionApiExample> {
  File? _selectedImage;
  String _extractedText = '';
  List<String?> _labels = [];

  Future<void> _selectImage() async {
    final image_picker.ImagePicker picker = image_picker.ImagePicker();
    final image_picker.XFile? pickedFile =
        await picker.pickImage(source: image_picker.ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _extractedText =
            ''; // Reset extracted text when a new image is selected
      });
      _extractTextAndLabelsFromImage();
    }
  }

  Future<void> _extractTextAndLabelsFromImage() async {
    if (_selectedImage == null) return;

    print('Selected Image Path: ${_selectedImage!.path}');

    try {
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(json.decode(
          dotenv.env['GOOGLE_CLOUD_SERVICE_ACCOUNT_JSON']!,
        )),
        [VisionApi.cloudVisionScope],
      );

      final vision = VisionApi(client);

      final imageBytes = await _selectedImage!.readAsBytes();

      final response = await vision.images.annotate(
        BatchAnnotateImagesRequest.fromJson({
          'requests': [
            {
              'image': {
                'content': base64Encode(imageBytes),
              },
              'features': [
                {'type': 'TEXT_DETECTION'},
                {'type': 'LABEL_DETECTION'}
              ],
            },
          ],
        }),
      );

      if (response.responses != null && response.responses!.isNotEmpty) {
        // Process results for each image, assuming only one image is requested
        final annotateImageResponse = response.responses![0];
        final textAnnotations = annotateImageResponse.textAnnotations;
        final labelAnnotations = annotateImageResponse.labelAnnotations;

        // Process text annotations
        if (textAnnotations != null && textAnnotations.isNotEmpty) {
          final extractedText = textAnnotations[0].description;
          if (extractedText != null && extractedText.isNotEmpty) {
            setState(() {
              _extractedText = extractedText;
            });
            print('Extracted Text: $extractedText');
          }
        }

        // Process label annotations
        if (labelAnnotations != null && labelAnnotations.isNotEmpty) {
          final labels =
              labelAnnotations.map((label) => label.description).toList();
          setState(() {
            _labels = labels;
          });
          print('Labels: $labels');
        }
      } else {
        setState(() {
          _extractedText = 'No text found';
          _labels = [];
        });
      }
    } catch (e, stackTrace) {
      print('Error during Vision API request: $e');
      print('Stack Trace: $stackTrace');
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
      appBar: AppBar(
        title: Text('Google Vision API Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          extractedTextImage,
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectImage,
            child: Text('Select Image'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _extractTextAndLabelsFromImage,
            child: Text('Extract Text and Labels'),
          ),
          SizedBox(height: 20),
          Text(
            'Extracted Text: $_extractedText',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            'Labels: ${_labels.join(', ')}', // 변경
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
