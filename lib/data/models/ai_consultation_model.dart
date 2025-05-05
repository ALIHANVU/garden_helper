import 'package:garden_helper/domain/entities/ai_consultation_entity.dart';

class AIConsultationResponseModel {
  final String id;
  final String model;
  final String message;
  final DateTime timestamp;
  final double confidence;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  AIConsultationResponseModel({
    required this.id,
    required this.model,
    required this.message,
    required this.timestamp,
    required this.confidence,
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory AIConsultationResponseModel.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] ?? [];
    final message = choices.isNotEmpty
        ? choices[0]['message']['content'] ?? ''
        : '';

    final usage = json['usage'] ?? {};

    return AIConsultationResponseModel(
      id: json['id'] ?? '',
      model: json['model'] ?? '',
      message: message,
      timestamp: DateTime.now(),
      confidence: 0.9, // OpenRouter не всегда предоставляет confidence явно
      promptTokens: usage['prompt_tokens'] ?? 0,
      completionTokens: usage['completion_tokens'] ?? 0,
      totalTokens: usage['total_tokens'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'confidence': confidence,
      'promptTokens': promptTokens,
      'completionTokens': completionTokens,
      'totalTokens': totalTokens,
    };
  }

  AIConsultationEntity toEntity() {
    return AIConsultationEntity(
      id: id,
      model: model,
      message: message,
      timestamp: timestamp,
      confidence: confidence,
      promptTokens: promptTokens,
      completionTokens: completionTokens,
      totalTokens: totalTokens,
    );
  }
}