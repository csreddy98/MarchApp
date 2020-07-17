import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Api {
  final String url = "https://march.lbits.co/api/worker.php";
  static String token;

  Api() {
    getToken();
  }

  Map headersMap = {
    HttpHeaders.contentTypeHeader: ContentType.json,
    HttpHeaders.authorizationHeader: "Bearer $token"
  };

  Future<Map> sendMessage(Map bodyContent) async {
    http.Response result = await http.post("$url",
        headers: headersMap, body: json.encode(bodyContent));

    return json.decode(result.body);
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
  }
}
