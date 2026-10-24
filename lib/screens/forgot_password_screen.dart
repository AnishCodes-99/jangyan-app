import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _sentSuccess = false;
  int _resendCooldown = 0;
  Timer? _countdownTimer;
  bool _showDirectReset = false;
  bool _obscureNewPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown([int seconds = 30]) {
    _countdownTimer?.cancel();
    setState(() {
      _resendCooldown = seconds;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendCooldown > 1) {
          _resendCooldown--;
        } else {
          _resendCooldown = 0;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final auth = Provider.of<AuthService>(context, listen: false);
    final success = await auth.sendPasswordReset(email);

    if (success && mounted) {
      setState(() {
        _sentSuccess = true;
      });
      _startCountdown(30);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Password reset link sent to $email'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted && auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleResend() async {
    if (_resendCooldown > 0) return;
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final auth = Provider.of<AuthService>(context, listen: false);
    final success = await auth.sendPasswordReset(email);

    if (success && mounted) {
      _startCountdown(30);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Reset instructions resent to $email. Please check your inbox and spam folder.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted && auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleDirectReset() async {
    final email = _emailController.text.trim();
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters long'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    final success = await auth.resetPasswordDirectly(
      email: email,
      newPassword: newPass,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Password successfully updated! Please log in with your new password.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
      Navigator.pop(context);
    } else if (mounted && auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: _sentSuccess
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: AppColors.successLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          color: AppColors.success,
                          size: 46,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Reset Instructions Dispatched',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTint.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _emailController.text.trim(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'An official password reset email has been sent. Please open the link in your email to choose a new password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, size: 20, color: Colors.amber),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Tip: If you do not see the email in your primary inbox, please check your Spam or Junk folder.',
                              style: TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Resend Email Button with Timer
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: _resendCooldown > 0 ? Colors.grey.shade300 : AppColors.primary,
                        ),
                      ),
                      onPressed: (_resendCooldown > 0 || auth.isLoading) ? null : _handleResend,
                      icon: auth.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              Icons.refresh,
                              color: _resendCooldown > 0 ? Colors.grey : AppColors.primary,
                            ),
                      label: Text(
                        _resendCooldown > 0
                            ? 'Resend Email in ${_resendCooldown}s'
                            : 'Resend Reset Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _resendCooldown > 0 ? Colors.grey : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Change Email Option
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _sentSuccess = false;
                        });
                      },
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Use a different email address'),
                    ),
                    const SizedBox(height: 16),

                    // Expandable In-App Direct Reset Fallback
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.security, size: 20, color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Reset Password In-App',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showDirectReset = !_showDirectReset;
                                    });
                                  },
                                  child: Text(_showDirectReset ? 'Hide' : 'Set Now'),
                                ),
                              ],
                            ),
                            if (_showDirectReset) ...[
                              const Divider(),
                              const SizedBox(height: 8),
                              const Text(
                                'You can update your password directly below without waiting for an email:',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _newPasswordController,
                                obscureText: _obscureNewPassword,
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureNewPassword = !_obscureNewPassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureNewPassword,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm New Password',
                                  prefixIcon: Icon(Icons.lock_reset, size: 20),
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                onPressed: auth.isLoading ? null : _handleDirectReset,
                                child: auth.isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text('Update Password Now'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Back to Login
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to Login'),
                    ),
                  ],
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Forgot Your Password?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Enter your registered email address and we will send you instant instructions to reset your account password.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleReset(),
                        decoration: const InputDecoration(
                          labelText: 'Registered Email',
                          hintText: 'name@example.com',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!val.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: auth.isLoading ? null : _handleReset,
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Send Reset Instructions'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
