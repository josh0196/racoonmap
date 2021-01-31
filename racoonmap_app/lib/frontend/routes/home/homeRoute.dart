import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:racoonmap/core/models/place.dart';
import 'package:racoonmap/core/services/geolocator_service.dart';
import 'package:racoonmap/core/services/marker_service.dart';
import 'package:racoonmap/frontend/shared/widgets/SearchBar/search_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeolocatorService();
    final markerService = MarkerService();

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        body: (currentPosition != null)
            ? Consumer<List<Place>>(builder: (_, places, __) {
                var markers = (places != null)
                    ? markerService.getMarkers(places)
                    : List<Marker>();

                return (places != null)
                    ? Stack(
                        children: [
                          GoogleMap(
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(currentPosition.latitude,
                                    currentPosition.longitude),
                                zoom: 12),
                            markers: Set<Marker>.of(markers),
                          ),
                          SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SearchBar(),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  child: PageView.builder(
                                      itemCount: places.length,
                                      controller:
                                          PageController(viewportFraction: 0.9),
                                      itemBuilder: (context, index) => Card(
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: ListTile(
                                              title: Text(places[index].name),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  (places[index].rating != null)
                                                      ? Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 2),
                                                          child:
                                                              RatingBarIndicator(
                                                            rating:
                                                                places[index]
                                                                    .rating,
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            itemCount: 5,
                                                            itemSize: 15.0,
                                                          ),
                                                        )
                                                      : Row(),
                                                  Text(
                                                      '${places[index].vicinity} \u00b7 ${geoService.getFormattedDistance(Unit.m, currentPosition.latitude, currentPosition.longitude, places[index].geometry.location.lat, places[index].geometry.location.lng)}')
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(Icons.directions),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                onPressed: () {
                                                  _launchMapsUrl(
                                                      places[index]
                                                          .geometry
                                                          .location
                                                          .lat,
                                                      places[index]
                                                          .geometry
                                                          .location
                                                          .lng);
                                                },
                                              ),
                                            ),
                                          )),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              })
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url))
      await launch(url);
    else
      throw 'could not launch $url';
  }
}
