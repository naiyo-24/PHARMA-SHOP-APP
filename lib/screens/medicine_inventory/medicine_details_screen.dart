import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../models/medicine_inventory.dart';
import '../../providers/medicine_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../services/api_url.dart';

class MedicineDetailsScreen extends ConsumerStatefulWidget {
  final MedicineInventory inventoryItem;

  const MedicineDetailsScreen({super.key, required this.inventoryItem});

  @override
  ConsumerState<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends ConsumerState<MedicineDetailsScreen> {
  late TextEditingController _discountController;
  late String _stockStatus;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController(text: widget.inventoryItem.discountPercent.toString());
    _stockStatus = widget.inventoryItem.status == 'in stock' ? 'In Stock' : 'Out of Stock';
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _updateInventory() async {
    final shopId = ref.read(authProvider).user?.shopId;
    if (shopId == null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(medicineProvider.notifier).updateInventoryItem(
        shopId: shopId,
        inventoryId: widget.inventoryItem.inventoryMedicineId ?? '',
        discountPercent: double.tryParse(_discountController.text),
        status: _stockStatus,
      );
      setState(() {
        _isEditing = false;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inventory updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteInventory() async {
    final shopId = ref.read(authProvider).user?.shopId;
    if (shopId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to remove this item from your inventory?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await ref.read(medicineProvider.notifier).deleteInventoryItem(
          shopId: shopId,
          inventoryId: widget.inventoryItem.inventoryMedicineId ?? '',
        );
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item removed from inventory.')),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicine = widget.inventoryItem.medicine;
    if (medicine == null) return const Scaffold(body: Center(child: Text('Medicine data missing')));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Medicine Details',
        subtitle: 'Inventory Management',
        showDrawer: false,
        showBackButton: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: _isEditing ? Iconsax.close_square : Iconsax.edit,
            onTap: () => setState(() => _isEditing = !_isEditing),
          ),
          CustomAppBar.buildActionButton(
            icon: Iconsax.trash,
            onTap: _deleteInventory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Styled Header with Image
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Hero(
                        tag: 'inv_${widget.inventoryItem.inventoryMedicineId}',
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(20),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                            image: medicine.medicinePhoto != null
                                ? DecorationImage(
                                    image: NetworkImage("${ApiUrl.baseUrl}/${medicine.medicinePhoto}"),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: medicine.medicinePhoto == null
                              ? const Icon(Iconsax.health, color: AppColors.primary, size: 80)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        medicine.medicineName,
                        style: AppTextStyles.header.copyWith(fontSize: 26, letterSpacing: -1),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medicine.medicineCategory.toUpperCase(),
                        style: AppTextStyles.tagline.copyWith(fontSize: 12, color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Inventory & Pricing Section
                  _buildSectionTitle('Inventory & Pricing'),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppCardStyles.sleekCard,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildInfoChip(
                              icon: Iconsax.box,
                              label: 'STOCK STATUS',
                              value: _stockStatus,
                              color: _stockStatus == 'In Stock' ? AppColors.success : AppColors.error,
                            ),
                            const SizedBox(width: 16),
                            _buildInfoChip(
                              icon: Iconsax.discount_shape,
                              label: 'DISCOUNT',
                              value: '${_discountController.text}% OFF',
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildPriceRow('MRP (Inclusive of all taxes)', '₹${medicine.mrp.toStringAsFixed(2)}', isOld: true),
                        const SizedBox(height: 12),
                        _buildPriceRow('Your Discounted Price', '₹${widget.inventoryItem.displayPrice.toStringAsFixed(2)}', isBold: true, color: AppColors.primary),
                      ],
                    ),
                  ),

                  if (_isEditing) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle('Edit Details'),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppCardStyles.sleekCard.copyWith(border: Border.all(color: AppColors.primary.withAlpha(50))),
                      child: Column(
                        children: [
                          TextField(
                            controller: _discountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Discount Percentage',
                              prefixIcon: Icon(Iconsax.discount_shape, size: 20),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _stockStatus,
                            decoration: const InputDecoration(
                              labelText: 'Inventory Status',
                              prefixIcon: Icon(Iconsax.box, size: 20),
                            ),
                            items: ['In Stock', 'Out of Stock'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) => setState(() => _stockStatus = val!),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _updateInventory,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Inventory Changes'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                  _buildSectionTitle('Product Specifications'),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppCardStyles.sleekCard,
                    child: Column(
                      children: [
                        _buildDetailItem(Iconsax.box, 'Quantity', medicine.medicineQuantity),
                        _buildDivider(),
                        _buildDetailItem(Iconsax.health, 'Composition', medicine.medicineComposition ?? 'N/A'),
                        _buildDivider(),
                        _buildDetailItem(Iconsax.note_text, 'Description', medicine.medicineDescription ?? 'No description available.'),
                      ],
                    ),
                  ),
                  
                  if (medicine.precautions != null && medicine.precautions!.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildSectionTitle('Safety Information'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: AppCardStyles.sleekCard.copyWith(color: AppColors.error.withAlpha(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.warning_2, color: AppColors.error, size: 20),
                              const SizedBox(width: 8),
                              Text('PRECAUTIONS', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w800)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...medicine.precautions!.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6, right: 12),
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                ),
                                Expanded(child: Text(p, style: AppTextStyles.description.copyWith(fontSize: 14))),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title, style: AppTextStyles.subHeader.copyWith(fontSize: 18)),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required String value, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9, color: color, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 14, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isOld = false, bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.description.copyWith(fontSize: 13, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: isBold ? 20 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: color ?? AppColors.textPrimary,
            decoration: isOld ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.description.copyWith(fontSize: 15, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: AppColors.divider.withAlpha(100), thickness: 1),
    );
  }
}
