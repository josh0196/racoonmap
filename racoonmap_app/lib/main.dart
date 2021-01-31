import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:racoonmap/core/models/place.dart';
import 'package:racoonmap/core/services/geolocator_service.dart';
import 'package:racoonmap/core/services/places_service.dart';
import 'package:racoonmap/frontend/routes/home/homeRoute.dart';

void main() {
  runApp(RacoonMap());
}

class RacoonMap extends StatelessWidget {
  final locatorService = GeolocatorService();
  final placesService = PlacesService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        FutureProvider(
          create: (context) => BitmapDescriptor.fromAssetImage(
              createLocalImageConfiguration(context),
              'assets/images/dumpster_icon.png'),
        ),
        ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
            update: (context, position, icon, places) {
          return (position != null)
              ? placesService.getPlaces(
                  position.latitude, position.longitude, icon)
              : null;
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Racoonmap',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeRoute(),
      ),
    );
  }
}
