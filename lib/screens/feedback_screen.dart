import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import '../models/feedback_model.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/mongodb_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  int _rating = 5;
  String _selectedCategory = 'Platform Experience';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Platform Experience',
    'Question Bank Quality',
    'Learning Handbooks',
    'Civic Awareness Ideas',
    'Bug or Technical Issue',
    'Other Citizen Suggestion',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isSubmitting = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;

    final feedback = FeedbackModel(
      id: const Uuid().v4(),
      userId: user?.uid ?? 'guest_citizen',
      userName: user?.fullName ?? 'Anonymous Citizen',
      userEmail: user?.email ?? 'citizen@example.com',
      rating: _rating,
      category: _selectedCategory,
      message: _messageController.text.trim(),
    );

    try {
      // 1. Submit to MongoDB Backend (saves entry & dispatches to jangyan.admin@gmail.com)
      await MongoDbService.submitFeedback(feedback.toMap());

      // 2. Save to Cloud Firestore if connected
      final fs = FirebaseService.firestore;
      if (fs != null) {
        try {
          await fs.collection('feedback').doc(feedback.id).set(feedback.toMap());
        } catch (_) {}
      }

      // 3. Prepare direct email link to jangyan.admin@gmail.com
      final emailUri = Uri(
        scheme: 'mailto',
        path: 'jangyan.admin@gmail.com',
        queryParameters: {
          'subject': '[JanGyan Feedback] $_rating/5 Stars - $_selectedCategory',
          'body': 'Citizen Name: ${feedback.userName}\n'
              'Email: ${feedback.userEmail}\n'
              'Rating: $_rating / 5 Stars\n'
              'Category: $_selectedCategory\n\n'
              'Citizen Experience & Feedback:\n${feedback.message}\n\n'
              '--\nSent from JanGyan WebApp',
        },
      );

      // Launch email client if supported
      try {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } catch (_) {}

      if (mounted) {
        setState(() => _isSubmitting = false);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: const [
                Icon(Icons.mark_email_read_rounded, color: AppColors.success, size: 28),
                SizedBox(width: 10),
                Text('Feedback Dispatched', style: TextStyle(fontSize: 18)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thank you for your rating ($_rating ★) and feedback!',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your response has been saved in the JanGyan database and sent directly to:\n\n'
                  '📧 jangyan.admin@gmail.com',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  launchUrl(emailUri, mode: LaunchMode.externalApplication);
                },
                child: const Text('Open Mail App'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Citizen Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Share Your Thoughts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Help us refine JanGyan for citizens across India.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Rating Stars
                      const Text(
                        'How was your learning experience?',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          return IconButton(
                            iconSize: 36,
                            icon: Icon(
                              star <= _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setState(() => _rating = star);
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      const Text(
                        'Topic Category:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            items: _categories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedCategory = val);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Feedback Input
                      const Text(
                        'Your Comments or Suggestions:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Tell us how we can make civic awareness clearer or which new topics to include...',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your feedback message';
                          }
                          if (val.trim().length < 10) {
                            return 'Please provide at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Submit Feedback to JanGyan'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
