import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../../services/api_url.dart';

class ProfileHeaderCard extends StatelessWidget {
  final User user;

  const ProfileHeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: AppCardStyles.primaryGradientCard.copyWith(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.shopName,
                            style: AppTextStyles.header.copyWith(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.verified, color: Colors.white, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.shopEmail,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withAlpha(200),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBadge(),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Decorative background elements
        Positioned(
          right: -20,
          top: -20,
          child: Icon(
            Iconsax.hospital,
            size: 100,
            color: Colors.white.withAlpha(20),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    ImageProvider? imageProvider;
    if (user.shopPhoto != null && user.shopPhoto!.isNotEmpty) {
      if (user.shopPhoto!.startsWith('/') || user.shopPhoto!.contains('cache')) {
        imageProvider = FileImage(File(user.shopPhoto!));
      } else {
        imageProvider = NetworkImage("${ApiUrl.baseUrl}/${user.shopPhoto!}");
      }
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.background,
          image: imageProvider != null
              ? DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageProvider == null
            ? const Icon(Iconsax.shop, color: AppColors.primary, size: 36)
            : null,
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.verify, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            'VERIFIED PARTNER',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
