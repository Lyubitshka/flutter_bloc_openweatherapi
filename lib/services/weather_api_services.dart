import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_app_01_cubit/constants/constants.dart';
import 'package:open_weather_app_01_cubit/exceptions/weather_exceptions.dart';
import 'package:open_weather_app_01_cubit/models/direct_geocoding.dart';
import 'package:open_weather_app_01_cubit/services/http_error_handler.dart';

import '../models/weather.dart';

class WeatherApiServises {
  final http.Client httpClient;

  WeatherApiServises({required this.httpClient});

  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    final Uri uri = Uri(
      scheme: 'http',
      host: kApiHost,
      path: '/geo/1.0/direct',
      queryParameters: {
        'q': city,
        'limit': kLimit,
        'appid': dotenv.env['APIKEY'],
      },
    );
    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw WeatherException('Cannot get the location of $city');
      }
      final directGeocoding = DirectGeocoding.fromJson(responseBody);
      return directGeocoding;
    } catch (error) {
      rethrow;
    }
  }

  Future<Weather> getWeather(DirectGeocoding directGeocoding) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/data/2.5/weather',
      queryParameters: {
        'lat': '${directGeocoding.lat}',
        'lon': '${directGeocoding.lon}',
        'units': kUnit,
        'appid': dotenv.env['APIKEY'],
      },
    );
    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }
      final weatherJson = json.decode(response.body);

      final Weather weather = Weather.fromJson(weatherJson);
      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
