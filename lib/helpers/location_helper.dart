import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = '';

class LocationHelper {
  static String generateLocationImagePreview(
      {required latitude, required longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    dynamic url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    //print(json.decode(response.body)['results'][0]['formatted_address']);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
