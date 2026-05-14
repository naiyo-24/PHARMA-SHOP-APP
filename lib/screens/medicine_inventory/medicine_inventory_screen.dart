import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import '../../providers/medicine_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../services/api_url.dart';
import '../../models/medicine_inventory.dart';

class MedicineInventoryScreen extends ConsumerStatefulWidget {
  const MedicineInventoryScreen({super.key});

  @override
  ConsumerState<MedicineInventoryScreen> createState() => _MedicineInventoryScreenState();
}

class _MedicineInventoryScreenState extends ConsumerState<MedicineInventoryScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final shopId = ref.read(authProvider).user?.shopId;
      if (shopId != null) {
        ref.read(medicineProvider.notifier).fetchInventory(shopId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: SideNavBar(
        selectedIndex: 2,
        onItemSelected: (index) {},
      ),
      appBar: CustomAppBar(
        title: 'Inventory',
        subtitle: 'Track your medicine stock',
        showDrawer: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: _isSearching ? Iconsax.close_square : Iconsax.search_normal,
            onTap: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(medicineProvider.notifier).searchInventory('');
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 8, AppSpacing.screenPadding, 16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: AppCardStyles.sleekCard.copyWith(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => ref.read(medicineProvider.notifier).searchInventory(val),
                  style: AppTextStyles.description.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search by medicine name...',
                    hintStyle: AppTextStyles.caption,
                    prefixIcon: const Icon(Iconsax.search_normal, color: AppColors.primary, size: 20),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          Expanded(
            child: state.isLoading && state.inventory.isEmpty
                ? _buildLoadingState()
                : state.error != null
                    ? _buildErrorState(state.error!)
                    : state.filteredInventory.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async {
                              final shopId = ref.read(authProvider).user?.shopId;
                              if (shopId != null) {
                                await ref.read(medicineProvider.notifier).fetchInventory(shopId);
                              }
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.filteredInventory.length,
                              itemBuilder: (context, index) {
                                final item = state.filteredInventory[index];
                                return _MedicineInventoryCard(item: item);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.danger, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(error, style: AppTextStyles.description.copyWith(color: AppColors.error)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final shopId = ref.read(authProvider).user?.shopId;
              if (shopId != null) ref.read(medicineProvider.notifier).fetchInventory(shopId);
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.box, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text('Inventory is empty', style: AppTextStyles.subHeader),
          const SizedBox(height: 8),
          Text(
            'Add medicines from the catalog to see them here.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MedicineInventoryCard extends StatelessWidget {
  final MedicineInventory item;

  const _MedicineInventoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final medicine = item.medicine;
    if (medicine == null) return const SizedBox.shrink();

    final bool inStock = item.status == 'in stock';

    return GestureDetector(
      onTap: () => context.push('/medicine-details', extra: item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: AppCardStyles.sleekCard.copyWith(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Medicine Photo
                Hero(
                  tag: 'inv_${item.inventoryMedicineId}',
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      image: medicine.medicinePhoto != null
                          ? DecorationImage(
                              image: NetworkImage("${ApiUrl.baseUrl}/${medicine.medicinePhoto}"),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: medicine.medicinePhoto == null
                        ? const Icon(Iconsax.health, color: AppColors.primary, size: 32)
                        : null,
                  ),
                ),
                
                // Info Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                medicine.medicineName,
                                style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStockBadge(inStock),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          medicine.medicineCategory,
                          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                        ),
                        const Spacer(),
                        const SizedBox(height: 12),
                        
                        // Price & Discount Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price',
                                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                                ),
                                Text(
                                  '₹${item.displayPrice.toStringAsFixed(2)}',
                                  style: AppTextStyles.cardTitle.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            if (item.discountPercent > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${item.discountPercent.toInt()}% OFF',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Right Accent
                Container(
                  width: 4,
                  color: inStock ? AppColors.primary : AppColors.error.withAlpha(150),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockBadge(bool inStock) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: inStock ? AppColors.success.withAlpha(20) : AppColors.error.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: inStock ? AppColors.success.withAlpha(50) : AppColors.error.withAlpha(50),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            inStock ? Icons.check_circle : Icons.error,
            size: 10,
            color: inStock ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 4),
          Text(
            inStock ? 'IN STOCK' : 'OUT OF STOCK',
            style: AppTextStyles.caption.copyWith(
              color: inStock ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w800,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
