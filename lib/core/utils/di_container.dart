import 'package:get_it/get_it.dart';
import 'package:garden_helper/presentation/bloc/navigation/navigation_cubit.dart';
import 'package:garden_helper/presentation/bloc/plants/plants_bloc.dart';
import 'package:garden_helper/presentation/bloc/weather/weather_bloc.dart';
import 'package:garden_helper/presentation/bloc/ai_consultant/ai_consultant_bloc.dart';
import 'package:garden_helper/domain/usecases/plant/get_all_plants_usecase.dart';
import 'package:garden_helper/domain/usecases/plant/get_plants_needing_water_usecase.dart';
import 'package:garden_helper/domain/usecases/plant/water_plant_usecase.dart';
import 'package:garden_helper/domain/usecases/weather/get_current_weather_usecase.dart';
import 'package:garden_helper/domain/usecases/ai_consultant/get_plant_advice_usecase.dart';
import 'package:garden_helper/domain/usecases/ai_consultant/get_plant_diagnosis_usecase.dart';
import 'package:garden_helper/domain/usecases/ai_consultant/identify_plant_by_image_usecase.dart';
import 'package:garden_helper/domain/repositories/plant_repository.dart';
import 'package:garden_helper/domain/repositories/weather_repository.dart';
import 'package:garden_helper/domain/repositories/ai_consultant_repository.dart';
import 'package:garden_helper/data/repositories/plant_repository_impl.dart';
import 'package:garden_helper/data/repositories/weather_repository_impl.dart';
import 'package:garden_helper/data/repositories/ai_consultant_repository_impl.dart';
import 'package:garden_helper/data/datasources/local/plant_local_datasource.dart';
import 'package:garden_helper/data/datasources/remote/plant_remote_datasource.dart';
import 'package:garden_helper/data/datasources/remote/weather_remote_datasource.dart';
import 'package:garden_helper/data/datasources/remote/ai_consultant_remote_datasource.dart';
import 'package:garden_helper/core/network/network_info.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DIContainer {
  static final GetIt _instance = GetIt.instance;

  static T get<T extends Object>() => _instance.get<T>();

  static Future<void> init() async {
    // External
    final sharedPreferences = await SharedPreferences.getInstance();
    _instance.registerLazySingleton(() => sharedPreferences);
    _instance.registerLazySingleton(() => http.Client());
    _instance.registerLazySingleton(() => InternetConnectionChecker());

    // Core
    _instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(get()));

    // Data sources
    _instance.registerLazySingleton<PlantLocalDataSource>(
          () => PlantLocalDataSourceImpl(preferences: get()),
    );
    _instance.registerLazySingleton<PlantRemoteDataSource>(
          () => PlantRemoteDataSourceImpl(client: get()),
    );
    _instance.registerLazySingleton<WeatherRemoteDataSource>(
          () => WeatherRemoteDataSourceImpl(client: get()),
    );
    _instance.registerLazySingleton<AIConsultantRemoteDataSource>(
          () => AIConsultantRemoteDataSourceImpl(client: get()),
    );

    // Repositories
    _instance.registerLazySingleton<PlantRepository>(
          () => PlantRepositoryImpl(
        localDataSource: get(),
        remoteDataSource: get(),
        networkInfo: get(),
      ),
    );
    _instance.registerLazySingleton<WeatherRepository>(
          () => WeatherRepositoryImpl(
        remoteDataSource: get(),
        networkInfo: get(),
      ),
    );
    _instance.registerLazySingleton<AIConsultantRepository>(
          () => AIConsultantRepositoryImpl(
        remoteDataSource: get(),
        networkInfo: get(),
        sharedPreferences: get(),
      ),
    );

    // Use cases
    _instance.registerLazySingleton(() => GetAllPlantsUseCase(get()));
    _instance.registerLazySingleton(() => GetPlantsNeedingWaterUseCase(get()));
    _instance.registerLazySingleton(() => WaterPlantUseCase(get()));
    _instance.registerLazySingleton(() => GetCurrentWeatherUseCase(get()));
    _instance.registerLazySingleton(() => GetPlantAdviceUseCase(get()));
    _instance.registerLazySingleton(() => GetPlantDiagnosisUseCase(get()));
    _instance.registerLazySingleton(() => IdentifyPlantByImageUseCase(get()));

    // Bloc/Cubit
    _instance.registerFactory<NavigationCubit>(() => NavigationCubit());
    _instance.registerFactory<PlantsBloc>(() => PlantsBloc(
      getAllPlantsUseCase: get(),
      getPlantsNeedingWaterUseCase: get(),
      waterPlantUseCase: get(),
    ));
    _instance.registerFactory<WeatherBloc>(() => WeatherBloc(
      getCurrentWeatherUseCase: get(),
    ));
    _instance.registerFactory<AIConsultantBloc>(() => AIConsultantBloc(
      repository: get(),
      getPlantAdviceUseCase: get(),
      getPlantDiagnosisUseCase: get(),
      identifyPlantByImageUseCase: get(),
    ));
  }
}