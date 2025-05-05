import 'dart:convert';
import 'package:garden_helper/core/error/exceptions.dart';
import 'package:garden_helper/data/models/ai_consultation_model.dart';
import 'package:http/http.dart' as http;

abstract class AIConsultantRemoteDataSource {
  /// Отправляет запрос к модели AI и получает ответ
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<AIConsultationResponseModel> getPlantAdvice(String query);

  /// Отправляет изображение растения для идентификации
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<AIConsultationResponseModel> identifyPlantByImage(String base64Image);

  /// Получает рекомендации по уходу за растением на основе его состояния
  ///
  /// Выбрасывает [ServerException] в случае ошибки
  Future<AIConsultationResponseModel> getDiagnosis(String plantDescription, String symptomsDescription);
}

class AIConsultantRemoteDataSourceImpl implements AIConsultantRemoteDataSource {
  final http.Client client;

  // В реальном приложении ключ должен храниться в безопасном месте, например, в .env файле
  final String apiKey = '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';
  final String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  final String modelId = 'deepseek-ai/deepseek-v2-prover';

  AIConsultantRemoteDataSourceImpl({required this.client});

  @override
  Future<AIConsultationResponseModel> getPlantAdvice(String query) async {
    try {
      final response = await _sendRequest([
        {"role": "system", "content": "Ты - эксперт по садоводству и растениям. Твоя задача - помогать пользователям с уходом за растениями и давать советы по выращиванию. Отвечай подробно, но лаконично, с полезными рекомендациями."},
        {"role": "user", "content": query}
      ]);

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }

  @override
  Future<AIConsultationResponseModel> identifyPlantByImage(String base64Image) async {
    try {
      final response = await _sendRequest([
        {"role": "system", "content": "Ты - эксперт-ботаник. Твоя задача - определить растение по изображению. Укажи название растения на русском и латыни, а также краткую информацию о нем."},
        {"role": "user", "content": [
          {"type": "text", "text": "Что это за растение? Пожалуйста, определи его по изображению."},
          {"type": "image_url", "image_url": {"url": "data:image/jpeg;base64,$base64Image"}}
        ]}
      ]);

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }

  @override
  Future<AIConsultationResponseModel> getDiagnosis(String plantDescription, String symptomsDescription) async {
    try {
      final response = await _sendRequest([
        {"role": "system", "content": "Ты - эксперт-фитопатолог. Твоя задача - определить проблему растения по описанию симптомов и дать рекомендации по лечению."},
        {"role": "user", "content": "Растение: $plantDescription\nСимптомы: $symptomsDescription\n\nКакая проблема может быть у растения и как ее решить?"}
      ]);

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }

  Future<AIConsultationResponseModel> _sendRequest(List<Map<String, dynamic>> messages) async {
    final requestBody = json.encode({
      "model": modelId,
      "messages": messages
    });

    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://gardenhelper.app', // Заглушка для домена приложения
          'X-Title': 'GardenHelper'
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return AIConsultationResponseModel.fromJson(jsonResponse);
      } else {
        throw ServerException(
          message: 'Ошибка при получении ответа от AI: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: 'Ошибка при выполнении запроса: ${e.toString()}',
      );
    }
  }
}