import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class ProfileOptionsCard extends StatelessWidget {
  const ProfileOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            'ACCOUNT SETTINGS',
            style: AppTextStyles.tagline.copyWith(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Container(
          decoration: AppCardStyles.sleekCard.copyWith(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            children: [
              _buildOption(
                icon: Iconsax.user_edit,
                title: 'Update Account',
                subtitle: 'Manage your shop details',
                color: AppColors.primary,
                onTap: () => context.push('/update-profile'),
              ),
              _buildOption(
                icon: Iconsax.notification,
                title: 'Notifications',
                subtitle: 'Alerts and updates',
                color: AppColors.purple,
                onTap: () {},
              ),
              _buildOption(
                icon: Iconsax.wallet_money,
                title: 'Payments & Earnings',
                subtitle: 'Track your revenue',
                color: AppColors.online,
                onTap: () {},
              ),
              _buildOption(
                icon: Iconsax.setting_2,
                title: 'Settings',
                subtitle: 'Privacy and preferences',
                color: AppColors.silver,
                onTap: () {},
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
          ),
          subtitle: Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(fontSize: 12),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: AppColors.divider.withAlpha(100)),
          ),
      ],
    );
  }
}
