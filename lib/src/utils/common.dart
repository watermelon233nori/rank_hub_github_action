import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Common {
  static Future<void> futureNavigator<T>(
      {required BuildContext context,
      required Future<T> Function() fetchData,
      required Widget Function(T data) builder}) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Fetch data asynchronously
      final data = await fetchData();

      if (!context.mounted) {
        return;
      }
      // Close the loading dialog
      Navigator.pop(context);

      // Navigate to the desired screen with the fetched data
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => builder(data),
        ),
      );
    } catch (e) {
      // Close the loading dialog in case of an error
      Navigator.pop(context);

      // Show an error dialog or handle the error appropriately
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to load data: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
