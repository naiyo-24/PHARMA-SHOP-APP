import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class ContactBottomSheet extends StatelessWidget {
  const ContactBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ContactBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Need Help?', style: AppTextStyles.subHeader),
          const SizedBox(height: 8),
          Text(
            'Our support team is available 24/7 to assist you with any issues.',
            style: AppTextStyles.description,
          ),
          const SizedBox(height: 32),
          _buildContactOption(
            icon: Iconsax.call,
            title: 'Call Support',
            subtitle: '+91 123 456 7890',
            color: AppColors.info,
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            icon: Iconsax.message,
            title: 'WhatsApp Us',
            subtitle: 'Instant chat support',
            color: AppColors.online,
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            icon: Iconsax.sms,
            title: 'Email Support',
            subtitle: 'support@pharmaconnect.com',
            color: AppColors.primary,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
          const Spacer(),
          Icon(Iconsax.arrow_right_3, color: color, size: 20),
        ],
      ),
    );
  }
}
