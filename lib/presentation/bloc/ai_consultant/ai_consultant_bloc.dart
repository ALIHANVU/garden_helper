import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_helper/core/error/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:garden_helper/domain/entities/ai_consultation_entity.dart';
import 'package:garden_helper/domain/repositories/ai_consultant_repository.dart';
import 'package:garden_helper/domain/usecases/ai_consultant/get_plant_advice_usecase.dart';
import 'package:garden_helper/domain/usecases/ai_consultant/get_plant_diagnosis_usecase.dart';
import 'package:garden_helper/domain/usecases/ai_consultant/identify_plant_by_image_usecase.dart';

// События (Events)
abstract class AIConsultantEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckPremiumStatusEvent extends AIConsultantEvent {}

class SendPlantAdviceQueryEvent extends AIConsultantEvent {
  final String query;

  SendPlantAdviceQueryEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class IdentifyPlantByImageEvent extends AIConsultantEvent {
  final String base64Image;

  IdentifyPlantByImageEvent({required this.base64Image});

  @override
  List<Object> get props => [base64Image];
}

class GetPlantDiagnosisEvent extends AIConsultantEvent {
  final String plantDescription;
  final String symptomsDescription;

  GetPlantDiagnosisEvent({
    required this.plantDescription,
    required this.symptomsDescription,
  });

  @override
  List<Object> get props => [plantDescription, symptomsDescription];
}

// Состояния (States)
abstract class AIConsultantState extends Equatable {
  @override
  List<Object> get props => [];
}

class AIConsultantInitial extends AIConsultantState {}

class CheckingPremiumStatus extends AIConsultantState {}

class PremiumAvailable extends AIConsultantState {}

class PremiumNotAvailable extends AIConsultantState {
  final String message;

  PremiumNotAvailable({required this.message});

  @override
  List<Object> get props => [message];
}

class AIConsultantLoading extends AIConsultantState {}

class AIConsultantError extends AIConsultantState {
  final String message;

  AIConsultantError({required this.message});

  @override
  List<Object> get props => [message];
}

class AdviceReceived extends AIConsultantState {
  final AIConsultationEntity consultation;

  AdviceReceived({required this.consultation});

  @override
  List<Object> get props => [consultation];
}

class PlantIdentified extends AIConsultantState {
  final AIConsultationEntity consultation;

  PlantIdentified({required this.consultation});

  @override
  List<Object> get props => [consultation];
}

class DiagnosisReceived extends AIConsultantState {
  final AIConsultationEntity consultation;

  DiagnosisReceived({required this.consultation});

  @override
  List<Object> get props => [consultation];
}

// BLoC
class AIConsultantBloc extends Bloc<AIConsultantEvent, AIConsultantState> {
  final AIConsultantRepository repository;
  final GetPlantAdviceUseCase getPlantAdviceUseCase;
  final IdentifyPlantByImageUseCase identifyPlantByImageUseCase;
  final GetPlantDiagnosisUseCase getPlantDiagnosisUseCase;

  AIConsultantBloc({
    required this.repository,
    required this.getPlantAdviceUseCase,
    required this.identifyPlantByImageUseCase,
    required this.getPlantDiagnosisUseCase,
  }) : super(AIConsultantInitial()) {
    on<CheckPremiumStatusEvent>(_onCheckPremiumStatus);
    on<SendPlantAdviceQueryEvent>(_onSendPlantAdviceQuery);
    on<IdentifyPlantByImageEvent>(_onIdentifyPlantByImage);
    on<GetPlantDiagnosisEvent>(_onGetPlantDiagnosis);
  }

  Future<void> _onCheckPremiumStatus(
      CheckPremiumStatusEvent event,
      Emitter<AIConsultantState> emit,
      ) async {
    emit(CheckingPremiumStatus());

    final result = await repository.isPremiumAvailable();

    result.fold(
          (failure) => emit(AIConsultantError(message: _mapFailureToMessage(failure))),
          (isPremium) {
        if (isPremium) {
          emit(PremiumAvailable());
        } else {
          emit(PremiumNotAvailable(
            message: 'Для использования ИИ-консультанта необходима премиум-подписка',
          ));
        }
      },
    );
  }

  Future<void> _onSendPlantAdviceQuery(
      SendPlantAdviceQueryEvent event,
      Emitter<AIConsultantState> emit,
      ) async {
    emit(AIConsultantLoading());

    final result = await getPlantAdviceUseCase(PlantAdviceParams(query: event.query));

    result.fold(
          (failure) => emit(AIConsultantError(message: _mapFailureToMessage(failure))),
          (consultation) => emit(AdviceReceived(consultation: consultation)),
    );
  }

  Future<void> _onIdentifyPlantByImage(
      IdentifyPlantByImageEvent event,
      Emitter<AIConsultantState> emit,
      ) async {
    emit(AIConsultantLoading());

    final result = await identifyPlantByImageUseCase(ImageParams(base64Image: event.base64Image));

    result.fold(
          (failure) => emit(AIConsultantError(message: _mapFailureToMessage(failure))),
          (consultation) => emit(PlantIdentified(consultation: consultation)),
    );
  }

  Future<void> _onGetPlantDiagnosis(
      GetPlantDiagnosisEvent event,
      Emitter<AIConsultantState> emit,
      ) async {
    emit(AIConsultantLoading());

    final result = await getPlantDiagnosisUseCase(
      DiagnosisParams(
        plantDescription: event.plantDescription,
        symptomsDescription: event.symptomsDescription,
      ),
    );

    result.fold(
          (failure) => emit(AIConsultantError(message: _mapFailureToMessage(failure))),
          (consultation) => emit(DiagnosisReceived(consultation: consultation)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Ошибка сервера: ${failure.message}';
      case ConnectionFailure:
        return 'Ошибка подключения: ${failure.message}';
      case SubscriptionFailure:
        return failure.message;
      case ValidationFailure:
        return failure.message;
      default:
        return 'Неожиданная ошибка: ${failure.message}';
    }
  }
}