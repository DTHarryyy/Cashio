import 'package:cashio/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtherLoginProvider extends StatefulWidget {
  final String otherProviderLabel;
  const OtherLoginProvider({super.key, required this.otherProviderLabel});

  @override
  State<OtherLoginProvider> createState() => _OtherLoginProviderState();
}

class _OtherLoginProviderState extends State<OtherLoginProvider> {
  // TODO: Implement signUp method with clean arrchiotecture and fix google auth with supabase
  Future<void> continueWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      debugPrint('Google sign-in failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container(height: 1, color: AppColors.border)),
            Text(
              widget.otherProviderLabel,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.border)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/facebook.svg',
                width: 45,
                height: 45,
              ),
            ),
            IconButton(
              onPressed: continueWithGoogle,
              icon: SvgPicture.asset(
                'assets/icons/google.svg',
                width: 45,
                height: 45,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
