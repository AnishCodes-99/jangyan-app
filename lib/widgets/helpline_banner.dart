import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class HelplineBanner extends StatelessWidget {
  const HelplineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.emergency_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 12),
                children: [
                  TextSpan(text: 'National Citizen Helplines: '),
                  TextSpan(
                    text: '112',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF67E8F9),
                    ),
                  ),
                  TextSpan(text: ' (All Emergencies)  |  '),
                  TextSpan(
                    text: '1930',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFDE047),
                    ),
                  ),
                  TextSpan(text: ' (Cyber Fraud)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
