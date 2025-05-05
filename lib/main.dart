import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_helper/core/constants/app_themes.dart';
import 'package:garden_helper/core/utils/di_container.dart';
import 'package:garden_helper/presentation/bloc/navigation/navigation_cubit.dart';
import 'package:garden_helper/presentation/pages/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:garden_helper/core/constants/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp();

  // Инициализация Hive для локального хранения
  await Hive.initFlutter();

  // Регистрация адаптеров Hive
  // await Hive.openBox<PlantModel>('plants');

  // Инициализация DI контейнера
  await DIContainer.init();

  // Установка ориентации экрана
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (context) => DIContainer.get<NavigationCubit>(),
        ),
        // Здесь будут другие провайдеры BLoC
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'),
          Locale('en', 'US'),
        ],
        home: const HomeScreen(),
      ),
    );
  }
}