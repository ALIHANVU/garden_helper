import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_helper/core/constants/app_strings.dart';
import 'package:garden_helper/presentation/bloc/navigation/navigation_cubit.dart';
import 'package:garden_helper/presentation/pages/ai_consultant/ai_consultant_screen.dart';
import 'package:garden_helper/presentation/pages/catalog/catalog_screen.dart';
import 'package:garden_helper/presentation/pages/my_plants/my_plants_screen.dart';
import 'package:garden_helper/presentation/pages/profile/profile_screen.dart';
import 'package:garden_helper/presentation/pages/weather/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Widget> _screens = [
    const MyPlantsScreen(),
    const CatalogScreen(),
    const AIConsultantScreen(),
    const WeatherScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<NavigationCubit>().selectTab(index);
              // Запускаем анимацию при каждом переключении вкладки
              _animationController.reset();
              _animationController.forward();
            },
            items: [
              _buildNavItem(Icons.home_outlined, Icons.home, AppStrings.myPlants, 0, state.selectedIndex),
              _buildNavItem(Icons.book_outlined, Icons.book, AppStrings.catalog, 1, state.selectedIndex),
              _buildNavItem(Icons.smart_toy_outlined, Icons.smart_toy, AppStrings.aiConsultant, 2, state.selectedIndex),
              _buildNavItem(Icons.cloud_outlined, Icons.cloud, AppStrings.weather, 3, state.selectedIndex),
              _buildNavItem(Icons.person_outline, Icons.person, AppStrings.profile, 4, state.selectedIndex),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData outlinedIcon,
      IconData filledIcon,
      String label,
      int index,
      int selectedIndex,
      ) {
    return BottomNavigationBarItem(
      icon: Icon(
        index == selectedIndex ? filledIcon : outlinedIcon,
      ),
      label: label,
    );
  }
}