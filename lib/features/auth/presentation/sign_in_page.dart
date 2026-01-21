import 'package:cashio/core/utils/snackbar.dart';
import 'package:cashio/core/widgets/ct_button.dart';
import 'package:cashio/features/auth/presentation/sign_up_page.dart';
import 'package:cashio/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:cashio/features/auth/presentation/widgets/other_login_provider.dart';
import 'package:cashio/features/auth/provider/auth_provider.dart';
import 'package:cashio/features/dashboard/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignInPage> {
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

                // header
                Column(
                  spacing: 8,
                  children: [
                    Text(
                      'Welcome back! Let’s track your spending',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Access your account and stay in control of your money.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

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
                  hint: 'Enter Password',
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  child: CtButton(
                    text: isLoading ? 'Signing In...' : 'Sign in',
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);

                              try {
                                await ref
                                    .read(signInProvider)
                                    .call(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              } catch (e) {
                                AppSnackBar.error(context, 'Error: $e/');
                              }
                            }
                            setState(() => isLoading = false);
                          },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.outfit(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
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
                OtherLoginProvider(otherProviderLabel: 'or sign in with'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
