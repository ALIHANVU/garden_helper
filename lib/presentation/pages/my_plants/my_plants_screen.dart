import 'package:flutter/material.dart';
import 'package:garden_helper/core/constants/app_colors.dart';
import 'package:garden_helper/core/constants/app_strings.dart';
import 'package:garden_helper/presentation/widgets/plant_card.dart';

class MyPlantsScreen extends StatefulWidget {
  const MyPlantsScreen({Key? key}) : super(key: key);

  @override
  State<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Все растения', 'На полив', 'Требуют внимания'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.myPlants),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Открыть уведомления
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllPlantsTab(),
          _buildWateringPlantsTab(),
          _buildNeedsAttentionTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Добавить новое растение
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAllPlantsTab() {
    // Заглушка для демонстрации
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Комнатные растения',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        PlantCard(
          name: 'Monstera Deliciosa',
          latinName: 'Monstera deliciosa',
          image: 'assets/images/monstera.png', // Заглушка
          temperature: '24°',
          light: '65%',
          onTap: () {
            // TODO: Открыть детали растения
          },
        ),
        const SizedBox(height: 12),
        PlantCard(
          name: 'Замиокулькас',
          latinName: 'Zamioculcas zamiifolia',
          image: 'assets/images/zamioculcas.png', // Заглушка
          temperature: '22°',
          light: '45%',
          onTap: () {
            // TODO: Открыть детали растения
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Садовые растения',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        PlantCard(
          name: 'Роза чайная',
          latinName: 'Rosa chinensis',
          image: 'assets/images/rose.png', // Заглушка
          temperature: '25°',
          light: '85%',
          onTap: () {
            // TODO: Открыть детали растения
          },
        ),
      ],
    );
  }

  Widget _buildWateringPlantsTab() {
    // TODO: Реализовать вкладку с растениями, требующими полива
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 64,
            color: AppColors.water,
          ),
          const SizedBox(height: 16),
          const Text(
            'Растения на полив',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Здесь будут отображаться растения, требующие полива',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeedsAttentionTab() {
    // TODO: Реализовать вкладку с растениями, требующими внимания
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: 64,
            color: AppColors.warning,
          ),
          const SizedBox(height: 16),
          const Text(
            'Требуют внимания',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Здесь будут отображаться растения, требующие особого внимания',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}