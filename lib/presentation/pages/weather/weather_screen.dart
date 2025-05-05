import 'package:flutter/material.dart';
import 'package:garden_helper/core/constants/app_colors.dart';
import 'package:garden_helper/core/constants/app_strings.dart';
import 'package:garden_helper/presentation/widgets/weather_info_card.dart';
import 'package:garden_helper/presentation/widgets/hourly_forecast_item.dart';
import 'package:garden_helper/presentation/widgets/daily_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _location = 'Москва'; // Заглушка, в реальном приложении будет геолокация
  String _currentDate = '4 мая 2025'; // Заглушка, в реальном приложении будет текущая дата

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.weather),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () {
              // TODO: Сменить локацию
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLocationHeader(),
          const SizedBox(height: 16),
          _buildCurrentWeather(),
          const SizedBox(height: 24),
          _buildWeatherDetails(),
          const SizedBox(height: 24),
          _buildHourlyForecast(),
          const SizedBox(height: 24),
          _buildDailyForecast(),
          const SizedBox(height: 24),
          _buildGardeningRecommendations(),
        ],
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on,
          size: 20,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          _location,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _currentDate,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wb_sunny,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '24°C',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Солнечно',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeatherInfoItem(Icons.water_drop, '45%', 'Влажность'),
              _buildWeatherInfoItem(Icons.air, '5 м/с', 'Ветер'),
              _buildWeatherInfoItem(Icons.thermostat, '26°C', 'Ощущается'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Подробная информация',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: WeatherInfoCard(
                title: AppStrings.humidity,
                value: '45%',
                icon: Icons.water_drop,
                color: AppColors.water,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: WeatherInfoCard(
                title: AppStrings.uvIndex,
                value: '6',
                icon: Icons.wb_sunny,
                color: AppColors.light,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: WeatherInfoCard(
                title: AppStrings.pressure,
                value: '760 мм',
                icon: Icons.speed,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: WeatherInfoCard(
                title: AppStrings.precipitation,
                value: '0 мм',
                icon: Icons.umbrella,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Прогноз по часам',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              HourlyForecastItem(
                time: 'Сейчас',
                temperature: '24°',
                icon: Icons.wb_sunny,
                iconColor: AppColors.light,
              ),
              HourlyForecastItem(
                time: '13:00',
                temperature: '25°',
                icon: Icons.wb_sunny,
                iconColor: AppColors.light,
              ),
              HourlyForecastItem(
                time: '14:00',
                temperature: '26°',
                icon: Icons.wb_sunny,
                iconColor: AppColors.light,
              ),
              HourlyForecastItem(
                time: '15:00',
                temperature: '25°',
                icon: Icons.wb_sunny,
                iconColor: AppColors.light,
              ),
              HourlyForecastItem(
                time: '16:00',
                temperature: '24°',
                icon: Icons.wb_sunny,
                iconColor: AppColors.light,
              ),
              HourlyForecastItem(
                time: '17:00',
                temperature: '22°',
                icon: Icons.wb_cloudy,
                iconColor: AppColors.secondary,
              ),
              HourlyForecastItem(
                time: '18:00',
                temperature: '20°',
                icon: Icons.wb_cloudy,
                iconColor: AppColors.secondary,
              ),
              HourlyForecastItem(
                time: '19:00',
                temperature: '18°',
                icon: Icons.cloud,
                iconColor: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Прогноз на неделю',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            DailyForecastItem(
              day: 'Сегодня',
              date: '4 мая',
              maxTemp: '26°',
              minTemp: '18°',
              icon: Icons.wb_sunny,
              iconColor: AppColors.light,
            ),
            const Divider(),
            DailyForecastItem(
              day: 'Завтра',
              date: '5 мая',
              maxTemp: '28°',
              minTemp: '19°',
              icon: Icons.wb_sunny,
              iconColor: AppColors.light,
            ),
            const Divider(),
            DailyForecastItem(
              day: 'Понедельник',
              date: '6 мая',
              maxTemp: '25°',
              minTemp: '17°',
              icon: Icons.wb_cloudy,
              iconColor: AppColors.secondary,
            ),
            const Divider(),
            DailyForecastItem(
              day: 'Вторник',
              date: '7 мая',
              maxTemp: '22°',
              minTemp: '15°',
              icon: Icons.cloud,
              iconColor: Colors.grey,
            ),
            const Divider(),
            DailyForecastItem(
              day: 'Среда',
              date: '8 мая',
              maxTemp: '20°',
              minTemp: '14°',
              icon: Icons.water_drop,
              iconColor: AppColors.water,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGardeningRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Рекомендации для садовода',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_florist,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Отличный день для полива растений!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Сегодня подходящий день для полива, так как ожидается сухая погода на ближайшие 24 часа. Рекомендуется подкормить цветущие растения и проверить саженцы на наличие вредителей.',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.waterLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: AppColors.water,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Полив',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Рекомендуется',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.spa,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Посадка',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Рекомендуется',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.content_cut,
                            color: AppColors.light,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Обрезка',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Рекомендуется',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}