import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatApiService {
  static Future<String> sendMessageToAI(String message) async {
    try {
      final response = await http.post(
        Uri.parse(dotenv.env['API_URL']!),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": message},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('API ERROR: ${response.statusCode} ${response.body}');
        return "Sorry, the assistant can't connect right now.";
      }
    } catch (e) {
      print('EXCEPTION: $e');
      return "Something went wrong. Please try again.";
    }
  }
}
