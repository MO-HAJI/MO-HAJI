import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/gpt_response.dart';
import 'network.dart';

class GptApi {
  late ResponseModel _responseModel;
  Network network = Network();
  late Map<String, dynamic> responseBody = {};
  String responseTxt = '';

  getKeyword(String script) async {
    final response =
        await http.post(Uri.parse('https://api.openai.com/v1/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${dotenv.env['GPT_TOKEN']}'
            },
            body: utf8.encode(jsonEncode({
              "model": "gpt-3.5-turbo-instruct",
              "prompt": '"' +
                  script +
                  '" Please give me one keyword for this food. Just give me the korean menu name only. no explanation.',
              "max_tokens": 50,
              "temperature": 0,
              "top_p": 1,
            })));

    try {
      responseBody = jsonDecode(response.body);
      _responseModel = ResponseModel.fromMap(responseBody);
      responseTxt = utf8.decode(responseBody['choices'][0]['text'].codeUnits);
      // print('responseTxt1: ' + responseTxt);
    } catch (e) {
      print('Error decoding JSON: $e');
      responseTxt = 'Error decoding response';
    }

    String _responseTxt = responseTxt.replaceAll(' ', '');
    _responseTxt = _responseTxt.replaceAll('\n', '');

    return _responseTxt;

    // responseTxtWithoutSpaces = responseTxtWithoutSpaces.replaceAll('\n', '');
  }

  getRecipe(String script) async {
    final response =
        await http.post(Uri.parse('https://api.openai.com/v1/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${dotenv.env['GPT_TOKEN']}'
            },
            body: utf8.encode(jsonEncode({
              "model": "gpt-3.5-turbo-instruct",
              "prompt": '"' +
                  script +
                  '" 이 음식의 레시피를 한국어로 줘. [재료] (10개 이하), [조리 시간], [조리법] 이렇게 3부분으로 나누어서 줘.',
              "max_tokens": 1000,
              "temperature": 0,
              "top_p": 1,
            })));

    try {
      responseBody = jsonDecode(response.body);
      _responseModel = ResponseModel.fromMap(responseBody);
      responseTxt = utf8.decode(responseBody['choices'][0]['text'].codeUnits);
      // print('responseTxt2: ' + responseTxt);
    } catch (e) {
      print('Error decoding JSON: $e');
      responseTxt = 'Error decoding response';
    }

    return responseTxt;
  }

  getAllergy(String script) async {
    final response =
        await http.post(Uri.parse('https://api.openai.com/v1/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${dotenv.env['GPT_TOKEN']}'
            },
            body: utf8.encode(jsonEncode({
              "model": "gpt-3.5-turbo-instruct",
              "prompt":
                  '"' + script + '"  이 음식의 알러지 성분을 한국어로 줘. 쉼표로 구분해서 이름만 줘.',
              "max_tokens": 150,
              "temperature": 0,
              "top_p": 1,
            })));

    try {
      responseBody = jsonDecode(response.body);
      _responseModel = ResponseModel.fromMap(responseBody);
      responseTxt = utf8.decode(responseBody['choices'][0]['text'].codeUnits);
      // print('responseTxt3: ' + responseTxt);
    } catch (e) {
      print('Error decoding JSON: $e');
      responseTxt = 'Error decoding response';
    }

    return responseTxt;
  }
}
