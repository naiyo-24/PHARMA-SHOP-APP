import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 7;

  // Controllers
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _shopPhotoController = TextEditingController();
  final _shopPhoneController = TextEditingController();
  final _shopAltPhoneController = TextEditingController();
  final _shopEmailController = TextEditingController();
  final _shopPasswordController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _gstinController = TextEditingController();
  final _drugLicenseController = TextEditingController();
  final _panCardController = TextEditingController();
  final _bankPassbookController = TextEditingController();
  final _regCertController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(TextEditingController controller) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        controller.text = image.path;
      });
    }
  }

  Future<void> _pickFile(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        controller.text = result.files.single.path!;
      });
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _submit() {
    final user = User(
      shopName: _shopNameController.text,
      shopAddress: _shopAddressController.text,
      shopPhoto: _shopPhotoController.text,
      shopPhoneNo: _shopPhoneController.text,
      shopAlternativePhoneNo: _shopAltPhoneController.text,
      shopEmail: _shopEmailController.text,
      shopPassword: _shopPasswordController.text,
      whatsappNumber: _whatsappController.text,
      gstinNo: _gstinController.text,
      drugLicenseUpload: _drugLicenseController.text,
      panCardUpload: _panCardController.text,
      bankPassbookUpload: _bankPassbookController.text,
      registrationCertificateUpload: _regCertController.text,
    );

    ref.read(authProvider.notifier).signup(user).then((_) {
      final state = ref.read(authProvider);
      if (state.error == null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: AppColors.success,
          ),
        );
        // ignore: use_build_context_synchronously
        context.go('/login');
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${state.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: [
                  _buildSlide('Basic Info', 'Tell us about your shop', [
                    _buildTextField(
                      _shopNameController,
                      'Shop Name',
                      Iconsax.shop,
                    ),
                    _buildTextField(
                      _shopAddressController,
                      'Shop Address',
                      Iconsax.location,
                    ),
                  ]),
                  _buildSlide('Contact Info', 'How can customers reach you?', [
                    _buildPickerField(
                      _shopPhotoController,
                      'Shop Photo',
                      Iconsax.image,
                      isImage: true,
                    ),
                    _buildTextField(
                      _shopPhoneController,
                      'Phone Number',
                      Iconsax.call,
                    ),
                  ]),
                  _buildSlide('Digital Presence', 'Stay connected online', [
                    _buildTextField(
                      _shopAltPhoneController,
                      'Alt. Phone (Optional)',
                      Iconsax.call,
                    ),
                    _buildTextField(
                      _shopEmailController,
                      'Shop Email',
                      Iconsax.sms,
                    ),
                  ]),
                  _buildSlide('Security', 'Protect your account', [
                    _buildTextField(
                      _shopPasswordController,
                      'Password',
                      Iconsax.lock,
                      isPassword: true,
                    ),
                    _buildTextField(
                      _whatsappController,
                      'WhatsApp Number',
                      Iconsax.message,
                    ),
                  ]),
                  _buildSlide('Legal Details', 'Verification documents', [
                    _buildTextField(
                      _gstinController,
                      'GSTIN Number',
                      Iconsax.card_pos,
                    ),
                    _buildPickerField(
                      _drugLicenseController,
                      'Drug License',
                      Iconsax.document_upload,
                    ),
                  ]),
                  _buildSlide('Verification', 'Identity documents', [
                    _buildPickerField(
                      _panCardController,
                      'PAN Card',
                      Iconsax.document_upload,
                    ),
                    _buildPickerField(
                      _bankPassbookController,
                      'Bank Passbook',
                      Iconsax.document_upload,
                    ),
                  ]),
                  _buildSlide('Final Step', 'Almost there!', [
                    _buildPickerField(
                      _regCertController,
                      'Registration Cert',
                      Iconsax.document_upload,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Row(
        children: [
          IconButton(
            onPressed: _previousStep,
            icon: const Icon(Iconsax.arrow_left_2),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Account', style: AppTextStyles.subHeader),
              Text('Step-by-step registration', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: AppColors.divider,
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: AppTextStyles.caption,
              ),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).toInt()}%',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(String title, String subtitle, List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.header.copyWith(fontSize: 24)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.description),
          const SizedBox(height: 40),
          ...children.expand((w) => [w, const SizedBox(height: 20)]),
          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPickerField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isImage = false,
  }) {
    final hasFile = controller.text.isNotEmpty;
    return GestureDetector(
      onTap: () => isImage ? _pickImage(controller) : _pickFile(controller),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          border: Border.all(
            color: hasFile ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: hasFile ? AppColors.primary : AppColors.textTertiary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (hasFile)
                    Text(
                      controller.text.split('/').last,
                      style: AppTextStyles.description.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      'Tap to upload',
                      style: AppTextStyles.description.copyWith(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            if (hasFile)
              const Icon(
                Iconsax.tick_circle,
                color: AppColors.success,
                size: 20,
              )
            else
              const Icon(
                Iconsax.add_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Widget _buildFooter() {
    final authState = ref.watch(authProvider);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: authState.isLoading ? null : _nextStep,
          child: authState.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(_currentStep == _totalSteps - 1 ? 'Finish' : 'Continue'),
        ),
      ),
    );
  }
}
