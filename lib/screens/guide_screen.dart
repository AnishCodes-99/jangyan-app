import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  Future<void> _makeCall(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('App User Guide'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'OFFICIAL USER MANUAL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Welcome to JanGyan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your complete guide to reading 66 verified PDF handbooks, taking full 500-MCQ exams, using Gemini AI assistance, and earning citizen literacy certificates.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Step 1: Study Handbooks
            _buildStepCard(
              stepNumber: '1',
              title: 'Study 66 Verified Official Handbooks (PDFs)',
              icon: Icons.menu_book_rounded,
              iconBg: const Color(0xFFEFF6FF),
              iconColor: AppColors.primary,
              content: [
                'Go to the **Domains** tab at the bottom to explore the 6 national citizen pillars (Cyber Safety, Citizen Rights, Road Safety, Health & Emergency, Digital Finance, Environment).',
                'Select any domain to view its 10 curated modules.',
                'Tap **"Read Handbook (PDF)"** on any module to view official government handbooks (MHA, MeitY, MoRTH, MoHFW).',
                'On Web: Handbooks open smoothly in our document reader with a 1-click button to open full-screen in a new tab. On Android: Handbooks open in native pinch-to-zoom PDF viewer.',
              ],
            ),
            const SizedBox(height: 14),

            // Step 2: Assessment Modes
            _buildStepCard(
              stepNumber: '2',
              title: 'Choose Your Assessment Mode (20, 50, or Full 500 MCQs!)',
              icon: Icons.assignment_turned_in_rounded,
              iconBg: const Color(0xFFF0FDF4),
              iconColor: AppColors.success,
              content: [
                '**Quick Practice (20 MCQs)**: A brisk 15-minute test for daily revision and knowledge check.',
                '**Standard Assessment (50 MCQs)**: A 35-minute certified benchmark with official explanations.',
                '**Complete Category Examination (All 500 MCQs!)**: The ultimate mastery test covering all 500 verified questions in a domain! Ideal for competitive exams, civic tests, and deep mastery.',
              ],
            ),
            const SizedBox(height: 14),

            // Step 3: Question Palette & Review Navigator
            _buildStepCard(
              stepNumber: '3',
              title: 'Mastering the 500-Question Exam Screen',
              icon: Icons.grid_view_rounded,
              iconBg: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFD97706),
              content: [
                '**Question Palette**: Tap the grid icon in the top AppBar or bottom toolbar anytime to see the 1–500 question palette.',
                '**Filter Views**: Toggle between "All (500)", "Answered", "Marked for Review", and "Unattempted".',
                '**Mark for Review**: Tap the bookmark icon on tricky questions to flag them in amber so you can review before submitting.',
                '**Instant Explanations**: Learn why an answer is correct with official JanGyan legal citations and government circular references.',
              ],
            ),
            const SizedBox(height: 14),

            // Step 4: AI Assistant
            _buildStepCard(
              stepNumber: '4',
              title: 'Ask JanGyan AI Assistant (Gemini Flash)',
              icon: Icons.smart_toy_rounded,
              iconBg: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFF7C3AED),
              content: [
                'Navigate to the **AI Guide** tab.',
                'Ask questions in English or Hindi (e.g. *"What should I do if I sent money to the wrong UPI ID?"* or *"FIR kaise file karein?"*).',
                'JanGyan AI analyzes your query against Indian statutes (IT Act 2000, Consumer Protection Act 2019, Motor Vehicles Act) and provides instant actionable steps and helpline guidance.',
              ],
            ),
            const SizedBox(height: 14),

            // Step 5: Certificates
            _buildStepCard(
              stepNumber: '5',
              title: 'Earn Your Verified Certificate of Civic Literacy',
              icon: Icons.workspace_premium_rounded,
              iconBg: const Color(0xFFFEF2F2),
              iconColor: AppColors.error,
              content: [
                'Score 70% or higher in any assessment to earn an accredited JanGyan Citizen Certificate.',
                'Certificates feature your name, accuracy percentage, domain accreditation, and unique verification ID.',
                'Print or save your certificate as high-resolution PDF directly from the results screen.',
              ],
            ),
            const SizedBox(height: 20),

            // Emergency Helplines Direct Dial Box
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.phone_in_talk, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(
                          'National Emergency Quick-Dial',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Toll-free numbers verified by Government of India:',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildHelplineChip('1930', 'Cyber Fraud', () => _makeCall('1930')),
                        _buildHelplineChip('112', 'National Emergency', () => _makeCall('112')),
                        _buildHelplineChip('1098', 'Child Helpline', () => _makeCall('1098')),
                        _buildHelplineChip('1091', 'Women Helpline', () => _makeCall('1091')),
                        _buildHelplineChip('14444', 'UPI / Payments', () => _makeCall('14444')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required List<String> content,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Step $stepNumber: $title',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...content.map(
              (paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5, right: 8),
                      child: Icon(Icons.circle, size: 5, color: AppColors.primary),
                    ),
                    Expanded(
                      child: Text(
                        paragraph.replaceAll('**', ''),
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelplineChip(String number, String label, VoidCallback onTap) {
    return ActionChip(
      avatar: const Icon(Icons.phone, size: 14, color: AppColors.error),
      label: Text('$number ($label)'),
      labelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.border),
      onPressed: onTap,
    );
  }
}
