import 'package:flutter/material.dart';
import 'package:garden_helper/core/constants/app_colors.dart';
import 'package:garden_helper/core/constants/app_strings.dart';
import 'package:garden_helper/presentation/widgets/catalog_plant_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    AppStrings.indoorPlants,
    AppStrings.gardenPlants,
    AppStrings.greenhousePlants,
    AppStrings.fruitPlants,
    AppStrings.decorativePlants,
    AppStrings.vegetables,
    AppStrings.flowering,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.catalog),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Открыть избранные растения
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategorySelector(),
          _buildNewHarvestedToggle(),
          Expanded(
            child: _buildPlantGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppStrings.searchPlants,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          // TODO: Реализовать поиск растений
        },
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_categories[index]),
              selected: _selectedCategoryIndex == index,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                }
              },
              selectedColor: AppColors.primaryLight,
              labelStyle: TextStyle(
                color: _selectedCategoryIndex == index
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewHarvestedToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Фильтр новых растений
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(12),
                    right: Radius.zero,
                  ),
                ),
              ),
              child: const Text(AppStrings.newPlant),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Фильтр собранных растений
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: AppColors.textSecondary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.zero,
                    right: Radius.circular(12),
                  ),
                ),
              ),
              child: const Text(AppStrings.harvested),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantGrid() {
    // Заглушка для демонстрации
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4, // Заглушка
      itemBuilder: (context, index) {
        final List<Map<String, String>> plantData = [
          {
            'name': 'Суккулент',
            'latinName': 'Sedum plant',
            'image': 'assets/images/succulent.png',
          },
          {
            'name': 'Монстера',
            'latinName': 'Monstera plant',
            'image': 'assets/images/monstera.png',
          },
          {
            'name': 'Африканская маска',
            'latinName': 'African Mask Plant',
            'image': 'assets/images/african_mask.png',
          },
          {
            'name': 'Африканский папоротник',
            'latinName': 'African Nest Fern',
            'image': 'assets/images/african_nest.png',
          },
        ];

        return CatalogPlantCard(
          name: plantData[index]['name'] ?? '',
          latinName: plantData[index]['latinName'] ?? '',
          image: plantData[index]['image'] ?? '',
          onTap: () {
            // TODO: Открыть детали растения
          },
        );
      },
    );
  }
}