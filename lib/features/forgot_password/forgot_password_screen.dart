import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elesafe_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!mounted) return;

    final email = _emailController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (email.isEmpty || currentPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    EasyLoading.show(status: 'Resetting password...');

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user_credential')
          .where('Email', isEqualTo: email)
          .where('Password', isEqualTo: currentPassword)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        EasyLoading.dismiss();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or current password')),
          );
        }
        return;
      }

      final docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection('user_credential').doc(docId).update({
        'Password': newPassword,
      });

      EasyLoading.dismiss();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful! Please sign in.')),
        );
        context.go(AppRouter.loginPath);
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Color(0xFF11346a)),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400, color: Colors.white, letterSpacing: 2),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: TextField(
                        controller: _currentPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Current Password',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          backgroundColor: const Color(0xFF386cc0),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remembered your password?",
                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRouter.loginPath),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
