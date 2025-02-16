import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../main.dart';
import '../../models/utilities/page_result_object.dart';
import '../../presentation/screens/loginscreen/login_screen.dart';
import 'app_config_provider.dart';
import '../../models/dtos/responses/base/base_response.dart';

class BaseProvider<TModel> with ChangeNotifier {
  static String? _baseUrl;
  String? _endpoint = '';

  BaseProvider([String? endpoint]) {
    _endpoint = endpoint ?? '';
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5055");
  }

  Future<PageResultObject<TModel>?> get({
    dynamic searchRequest,
    String? query,
    required TModel Function(Map<String, dynamic>) fromJson,
  }) async {
    var url = "$_baseUrl$_endpoint${query ?? ''}/Get";

    if (searchRequest != null) {
      var queryString = getQueryString(searchRequest.toJson());
      url = "$url$queryString";
    }

    var uri = Uri.parse(url);
    var headers = await createHeaders();
    var response = await http.get(uri, headers: headers);
    
    if (await isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = PageResultObject<TModel>();
      result.count = data['count'];

      for (var item in data['resultList']) {
        result.resultList.add(fromJson(item));
      }

      return result;
    } else {
      return null;
    }
  }

  Future<List<TModel>?> getRecommendMovieItems({
    String? query,
    required TModel Function(Map<String, dynamic>) fromJson,
  }) async {
    var url = "$_baseUrl$_endpoint${query ?? ''}";

    var uri = Uri.parse(url);
    var headers = await createHeaders();
    var response = await http.get(uri, headers: headers);

    if (await isValidResponse(response)) {
      final List<dynamic> responseBody = json.decode(response.body);

      if (responseBody.every((item) => item == null)) {
        return null;
      }

      return responseBody.map((json) => fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<TModel?> getById(
      {required int id,
      dynamic searchRequest,
      String? query,
      required TModel Function(Map<String, dynamic>) fromJson}) async {
    var url = "$_baseUrl$_endpoint${query ?? ''}/GetById/$id";

    if (searchRequest != null) {
      var queryString = getQueryString(searchRequest.toJson());
      url = "$url$queryString";
    }

    var uri = Uri.parse(url);
    var headers = await createHeaders();
    var response = await http.get(uri, headers: headers);

    if (await isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      return null;
    }
  }

  Future<BaseResponseModel?> insert(
      {required dynamic request,
      String? query,
      bool isQueryable = false,
      isSpecificMethod = false}) async {
    var url =
        "$_baseUrl$_endpoint${query ?? ''}${!isSpecificMethod ? '/Insert' : ''}";

    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.post(
      uri,
      headers: headers,
      body: isQueryable ? null : jsonEncode(request),
    );

    var responseModel = BaseResponseModel(
      statusCode: response.statusCode,
      data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
    );

    if (await isValidResponse(response)) {
      return responseModel;
    } else {
      return null;
    }
  }

  Future<BaseResponseModel?> update(
      {int? id,
      dynamic request,
      String? query,
      isSpecificMethod = false}) async {
    var url =
        "$_baseUrl$_endpoint${query ?? ''}${!isSpecificMethod ? '/Update' : ''}";

    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(request),
    );

    var responseModel = BaseResponseModel(
      statusCode: response.statusCode,
      data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
    );

    if (await isValidResponse(response)) {
      return responseModel;
    } else {
      return null;
    }
  }

  Future<BaseResponseModel?> delete(
      {int? id, String? query, isSpecificMethod = false}) async {
    var url =
        "$_baseUrl$_endpoint${query ?? ''}${!isSpecificMethod ? '/Delete/$id' : ''}";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    var response = await http.delete(uri, headers: headers);

    var responseModel = BaseResponseModel(
      statusCode: response.statusCode,
      data: response.body.isNotEmpty ? jsonDecode(response.body) : null,
    );

    if (await isValidResponse(response)) {
      return responseModel;
    } else {
      return null;
    }
  }

  Future<bool> isValidResponse(Response response) async {
    if (response.statusCode < 299 ||
        (response.statusCode == 400 || response.statusCode == 500)) {
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await AppConfigProvider().signOut();
      GoRouter.of(rootNavigatorKey.currentContext!)
          .goNamed(LoginScreen.routeName);
      return false;
    } else {
      throw Exception("Unknown error. Please try again later");
    }
  }

  Future<Map<String, String>> createHeaders() async {
    var token = await AppConfigProvider().getValueFromStorage("token");

    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      String paramPrefix = query.isEmpty && !inRecursion ? '?' : prefix;

      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }

      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$paramPrefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$paramPrefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
