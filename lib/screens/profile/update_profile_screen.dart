import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/user.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  bool _isEditing = false;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _whatsappController;
  late TextEditingController _gstinController;
  late TextEditingController _drugLicenseController;
  late TextEditingController _panCardController;
  late TextEditingController _bankPassbookController;
  late TextEditingController _regCertController;
  late TextEditingController _shopPhotoController;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(TextEditingController controller) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() => controller.text = image.path);
    }
  }

  Future<void> _pickFile(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    if (result != null) {
      setState(() => controller.text = result.files.single.path!);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.shopName);
    _addressController = TextEditingController(text: user?.shopAddress);
    _phoneController = TextEditingController(text: user?.shopPhoneNo);
    _altPhoneController = TextEditingController(
      text: user?.shopAlternativePhoneNo,
    );
    _emailController = TextEditingController(text: user?.shopEmail);
    _passwordController = TextEditingController(text: user?.shopPassword);
    _whatsappController = TextEditingController(text: user?.whatsappNumber);
    _gstinController = TextEditingController(text: user?.gstinNo);
    _drugLicenseController = TextEditingController(
      text: user?.drugLicenseUpload,
    );
    _panCardController = TextEditingController(text: user?.panCardUpload);
    _bankPassbookController = TextEditingController(
      text: user?.bankPassbookUpload,
    );
    _regCertController = TextEditingController(
      text: user?.registrationCertificateUpload,
    );
    _shopPhotoController = TextEditingController(text: user?.shopPhoto);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _whatsappController.dispose();
    _gstinController.dispose();
    _drugLicenseController.dispose();
    _panCardController.dispose();
    _bankPassbookController.dispose();
    _regCertController.dispose();
    _shopPhotoController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedUser = User(
      shopName: _nameController.text,
      shopAddress: _addressController.text,
      shopPhoneNo: _phoneController.text,
      shopAlternativePhoneNo: _altPhoneController.text,
      shopEmail: _emailController.text,
      shopPassword: _passwordController.text,
      whatsappNumber: _whatsappController.text,
      gstinNo: _gstinController.text,
      shopPhoto: _shopPhotoController.text,
      drugLicenseUpload: _drugLicenseController.text,
      panCardUpload: _panCardController.text,
      bankPassbookUpload: _bankPassbookController.text,
      registrationCertificateUpload: _regCertController.text,
    );

    ref.read(profileProvider.notifier).updateProfile(updatedUser);
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        subtitle: 'Shop details & documents',
        showBackButton: true,
        actions: [
          CustomAppBar.buildActionButton(
            icon: _isEditing ? Iconsax.tick_circle : Iconsax.edit_2,
            iconColor: _isEditing ? AppColors.success : AppColors.primary,
            onTap: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isEditing) _buildModernBanner(),
            const SizedBox(height: 16),
            _buildModernSection('GENERAL INFORMATION', [
              _buildModernEditableField(
                'Shop Name',
                _nameController,
                Iconsax.shop,
              ),
              _buildModernEditableField(
                'Shop Address',
                _addressController,
                Iconsax.location,
              ),
              _buildModernEditableField(
                'Phone Number',
                _phoneController,
                Iconsax.call,
              ),
              _buildModernEditableField(
                'Alt. Phone',
                _altPhoneController,
                Iconsax.call,
              ),
            ]),
            const SizedBox(height: 24),
            _buildModernSection('ACCOUNT & SECURITY', [
              _buildModernEditableField(
                'Shop Email',
                _emailController,
                Iconsax.sms,
              ),
              _buildModernEditableField(
                'Password',
                _passwordController,
                Iconsax.lock,
                isPassword: true,
              ),
            ]),
            const SizedBox(height: 24),
            _buildModernSection('BUSINESS DETAILS', [
              _buildModernEditableField(
                'WhatsApp Number',
                _whatsappController,
                Iconsax.message,
              ),
              _buildModernEditableField(
                'GSTIN No.',
                _gstinController,
                Iconsax.card_pos,
              ),
            ]),
            const SizedBox(height: 24),
            _buildModernSection('VERIFICATION DOCUMENTS', [
              _buildModernPickerField(
                'Shop Photo',
                _shopPhotoController,
                Iconsax.image,
                isImage: true,
              ),
              _buildModernPickerField(
                'Drug License',
                _drugLicenseController,
                Iconsax.document_upload,
              ),
              _buildModernPickerField(
                'PAN Card',
                _panCardController,
                Iconsax.document_upload,
              ),
              _buildModernPickerField(
                'Bank Passbook',
                _bankPassbookController,
                Iconsax.document_upload,
              ),
              _buildModernPickerField(
                'Registration Cert',
                _regCertController,
                Iconsax.document_upload,
              ),
            ]),
            const SizedBox(height: 40),
            if (_isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'SAVE UPDATES',
                    style: TextStyle(letterSpacing: 1.5),
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModernBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: AppCardStyles.primaryGradientCard.copyWith(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.info_circle, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep your info updated',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Click the edit icon to modify details',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.tagline.copyWith(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Container(
          decoration: AppCardStyles.sleekCard.copyWith(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildModernEditableField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withAlpha(50), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary.withAlpha(150), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                  ),
                ),
                TextField(
                  controller: controller,
                  enabled: _isEditing,
                  obscureText: isPassword,
                  style: AppTextStyles.description.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: _isEditing
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernPickerField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isImage = false,
  }) {
    final hasFile = controller.text.isNotEmpty;
    return InkWell(
      onTap: _isEditing
          ? () => isImage ? _pickImage(controller) : _pickFile(controller)
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.divider.withAlpha(50),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: hasFile ? AppColors.primary : AppColors.textTertiary,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    hasFile ? controller.text.split('/').last : 'NOT UPLOADED',
                    style: AppTextStyles.description.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: hasFile
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (_isEditing)
              Icon(
                hasFile ? Iconsax.tick_circle : Iconsax.add_circle,
                color: hasFile ? AppColors.success : AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
