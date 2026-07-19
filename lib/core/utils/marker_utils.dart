
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Map<String, BitmapDescriptor>> loadMarkerIcons() async {
  try{
    return {
      "Hotspots": await BitmapDescriptor.asset(ImageConfiguration(size: Size(48, 48)),
          "assets/marker/fish1.png",
      ),
      "Increasing": await BitmapDescriptor.asset(ImageConfiguration(size: Size(48, 48)),
        "assets/marker/fish2.png",
      ),
      "Decreasing": await BitmapDescriptor.asset(ImageConfiguration(size: Size(48, 48)),
        "assets/marker/fish3.png",
      ),
      "Little": await BitmapDescriptor.asset(ImageConfiguration(size: Size(48, 48)),
        "assets/marker/fish4.png",
      ),
    };
  } catch (e) {
    print("Error loading marker icons: $e");
    return {};
  }
}