import 'package:open_weather_app_01_cubit/exceptions/weather_exceptions.dart';
import 'package:open_weather_app_01_cubit/models/custom_error.dart';
import 'package:open_weather_app_01_cubit/models/direct_geocoding.dart';
import 'package:open_weather_app_01_cubit/services/weather_api_services.dart';

import '../models/weather.dart';

class WeatherRepo {
  final WeatherApiServises api;

  WeatherRepo({required this.api});

  Future<Weather> fetchWeather(String city) async {
    try {
      final DirectGeocoding dirGeo = await api.getDirectGeocoding(city);
      print('directGeocoding: $dirGeo');

      final Weather tempWeather = await api.getWeather(dirGeo);
      // print('temp : $tempWeather');

      final Weather weather = tempWeather.copyWith(
        name: dirGeo.name,
        country: dirGeo.country,
      );
      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
