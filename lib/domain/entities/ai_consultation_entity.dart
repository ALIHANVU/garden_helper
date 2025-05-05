import 'package:equatable/equatable.dart';

class AIConsultationEntity extends Equatable {
  final String id;
  final String model;
  final String message;
  final DateTime timestamp;
  final double confidence;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  const AIConsultationEntity({
    required this.id,
    required this.model,
    required this.message,
    required this.timestamp,
    required this.confidence,
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  @override
  List<Object?> get props => [
    id,
    model,
    message,
    timestamp,
    confidence,
    promptTokens,
    completionTokens,
    totalTokens,
  ];
}