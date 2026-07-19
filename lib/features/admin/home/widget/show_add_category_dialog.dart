import '../../../../core/utils/utils.dart';
import '../service/add_item_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showAddCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    TextEditingController newCategoryController,
    ) async {
  final notifier = ref.read(addItemProvider.notifier);

  final newCategory = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add New Category'),
        content: TextField(
          controller: newCategoryController,
          decoration: const InputDecoration(
            labelText: "Category Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cancel
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, newCategoryController.text.trim());
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );

  if (newCategory != null && newCategory.isNotEmpty) {
    try {
      await notifier.addCategory(newCategory);
      notifier.setSelectedCategory(newCategory);

      newCategoryController.clear();

      if (context.mounted) {
        mySnackBar(
          message: "New Category Added Successfully",
          context: context,
        );
      }
    } catch (e) {
      if (context.mounted) {
        mySnackBar(
          message: e.toString(),
          context: context,
        );
      }
    }
  }
}