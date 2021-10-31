import 'dart:io';
import "package:http/http.dart" as http;
import 'package:tuple/tuple.dart';

const localhostUrl = "http://10.0.2.2:8888";
const dropletUrl = "http://165.22.81.146:8888";
const serverUrl = dropletUrl;

const apiBasePath = "/api/v1";

class Networking {
  Future getFromApiPath(String apiPath) async {
    try {
      http.Response response = await http.get(
        Uri.parse(serverUrl + apiBasePath + apiPath),
        headers: {
          HttpHeaders.acceptHeader: "application/json; charset=UTF-8",
        },
      ).timeout(
        const Duration(seconds: 10),
      );

      return Tuple2<int, String>(response.statusCode, response.body);
    } catch (e) {
      return _errorParsing(e.toString());
    }
  }

  Future postToApiPath(String apiPath, String body) async {
    try {
      http.Response response = await http.post(
        Uri.parse(serverUrl + apiBasePath + apiPath),
        body: body,
        headers: {
          HttpHeaders.acceptHeader: "application/json; charset=UTF-8",
        },
      ).timeout(
        const Duration(seconds: 10),
      );

      return Tuple2<int, String>(response.statusCode, response.body);
    } catch (e) {
      return _errorParsing(e.toString());
    }
  }

  String _errorParsing(String originalErrorText) {
    String customErrorText = "";
    if (originalErrorText.contains("Connection failed") || originalErrorText.contains("SocketException")) {
      originalErrorText = originalErrorText.replaceAll("165.22.81.146", "*");
      customErrorText = "Yhteys palvelimeen epäonnistui. \nPalvelin on alhaalla tai et ole yhteydessä Internettiin.";
    }
    if (originalErrorText.contains("TimeoutException")) {
      customErrorText = "Palvelin ei vastaa. \nPalvelin on alhaalla tai Internetyhteytesi on hidas.";
    }
    return customErrorText == "" ? customErrorText : originalErrorText;
  }
}
