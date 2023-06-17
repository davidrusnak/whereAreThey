import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:where_are_they/locator_service.dart';

class Locator extends StatelessWidget {
  Locator({Key? key}) : super(key: key);
  final locatorService = GetIt.I.get<LocatorService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Where are they')),
      body: StreamBuilder<Position>(
        stream: locatorService.getPositionStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return Text(
              'lat: ${snapshot.data?.latitude} lon:${snapshot.data?.longitude}');
        },
      ),
    );
  }
}
