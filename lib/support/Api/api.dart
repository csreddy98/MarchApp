import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Api {
  final String url = "https://march.lbits.co/api/worker.php";
  static String token;
  static Map<String, String> headersMap;
  Api() {
    getToken().then((value) {
      headersMap = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
    });
  }

  Future<Map> sendMessage(Map bodyContent) async {
    http.Response result = await http.post("$url",
        headers: headersMap, body: json.encode(bodyContent));

    return json.decode(result.body);
  }

  Future<Map> getUserTestimonials(Map bodyContent) async {
    print("$headersMap");
    http.Response result = await http.post("$url",
        headers: headersMap, body: json.encode(bodyContent));
    return json.decode(result.body);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    return token;
  }
}
