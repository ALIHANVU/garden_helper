import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_helper/core/constants/app_colors.dart';
import 'package:garden_helper/core/constants/app_strings.dart';
import 'package:garden_helper/domain/entities/ai_consultation_entity.dart';
import 'package:garden_helper/presentation/bloc/ai_consultant/ai_consultant_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AIConsultantScreen extends StatefulWidget {
  const AIConsultantScreen({Key? key}) : super(key: key);

  @override
  State<AIConsultantScreen> createState() => _AIConsultantScreenState();
}

class _AIConsultantScreenState extends State<AIConsultantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Проверка премиум-статуса при входе на экран
    context.read<AIConsultantBloc>().add(CheckPremiumStatusEvent());
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.aiConsultant),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {
              _takePicture();
            },
          ),
        ],
      ),
      body: BlocConsumer<AIConsultantBloc, AIConsultantState>(
        listener: (context, state) {
          if (state is AdviceReceived) {
            _handleAIResponse(state.consultation);
          } else if (state is PlantIdentified) {
            _handleAIResponse(state.consultation);
          } else if (state is DiagnosisReceived) {
            _handleAIResponse(state.consultation);
          } else if (state is AIConsultantError) {
            _showErrorSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is CheckingPremiumStatus || state is AIConsultantInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PremiumNotAvailable) {
            return _buildPremiumPromotionWidget(state.message);
          } else {
            return _buildChatInterface();
          }
        },
      ),
    );
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? _buildEmptyChatPlaceholder()
              : _buildChatMessages(),
        ),
        if (_isTyping)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'ИИ-консультант печатает...',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        _buildInputField(),
      ],
    );
  }

  Widget _buildEmptyChatPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'ИИ-консультант готов помочь',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Задайте вопрос о ваших растениях или загрузите фото для идентификации',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSuggestionChips(),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final List<String> suggestions = [
      'Как часто поливать замиокулькас?',
      'Почему у моей фиалки желтеют листья?',
      'Какие растения подходят для тени?',
      'Как повысить влажность для тропических растений?',
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: suggestions.map((suggestion) {
        return ActionChip(
          label: Text(suggestion),
          onPressed: () {
            _addUserMessage(suggestion);
            _sendPlantAdviceQuery(suggestion);
          },
        );
      }).toList(),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      reverse: true, // Новые сообщения появляются снизу
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[_messages.length - 1 - index]; // Обратный порядок
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.hasImage)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(message.imagePath!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined),
            onPressed: () {
              _pickImage();
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Введите сообщение...',
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                final query = _messageController.text.trim();
                _addUserMessage(query);
                _sendPlantAdviceQuery(query);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPromotionWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.premiumLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                size: 80,
                color: AppColors.premium,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Доступно только для Premium',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Реализовать переход на экран оформления подписки
                // Временное решение для демонстрации
                _activatePremiumForDemo();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.premium,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Оформить подписку Premium'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // TODO: Показать преимущества Premium
              },
              child: const Text('Узнать больше о Premium'),
            ),
          ],
        ),
      ),
    );
  }

  void _addUserMessage(String text, {String? imagePath}) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
          imagePath: imagePath,
        ),
      );
    });
  }

  void _addAIMessage(String text) {
    setState(() {
      _isTyping = false;
      _messages.add(
        ChatMessage(
          text: text,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _handleAIResponse(AIConsultationEntity consultation) {
    _addAIMessage(consultation.message);
  }

  void _showErrorSnackBar(String message) {
    setState(() {
      _isTyping = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _sendPlantAdviceQuery(String query) {
    setState(() {
      _isTyping = true;
    });

    context.read<AIConsultantBloc>().add(
      SendPlantAdviceQueryEvent(query: query),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _processImage(image);
    }
  }

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _processImage(image);
    }
  }

  Future<void> _processImage(XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      _addUserMessage('Определите это растение, пожалуйста.', imagePath: image.path);

      setState(() {
        _isTyping = true;
      });

      context.read<AIConsultantBloc>().add(
        IdentifyPlantByImageEvent(base64Image: base64Image),
      );
    } catch (e) {
      _showErrorSnackBar('Ошибка при обработке изображения: $e');
    }
  }

  // Временное решение для демонстрации
  void _activatePremiumForDemo() {
    // В реальном приложении здесь будет интеграция с платежной системой
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Активация Premium'),
        content: const Text('Подписка успешно активирована!\n\nЭто демонстрационный режим для тестирования функциональности ИИ-консультанта.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Имитация активации Premium
              context.read<AIConsultantBloc>().add(CheckPremiumStatusEvent());
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Заглушка для демонстрации - добавление Premium-доступа в SharedPreferences
    // В реальном приложении это будет происходить после успешной оплаты
    Future.delayed(const Duration(seconds: 1), () {
      // Здесь была бы реализация сохранения статуса Premium в SharedPreferences
      // sharedPreferences.setBool('premium_user', true);
      // sharedPreferences.setString('premium_expiry', DateTime.now().add(const Duration(days: 30)).toIso8601String());

      // Для демонстрации просто меняем состояние в BLoC
      context.read<AIConsultantBloc>().emit(PremiumAvailable());
    });
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imagePath,
  });

  bool get hasImage => imagePath != null;
}