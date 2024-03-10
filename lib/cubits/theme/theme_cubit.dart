import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_weather_app_01_cubit/constants/constants.dart';
import 'package:open_weather_app_01_cubit/cubits/weather/weather_cubit.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  late final StreamSubscription weatherSubscrition;
  final WeatherCubit weatherCubit;

  ThemeCubit({required this.weatherCubit}) : super(ThemeState.initial()) {
    weatherSubscrition =
        weatherCubit.stream.listen((WeatherState weatherState) {
      print('weatherState: $weatherState');

      if (weatherState.weather.temp > kWarmOrNot) {
        emit(state.copyWith(theme: AppTheme.light));
      } else {
        emit(state.copyWith(theme: AppTheme.dark));
      }
    });
  }
  @override
  Future<void> close() {
    weatherSubscrition.cancel();
    return super.close();
  }
}
