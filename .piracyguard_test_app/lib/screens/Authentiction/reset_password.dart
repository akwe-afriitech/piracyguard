
import 'package:flutter/material.dart';
import 'package:piracyguard_test_app/services/auth_methods.dart';
import 'package:piracyguard_test_app/utils/colors.dart';
import 'package:piracyguard_test_app/widgets/custom_button.dart';
import 'package:piracyguard_test_app/widgets/custum_textField.dart';

class ResetPassword extends StatefulWidget {const ResetPassword({Key? key}) : super(key: key);

@override
State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetEmail() async {
    if (_emailController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email.')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    await _authMethods.sendPasswordResetEmail(context, _emailController.text.trim());
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password', style: TextStyle(color: Colors.white)),
        backgroundColor: pColor1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center( // Center the content
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Forgot Your Password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: pColor1,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 0, horizontal: size.width* 0.05),
                child: const Text(
                  'Enter your email address below',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                icon: Icons.email_outlined,
                controller: _emailController,
                hintText: 'Enter your email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: pColor1,))
                  : CustomButton(
                onPressed: _handleSendResetEmail,
                color: pColor1,
                textColor: Colors.white,
                text: 'Send Link',
                icon: Icons.send,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}