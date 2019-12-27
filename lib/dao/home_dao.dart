import 'dart:async';

//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_trip/model/home_model.dart';

const HOME_URL = 'https://www.devio.org/io/flutter_app/json/home_page.json';

class HomeDao {
  static Future<HomeModel> fetch() async {
    /*  final response = await http.get(HOME_URL);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }*/

    Response response = await Dio().get(HOME_URL);
    if (response.statusCode == 200) {
      return HomeModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}
