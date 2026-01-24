import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class TransactionsEmptyState extends StatelessWidget {
  const TransactionsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 2 / 1.3,

            child: Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/lottiefiles/No transaction.json',
                width: double.infinity,

                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'No transactions yet!',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your income and expense records will appear here once you start adding transactions.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: const Color.fromARGB(255, 104, 105, 105),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
