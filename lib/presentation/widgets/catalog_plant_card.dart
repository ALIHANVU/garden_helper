import 'package:flutter/material.dart';
import 'package:garden_helper/core/constants/app_colors.dart';

class CatalogPlantCard extends StatelessWidget {
  final String name;
  final String latinName;
  final String image;
  final VoidCallback onTap;

  const CatalogPlantCard({
    Key? key,
    required this.name,
    required this.latinName,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение растения
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                width: double.infinity,
                child: Center(
                  child: Icon(
                    Icons.spa,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            // Информация о растении
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      latinName,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _buildDifficultyIndicator(2), // Заглушка для демонстрации
                        const Spacer(),
                        Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(int level) {
    return Row(
      children: List.generate(
        5,
            (index) => Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            Icons.circle,
            size: 8,
            color: index < level ? AppColors.primary : AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}