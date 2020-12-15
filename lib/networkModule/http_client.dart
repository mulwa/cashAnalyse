import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mpesa_ledger/networkModule/api_exceptions.dart';
import 'package:mpesa_ledger/utils/constants.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();
  // AuthService authService = locator<AuthService>();

  static HttpClient get instance => _singleton;

  Future<dynamic> fetchData(String url, {Map<String, String> params}) async {
    print("fetch data called");
    // String token = await authService.getUserToken();
    var responseJson;

    var uri = Constants.apiUrl +
        url +
        ((params != null) ? this.queryParameters(params) : "");
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    try {
      final response = await http.get(uri, headers: header);
      // print(response.body.toString());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  String queryParameters(Map<String, String> params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }

  Future<dynamic> postData(String url, dynamic body) async {
    // String token = await authService.getUserToken();
    var responseJson;
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer $token'
    };
    try {
      final response = await http.post(Constants.apiUrl + url,
          body: json.encode(body), headers: header);
      print(response.body);
      print(response.statusCode);
      responseJson = response.statusCode;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
