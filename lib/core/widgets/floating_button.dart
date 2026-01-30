import 'package:cashio/core/constant/app_colors.dart';
import 'package:cashio/features/ai_assistant/ai_assistant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: AppColors.primary,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AiAssistant()),
      ),
      child: Align(
        alignment: AlignmentGeometry.xy(-.15, 0),
        child: const Icon(FontAwesomeIcons.robot, color: AppColors.surface),
      ),
    );
  }
}
