import 'package:racoonmap/core/models/place.dart';
import 'package:racoonmap/frontend/shared/util/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = googleMapsApiKey;

  Future<List<Place>> getPlaces(double lat, double lng) async {
    var response = await http.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=supermarket&rankby=distance&key=$key');
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}
