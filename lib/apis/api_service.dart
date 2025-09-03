import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as developer;

class ApiService {
    static String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    static bool isValidApiKey() {
      developer.log('Checking API key validity...');
      developer.log('Raw API Key from .env: ${dotenv.env['GEMINI_API_KEY']}');
      developer.log('Processed API Key: $apiKey');
      
      if (apiKey.isEmpty) {
        developer.log('ERROR: API key is empty');
        return false;
      }
      
      if (!apiKey.startsWith('AI')) {
        developer.log('ERROR: API key does not start with "AI"');
        return false;
      }
      
      developer.log('API key format is valid');
      return true;
    }

    static Future<bool> testApiConnection() async {
      try {
        developer.log('Starting API connection test...');
        
        if (!isValidApiKey()) {
          throw Exception('Invalid API key configuration. Please check your .env file and API key format.');
        }
        
        developer.log('Initializing GenerativeModel...');
        final model = GenerativeModel(
          model: 'gemini-1.5-flash-001',
          apiKey: apiKey,
        );
        
        developer.log('Starting chat...');
        final chat = model.startChat();
        
        developer.log('Sending test message...');
        final response = await chat.sendMessage(Content.text('test'));
        
        if (response.text == null) {
          developer.log('ERROR: Received null response from API');
          return false;
        }
        
        developer.log('Successfully received response: ${response.text}');
        return true;
      } catch (e, stackTrace) {
        developer.log(
          'API Connection test failed',
          error: e,
          stackTrace: stackTrace
        );
        return false;
      }
    }
}