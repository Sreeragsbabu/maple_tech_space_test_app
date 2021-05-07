import 'dart:io';

import 'package:http/io_client.dart';
import 'package:maple_tech_test_app/models/city_details.dart';

class ApiServices{

  static const String cityDetailsUrl = 'https://api.agentroof.ca/api/featured-listings';

  static Future<List<CityDetails>> getCityDetails(String cities) async {
    try {
      var endpointUrl = cityDetailsUrl;
      Map<String, String> queryParams = {
        'nh': cities,
      };
      String queryString = Uri(
          queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;
      HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = new IOClient(httpClient);
      //print(requestUrl);
      var response = await ioClient.get(requestUrl, headers: {
        'APPKEY' : '4nY7QrekqjRaLTFUF4YeP0oa8JexekVx',
      },);
      //print("success");
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<CityDetails> details =
        cityDetailsFromJson(response.body);
        return details;
      } else {
        return List<CityDetails>();
      }
    } catch (e) {
      print(e);
      return List<CityDetails>();
    }
  }
}