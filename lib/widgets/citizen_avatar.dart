import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/user_profile.dart';

class CitizenAvatar extends StatelessWidget {
  final UserProfile? user;
  final String? photoUrl;
  final String? name;
  final double radius;
  final VoidCallback? onTap;
  final bool showEditBadge;

  const CitizenAvatar({
    super.key,
    this.user,
    this.photoUrl,
    this.name,
    this.radius = 24,
    this.onTap,
    this.showEditBadge = false,
  });

  static final Map<String, ({IconData icon, List<Color> gradient, String title})> presets = {
    'preset:champion': (
      icon: Icons.military_tech_rounded,
      gradient: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
      title: 'Civic Champion',
    ),
    'preset:digital': (
      icon: Icons.security_rounded,
      gradient: [Color(0xFF0F766E), Color(0xFF14B8A6)],
      title: 'Cyber Defender',
    ),
    'preset:health': (
      icon: Icons.health_and_safety_rounded,
      gradient: [Color(0xFF047857), Color(0xFF10B981)],
      title: 'Health Scout',
    ),
    'preset:scholar': (
      icon: Icons.school_rounded,
      gradient: [Color(0xFFB45309), Color(0xFFF59E0B)],
      title: 'Law Scholar',
    ),
    'preset:road': (
      icon: Icons.traffic_rounded,
      gradient: [Color(0xFFC2410C), Color(0xFFFB923C)],
      title: 'Road Ranger',
    ),
    'preset:eco': (
      icon: Icons.eco_rounded,
      gradient: [Color(0xFF15803D), Color(0xFF4ADE80)],
      title: 'Eco Sentinel',
    ),
    'preset:finance': (
      icon: Icons.account_balance_rounded,
      gradient: [Color(0xFF6B21A8), Color(0xFFA855F7)],
      title: 'Finance Master',
    ),
    'preset:ambassador': (
      icon: Icons.stars_rounded,
      gradient: [Color(0xFF9D174D), Color(0xFFF43F5E)],
      title: 'Youth Ambassador',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final effectivePhoto = photoUrl ?? user?.photoUrl;
    final effectiveName = name ?? user?.fullName ?? 'Citizen';
    final initial = effectiveName.trim().isNotEmpty
        ? effectiveName.trim()[0].toUpperCase()
        : 'C';

    Widget avatarContent;

    if (effectivePhoto != null && effectivePhoto.isNotEmpty) {
      if (effectivePhoto.startsWith('preset:') && presets.containsKey(effectivePhoto)) {
        final preset = presets[effectivePhoto]!;
        avatarContent = Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: preset.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            preset.icon,
            size: radius * 1.05,
            color: Colors.white,
          ),
        );
      } else if (effectivePhoto.startsWith('data:image/')) {
        try {
          final base64String = effectivePhoto.split(',').last;
          final bytes = base64Decode(base64String);
          avatarContent = ClipOval(
            child: Image.memory(
              bytes,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => _buildFallback(initial),
            ),
          );
        } catch (_) {
          avatarContent = _buildFallback(initial);
        }
      } else {
        avatarContent = ClipOval(
          child: Image.network(
            effectivePhoto,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => _buildFallback(initial),
          ),
        );
      }
    } else {
      avatarContent = _buildFallback(initial);
    }

    Widget rootWidget = SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: avatarContent,
    );

    if (showEditBadge) {
      rootWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          rootWidget,
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: rootWidget,
      );
    }

    return rootWidget;
  }

  Widget _buildFallback(String initial) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: AppColors.primaryTint,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.85,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
