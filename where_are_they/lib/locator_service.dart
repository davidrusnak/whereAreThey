import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class LocatorService {
  LocatorService() {
    print('called LocatorService constructor');
    _initPositionsSteam();
  }

  final _positionsStream = BehaviorSubject<Position>();
  // .seeded(const Position(
  // longitude: 1,
  // latitude: 1,
  // accuracy: 0,
  // altitude: 0,
  // heading: 0,
  // speed: 0,
  // speedAccuracy: 0,
  // timestamp: null));

  get getPositionStream => _positionsStream;

  _initPositionsSteam() async {
    _checkGeolocatorAvailable();
    await Future.delayed(Duration(seconds: 5));
    Geolocator.getPositionStream().listen((event) {
      _positionsStream.add(event);
    });

    Geolocator.getPositionStream().listen((event) {
      print(event.accuracy.toString());
    });
  }

  Future<Position> _checkGeolocatorAvailable() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
