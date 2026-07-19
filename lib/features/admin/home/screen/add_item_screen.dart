import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/core/common/widgets/my_button.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/features/admin/home/screen/home_screen_admin.dart';
import 'package:hotspot/features/admin/home/screen/pick_location_screen.dart';
import 'package:hotspot/features/admin/home/service/add_item_service.dart';
import 'package:hotspot/features/admin/home/widget/show_add_category_dialog.dart';
import 'package:hotspot/go_route.dart';

class AddItemScreen extends ConsumerWidget {
  AddItemScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController newCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);

    _categoryController.text = state.selectedCondition ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add New Hotspot Location"),
        centerTitle: true,
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // map section: display google map or placeholder icon
              Center(
                child: GestureDetector(
                  // Tap to open map picker screen if on location is selected
                  onTap: () async {
                    if (state.selectedLocation == null) {
                      final LatLng? selectedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PickLocationScreen(),
                        ),
                      );
                      if (selectedLocation != null) {
                        notifier.setSelectedLocation(selectedLocation);
                      }
                    }
                  },
                  child: Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: state.selectedLocation == null
                        ? Icon(Icons.location_pin, size: 50)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: state.selectedLocation!,
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId("selected_location"),
                                  position: state.selectedLocation!,
                                  draggable: true,
                                  onDragEnd: (LatLng newPosition) {
                                    notifier.setSelectedLocation(newPosition);
                                  },
                                ),
                              },
                              liteModeEnabled: false,
                              onTap: (LatLng location) {
                                notifier.setSelectedLocation(location);
                              },
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 10),
        
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Location Name",
                  border: OutlineInputBorder(),
                ),
              ),
        
              SizedBox(height: 10),
        
              // Dropdown for selection a condition
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                initialValue: state.selectedCondition,
                decoration: InputDecoration(
                  labelText: "Select Condition",
                  border: OutlineInputBorder(),
                ),
                items: state.conditions.map((String condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    notifier.setSelectedCondition(value);
                  }
                },
              ),
              SizedBox(height: 10),
        
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                initialValue: state.selectedCategory,
                decoration: InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),
                ),
                items: [
                  ...state.categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }),
                  const DropdownMenuItem<String>(
                    value: "Add Category",
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.green),
                        SizedBox(width: 10),
                        Text(
                          "Add Category",
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == "Add Category") {
                    showAddCategoryDialog(context, ref, newCategoryController);
                  } else {
                    notifier.setSelectedCategory(value!);
                  }
                },
              ),
              SizedBox(height: 10),
        
              // read only field
        
              SizedBox(height: 10),
              TextField(
                readOnly: true,
                controller: TextEditingController(text: "0.0"),
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  labelText: "Review",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              MyButton(onTap: ()async{
                try{
                  await notifier.saveItems(locationName: _nameController.text, context: context);
                  mySnackBar(message: "Item saved successfully", context: context);
                  _categoryController.clear();
                  _nameController.clear();
                  NavigationHelper.pushReplacement(context, AdminHomeScreen());
                }catch (e){
                  mySnackBar(message: e.toString(), context: context);
                }
              }, buttonText: "Save")
            ],
          ),
        ),
      ),
    );
  }
}
