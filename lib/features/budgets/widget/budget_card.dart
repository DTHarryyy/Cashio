import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 138, 245, 142).withAlpha(60),
                ),
                child: Icon(
                  Icons.airplanemode_active,
                  color: const Color.fromARGB(255, 138, 245, 142),
                ),
              ),
              Expanded(
                child: Text('Vacation to Hawaii', style: GoogleFonts.outfit()),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert_outlined),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  '₱28,000',
                  style: GoogleFonts.outfit(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text('12/27/2025', style: GoogleFonts.outfit()),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Remaining from 30,000',
                  style: GoogleFonts.outfit(color: AppColors.textSecondary),
                ),
              ),
              Text(
                'creataed on',
                style: GoogleFonts.outfit(color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Text('Amount spent', style: GoogleFonts.outfit()),
              ),
              Text('utilization', style: GoogleFonts.outfit()),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text('₱2,000', style: GoogleFonts.outfit())),
              Text('6.67%', style: GoogleFonts.outfit()),
            ],
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: .067,
            backgroundColor: AppColors.background,
            minHeight: 10,
            borderRadius: BorderRadius.circular(30),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
          ),
        ],
      ),
    );
  }
}
