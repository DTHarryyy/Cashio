import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsDashboardCard extends StatelessWidget {
  const GoalsDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            const Color.fromARGB(255, 139, 64, 238).withAlpha(95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 10,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: const Color.fromARGB(255, 190, 192, 194),
                    value: .5,
                    constraints: BoxConstraints(minHeight: 80, minWidth: 80),
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(255, 123, 235, 164),
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                  Column(
                    children: [
                      Text(
                        '50%',
                        style: GoogleFonts.outfit(
                          color: AppColors.surface,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Completed',
                        style: GoogleFonts.outfit(
                          color: AppColors.surface,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
