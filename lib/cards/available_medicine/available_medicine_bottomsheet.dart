import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/available_medicine.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';
import 'available_medicine_preview_card.dart';

class AvailableMedicineBottomSheet extends StatelessWidget {
  final AvailableMedicine medicine;

  const AvailableMedicineBottomSheet({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header Row with Image
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (medicine.medicinePhoto != null &&
                          medicine.medicinePhoto!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvailableMedicinePreviewCard(
                              imageUrl: medicine.medicinePhoto!,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.divider),
                        image: medicine.medicinePhoto != null &&
                                medicine.medicinePhoto!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(
                                  "${ApiUrl.baseUrl}/${medicine.medicinePhoto}",
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: medicine.medicinePhoto == null ||
                              medicine.medicinePhoto!.isEmpty
                          ? const Icon(
                              Iconsax.health,
                              color: AppColors.primary,
                              size: 40,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.medicineName,
                          style: AppTextStyles.header.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            medicine.medicineCategory,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '₹${medicine.mrp.toStringAsFixed(2)}',
                          style: AppTextStyles.header.copyWith(
                            color: AppColors.primary,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 16),

              // Details
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        Iconsax.box,
                        'Quantity',
                        medicine.medicineQuantity,
                      ),
                      if (medicine.medicineComposition != null &&
                          medicine.medicineComposition!.isNotEmpty)
                        _buildDetailRow(
                          Iconsax.health,
                          'Composition',
                          medicine.medicineComposition!,
                        ),
                      if (medicine.medicineDescription != null &&
                          medicine.medicineDescription!.isNotEmpty)
                        _buildDetailRow(
                          Iconsax.note_text,
                          'Description',
                          medicine.medicineDescription!,
                        ),
                      if (medicine.precautions != null &&
                          medicine.precautions!.isNotEmpty)
                        _buildPrecautions(medicine.precautions!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Premium Add Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(80),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to add to inventory
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Iconsax.add_square, color: Colors.white, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        'Add to My Inventory',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.description.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecautions(List<String> precautions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.warning_2, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Precautions',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                ...precautions.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        Expanded(
                          child: Text(
                            p,
                            style: AppTextStyles.description.copyWith(
                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
