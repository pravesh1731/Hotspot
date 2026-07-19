import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/core/provider/load_marker_provider.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/features/admin/home/screen/add_item_screen.dart';
import 'package:hotspot/features/admin/home/service/display_item_service.dart';
import 'package:hotspot/features/shared/service/google_auth_service.dart';
import 'package:hotspot/go_route.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotspotData = ref.watch(adminHotspots);
    final markerIcon = ref.watch(markerIconProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.white,
        title: Text("Admin Dashboard"),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.add_chart)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              child: Icon(Icons.supervised_user_circle_outlined, size: 30),
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseServices().signOutUser();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: hotspotData.when(
        data: (hotspots) {
          if (hotspots.isEmpty) {
            return Center(child: Text("No hotspots available"));
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: hotspots.length,
            itemBuilder: (context, index) {
              final hotspot = hotspots[index];
              return GestureDetector(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 0.1,
                  shadowColor: Colors.green.shade100,
                  child: SizedBox(
                    height: 170,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hotspot.locationName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: hotspot.locationName.length <= 32
                                        ? 18
                                        : 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text("Condition: ${hotspot.condition}"),
                                Text("Fish type ${hotspot.category}"),
                                Text(
                                  "Rating: ${hotspot.rating.toStringAsFixed(1)}",
                                ),
                                Text(
                                  "Uploaded by: ${formatTimeAgo(hotspot.createdAt)}",
                                ),
                                Text(
                                  "Latitude: ${hotspot.latitude.toStringAsFixed(6)}",
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Reviews: ${hotspot.reviewCount.length}",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: markerIcon.when(
                            data: (markerIcons) => GoogleMap(
                              myLocationButtonEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  hotspot.latitude,
                                  hotspot.longitude,
                                ),
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId(hotspot.id),
                                  position: LatLng(hotspot.latitude, hotspot.longitude),
                                  icon: markerIcons[hotspot.condition]??
                                    BitmapDescriptor.defaultMarker
                                ),

                              },
                            ),
                            error: (error, _) =>
                                Center(child: Text("Error loading marker")),
                            loading: () =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (e, _) => Text("Error: $e"),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationHelper.push(context, AddItemScreen());
        },
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),
      ),
    );
  }
}
