import 'package:flutter/material.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              signOut(context);
            },
            child: Text('Lgout'))
      ],
    );
  }
}
