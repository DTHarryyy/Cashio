import 'package:cashio/core/widgets/ct_button.dart';
import 'package:cashio/features/auth/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // TODO: Call signup API / Firebase auth here

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
      });
    }
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
              children: [
                const SizedBox(height: 40),

                Text(
                  'Create Account',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Create a new account to get started and enjoy our seamless access to features.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontSize: 13),
                ),

                const SizedBox(height: 30),

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

                const SizedBox(height: 15),

                CustomTextField(
                  icon: Icons.email,
                  hint: 'Enter Email',
                  controller: emailController,
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

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

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.outfit(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, '/login');
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

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: CtButton(
                    text: isLoading ? 'Creating Account...' : 'Create Account',
                    onPressed: isLoading ? null : _signUp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
