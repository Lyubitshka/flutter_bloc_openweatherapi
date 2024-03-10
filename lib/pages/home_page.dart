import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:open_weather_app_01_cubit/constants/constants.dart';
import 'package:open_weather_app_01_cubit/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:open_weather_app_01_cubit/cubits/weather/weather_cubit.dart';
import 'package:open_weather_app_01_cubit/pages/search_page.dart';
import 'package:open_weather_app_01_cubit/pages/settings_page.dart';
import 'package:open_weather_app_01_cubit/widgets/error_dialog.dart';
import 'package:recase/recase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenWeather API'),
        actions: [
          IconButton(
            onPressed: () async {
              final weatherCubit = context.read<WeatherCubit>();
              _city = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }),
              );
              print('city: $_city');
              if (_city != null) {
                weatherCubit.fetchWeather(_city!);
              }
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                }),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _showWeather(),
    );
  }

  String showTemperature(double temp) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;
    if (tempUnit == TempUnit.farenheit) {
      return ((temp * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }
    return temp.toStringAsFixed(2) + '℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: TextStyle(fontSize: 24),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Select City',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }
        if (state.status == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return Center(
            child: Text(
              'Select city',
            ),
          );
        }
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: const TextStyle(fontSize: 18),
                ),
                Gap(10),
                Text(
                  "${state.weather.country}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemperature(state.weather.temp),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Gap(20),
                Column(
                  children: [
                    Text(
                      showTemperature(state.weather.tempMax),
                      style: TextStyle(fontSize: 16),
                    ),
                    const Gap(10),
                    Text(
                      showTemperature(state.weather.tempMin),
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                showIcon(state.weather.icon),
                Expanded(flex: 3, child: formatText(state.weather.description)),
                Spacer(),
              ],
            )
          ],
        );
      },
    );
  }
}
