import 'dart:convert';

class User {
  final String? shopId;
  final String shopName;
  final String shopAddress;
  final String? shopPhoto;
  final String shopPhoneNo;
  final String? shopAlternativePhoneNo;
  final String shopEmail;
  final String shopPassword;
  final String? whatsappNumber;
  final String? gstinNo;
  final String drugLicenseUpload;
  final String panCardUpload;
  final String bankPassbookUpload;
  final String registrationCertificateUpload;
  final String? status;

  User({
    this.shopId,
    required this.shopName,
    required this.shopAddress,
    this.shopPhoto,
    required this.shopPhoneNo,
    this.shopAlternativePhoneNo,
    required this.shopEmail,
    required this.shopPassword,
    this.whatsappNumber,
    this.gstinNo,
    required this.drugLicenseUpload,
    required this.panCardUpload,
    required this.bankPassbookUpload,
    required this.registrationCertificateUpload,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'shop_id': shopId,
      'shop_name': shopName,
      'shop_address': shopAddress,
      'shop_photo': shopPhoto,
      'shop_phone_no': shopPhoneNo,
      'shop_alternative_phone_no': shopAlternativePhoneNo,
      'shop_email': shopEmail,
      'shop_password': shopPassword,
      'whatsapp_number': whatsappNumber,
      'gstin_no': gstinNo,
      'drug_license_upload': drugLicenseUpload,
      'pan_card_upload': panCardUpload,
      'bank_passbook_upload': bankPassbookUpload,
      'registration_certificate_upload': registrationCertificateUpload,
      'status': status,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      shopId: map['shop_id'],
      shopName: map['shop_name'] ?? '',
      shopAddress: map['shop_address'] ?? '',
      shopPhoto: map['shop_photo'],
      shopPhoneNo: map['shop_phone_no'] ?? '',
      shopAlternativePhoneNo: map['shop_alternative_phone_no'],
      shopEmail: map['shop_email'] ?? '',
      shopPassword: map['shop_password'] ?? '',
      whatsappNumber: map['whatsapp_number'],
      gstinNo: map['gstin_no'],
      drugLicenseUpload: map['drug_license_upload'] ?? '',
      panCardUpload: map['pan_card_upload'] ?? '',
      bankPassbookUpload: map['bank_passbook_upload'] ?? '',
      registrationCertificateUpload: map['registration_certificate_upload'] ?? '',
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
