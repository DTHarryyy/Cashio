import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/widgets/ct_button.dart';
import 'package:cashio/features/auth/presentation/sign_in_page.dart';
import 'package:cashio/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:cashio/features/auth/presentation/widgets/other_login_provider.dart';
import 'package:cashio/features/auth/provider/auth_provider.dart';
import 'package:cashio/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 15,
              children: [
                const SizedBox(height: 20),

                Column(
                  spacing: 8,
                  children: [
                    Text(
                      'Join and take control of your money',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                Text(
                  'Set up your account for seamless access to financial tools.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontSize: 14),
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  icon: Icons.person,
                  hint: 'Create Username',
                  controller: usernameController,
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  icon: Icons.email,
                  hint: 'Enter Email',
                  controller: emailController,
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Enter a valid email address';
                    }

                    return null;
                  },
                ),

                CustomTextField(
                  icon: Icons.lock,
                  hint: 'Create Password',
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  child: CtButton(
                    text: isLoading ? 'Creating Account...' : 'Create Account',
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() => isLoading = true);
                            final username = usernameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            try {
                              await ref
                                  .read(signUpProvider)
                                  .call(username, email, password);

                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } catch (e) {
                              AppSnackBar.error(context, "error: $e/");
                            } finally {
                              if (mounted) {
                                setState(() => isLoading = false);
                              }
                            }
                          },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.outfit(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                OtherLoginProvider(otherProviderLabel: 'or sign up with'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
