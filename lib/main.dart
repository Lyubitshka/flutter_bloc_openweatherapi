import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_weather_app_01_cubit/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:open_weather_app_01_cubit/cubits/theme/theme_cubit.dart';
import 'package:open_weather_app_01_cubit/cubits/weather/weather_cubit.dart';
import 'package:open_weather_app_01_cubit/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_app_01_cubit/repository/weather_repository.dart';
import 'package:open_weather_app_01_cubit/services/weather_api_services.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepo(
        api: WeatherApiServises(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) =>
                WeatherCubit(weatherRepository: context.read<WeatherRepo>()),
          ),
          BlocProvider<TempSettingsCubit>(
            create: (context) => TempSettingsCubit(),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(
              weatherCubit: context.read<WeatherCubit>(),
            ),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Weather App',
              theme: state.theme == AppTheme.light
                  ? ThemeData.light()
                  : ThemeData.dark(),
              home: HomePage(),
            );
          },
        ),
      ),
    );
  }
}
