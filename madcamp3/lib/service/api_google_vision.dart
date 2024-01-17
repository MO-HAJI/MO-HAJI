import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class VisonApi {
  Future<String?> extractLabels(File? image) async {
    List<String?> _labels = [];

    try {
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(json.decode(
          dotenv.env['GOOGLE_CLOUD_SERVICE_ACCOUNT_JSON']!,
        )),
        [VisionApi.cloudVisionScope],
      );

      final vision = VisionApi(client);

      final imageBytes = await image!.readAsBytes();

      final response = await vision.images.annotate(
        BatchAnnotateImagesRequest.fromJson({
          'requests': [
            {
              'image': {
                'content': base64Encode(imageBytes),
              },
              'features': [
                {"maxResults": 10, 'type': 'LABEL_DETECTION'}
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

        // Process label annotations
        if (labelAnnotations != null && labelAnnotations.isNotEmpty) {
          final labels =
              labelAnnotations.map((label) => label.description).toList();
          _labels = labels;
          print('Labels: $labels');
        }
      } else {
        _labels = [];
      }
    } catch (e, stackTrace) {
      print('Error during Vision API request: $e');
      print('Stack Trace: $stackTrace');
    }

    return _labels.join(', ');
  }
}
