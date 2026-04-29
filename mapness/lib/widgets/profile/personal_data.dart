import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/entities/profile/user_profile_data.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/profile/profile_account_service.dart';

class PersonalData extends ConsumerStatefulWidget {
  final SsoUserInfo userInfo;

  const PersonalData({required this.userInfo, super.key});

  @override
  ConsumerState<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends ConsumerState<PersonalData> {
  static const int _nameMaxLength = 100;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  final _service = ProfileAccountService();

  bool _isLoading = false;
  bool _otpPending = false;
  String? _sessionId;
  String? _errorText;
  bool _isEmailVerified = false;
  int _resendAttemptsLeft = 3;
  int _otpFailureCount = 0;
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _selectedGender;
  DateTime? _selectedDob;
  String _activeEmail = '';
  String? _pendingEmail;
  String _initialFirstName = '';
  String _initialLastName = '';
  String _initialDob = '';
  String? _initialGender;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() {
    final userInfo = widget.userInfo;
    final language = ref.read(appLanguageProvider);

    _firstNameController.text = userInfo.getLocalizedFirstName(language);
    _lastNameController.text = userInfo.getLocalizedLastName(language);
    _activeEmail = userInfo.mail?.trim() ?? '';
    _emailController.text = _activeEmail;
    _isEmailVerified = userInfo.isEmailVerified;
    _selectedGender = _parseGender(userInfo.sex);
    _selectedDob = _parseDob(userInfo.dob);
    _pendingEmail = null;
    _initialFirstName = _firstNameController.text.trim();
    _initialLastName = _lastNameController.text.trim();
    _initialDob = userInfo.dob?.trim() ?? '';
    _initialGender = _selectedGender;
    _otpFailureCount = 0;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isSsoLocked => widget.userInfo.isSSOLocked;
  bool get _isEmailEditable => widget.userInfo.isEmailEditable;
  bool get _canEditProfile => !_isSsoLocked;
  bool get _canEditEmail => _isEmailEditable && !_isSsoLocked;

  String? _parseGender(String? rawGender) {
    if (rawGender == null || rawGender.isEmpty) return null;
    final normalized = rawGender.trim().toLowerCase();
    if (normalized == '1' || normalized == 'm' || normalized == 'male') return 'M';
    if (normalized == '2' || normalized == 'f' || normalized == 'female') return 'F';
    return null;
  }

  DateTime? _parseDob(String? rawDob) {
    if (rawDob == null || rawDob.trim().isEmpty) return null;
    final chunks = rawDob.trim().split('/');
    if (chunks.length != 3) return null;
    final day = int.tryParse(chunks[0]);
    final month = int.tryParse(chunks[1]);
    final year = int.tryParse(chunks[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime.tryParse('$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}');
  }

  String _formatDob(DateTime? dob) {
    if (dob == null) return 'account_dob_placeholder'.tr();
    final dd = dob.day.toString().padLeft(2, '0');
    final mm = dob.month.toString().padLeft(2, '0');
    final yyyy = dob.year.toString();
    return '$dd/$mm/$yyyy';
  }

  bool _validateForm() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    setState(() {
      _firstNameError = null;
      _lastNameError = null;
      _emailError = null;
      _errorText = null;
    });

    var isValid = true;

    if (firstName.isNotEmpty && firstName.length > _nameMaxLength) {
      _firstNameError = 'account_error_name_max'.tr();
      isValid = false;
    }

    if (lastName.isNotEmpty && lastName.length > _nameMaxLength) {
      _lastNameError = 'account_error_name_max'.tr();
      isValid = false;
    }

    if (email.isNotEmpty && !_isValidEmail(email)) {
      _emailError = 'account_error_email_format'.tr();
      isValid = false;
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(email);
  }

  Future<void> _save() async {
    if (!_validateForm()) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final nextDob = _formatDob(_selectedDob) == 'account_dob_placeholder'.tr() ? '' : _formatDob(_selectedDob);
    final nextGender = _selectedGender;
    final newEmail = _emailController.text.trim();
    final emailChanged = newEmail != _activeEmail;

    // ✅ إرسال جميع البيانات، وليس فقط التي تغيرت
    final allProfileData = <String, dynamic>{
      'firstname': firstName,
      'lastname': lastName,
      'dob': nextDob,
      'gender': nextGender == 'M' ? '1' : nextGender == 'F' ? '2' : '',
    };

    // ✅ تأكد من إرسال الإيميل إذا كان متاحاً للتعديل
    if (_canEditEmail && newEmail.isNotEmpty) {
      allProfileData['email'] = newEmail;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      // ✅ إرسال جميع البيانات إلى الـ API
      await _service.updateUserProfile(changes: allProfileData);

      // تحديث القيم المحفوظة
      _initialFirstName = firstName;
      _initialLastName = lastName;
      _initialDob = nextDob;
      _initialGender = nextGender;
      _activeEmail = newEmail;
      _emailController.text = newEmail;

      // ✅ إذا تغير الإيميل، نبدأ عملية التحقق
      if (emailChanged && newEmail.isNotEmpty && _canEditEmail) {
        final sessionId = await _service.sendVerificationEmail(newEmail);
        setState(() {
          _sessionId = sessionId;
          _otpPending = true;
          _pendingEmail = newEmail;
          _isEmailVerified = false;
          _errorText = null;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('account_save_success'.tr())),
          );
        }

        // ✅ Show OTP Bottom Sheet
        _showOtpBottomSheet();
      } else {
        await _refreshUserInfo();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('account_save_success'.tr())),
          );
        }
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      setState(() => _errorText = 'account_error_save_failed'.tr());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  /// ✅ Show OTP Bottom Sheet
  void _showOtpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OtpBottomSheetWidget(
        pendingEmail: _pendingEmail!,
        onVerify: _verifyOtp,
        onResend: _resendOtp,
        onCancel: _cancelOtpVerification,
        isLoading: _isLoading,
        failureCount: _otpFailureCount,
        resendAttemptsLeft: _resendAttemptsLeft,
      ),
    ).then((_) {
      // إذا تم إغلاق الـ bottom sheet بدون تحقق
      if (_otpPending && mounted) {
        _cancelOtpVerification();
      }
    });
  }

  Future<void> _verifyOtp(String otp) async {
    if (_sessionId == null) {
      setState(() => _errorText = 'account_error_session_expired'.tr());
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final ok = await _service.verifyEmail(
        sessionId: _sessionId!,
        otp: otp,
      );

      if (ok) {
        setState(() {
          _otpPending = false;
          _isEmailVerified = true;
          _activeEmail = _pendingEmail ?? _activeEmail;
          _emailController.text = _activeEmail;
          _pendingEmail = null;
          _sessionId = null;
          _otpFailureCount = 0;
          _isLoading = false;
        });

        await _refreshUserInfo();

        if (mounted) {
          Navigator.of(context).pop(); // Close bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('account_email_verified_success'.tr())),
          );
        }
      } else {
        setState(() => _otpFailureCount++);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('account_error_invalid_otp'.tr())),
          );
        }
        setState(() => _isLoading = false);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        setState(() => _errorText = 'account_error_otp_expired_or_invalid'.tr());
      } else {
        setState(() => _errorText = e.message ?? 'account_error_verify_otp_failed'.tr());
      }
      setState(() => _otpFailureCount++);
      setState(() => _isLoading = false);
    } catch (_) {
      setState(() {
        _errorText = 'account_error_verify_otp_failed'.tr();
        _otpFailureCount++;
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    if (_sessionId == null) {
      setState(() => _errorText = 'account_error_session_expired'.tr());
      return;
    }

    if (_resendAttemptsLeft <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('account_error_no_resend_attempts'.tr())),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await _service.resendEmailOtp(_sessionId!);
      setState(() {
        _resendAttemptsLeft--;
        _errorText = null;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('account_otp_resent_success'.tr())),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('account_error_wait_before_resend'.tr())),
        );
      } else if (e.response?.statusCode == 429) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('account_error_too_many_requests'.tr())),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'account_error_resend_failed'.tr())),
        );
      }
      setState(() => _isLoading = false);
    } catch (_) {
      setState(() {
        _errorText = 'account_error_resend_failed'.tr();
        _isLoading = false;
      });
    }
  }

  void _cancelOtpVerification() {
    setState(() {
      _otpPending = false;
      _pendingEmail = null;
      _sessionId = null;
      _otpFailureCount = 0;
      _emailController.text = _activeEmail;
      _isEmailVerified = widget.userInfo.isEmailVerified;
    });
    _loadUserData();
  }

  Future<void> _refreshUserInfo() async {
    try {
      await ref.read(authProvider.notifier).forceUpdate();
    } catch (e) {
      if (kDebugMode) print('Failed to refresh user info: $e');
    }
  }

  void _handleDioError(DioException e) {
    if (e.response?.statusCode == 409) {
      setState(() => _errorText = 'account_error_wait_before_resend'.tr());
    } else if (e.response?.statusCode == 429) {
      setState(() => _errorText = 'account_error_too_many_requests'.tr());
    } else {
      setState(() => _errorText = e.message ?? 'account_error_save_failed'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.read(appLanguageProvider);
    final userInfo = widget.userInfo;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text('profile'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
              ],
            ),
          ),
          ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: [
              _buildEditableField(
                controller: _firstNameController,
                label: 'account_first_name'.tr(),
                hintText: 'account_first_name_hint'.tr(),
                isEnabled: _canEditProfile,
                errorText: _firstNameError,
                maxLength: _nameMaxLength,
              ),

              _buildEditableField(
                controller: _lastNameController,
                label: 'account_last_name'.tr(),
                hintText: 'account_last_name_hint'.tr(),
                isEnabled: _canEditProfile,
                errorText: _lastNameError,
                maxLength: _nameMaxLength,
              ),

              _buildGenderAndDobRow(),

              _buildEditableField(
                controller: _emailController,
                label: 'account_email'.tr(),
                hintText: 'emailFieldHint'.tr(),
                keyboardType: TextInputType.emailAddress,
                isEnabled: _canEditEmail,
                errorText: _emailError,
              ),

              // Email Verification Status
              if (!_isSsoLocked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isEmailVerified
                              ? 'account_email_verified'.tr()
                              : 'account_email_not_verified'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: _isEmailVerified ? Colors.green[700] : Colors.orange[700],
                          ),
                        ),
                      ),
                      Icon(
                        _isEmailVerified ? Icons.check_circle : Icons.warning_amber_rounded,
                        color: _isEmailVerified ? Colors.green : Colors.orange,
                        size: 18,
                      ),
                    ],
                  ),
                ),

              // Error message
              if (_errorText != null && _errorText!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(_errorText!, style: const TextStyle(fontSize: 12, color: Colors.red)),
                ),
              SizedBox(height: MediaQuery.of(context).size.shortestSide-150,),

              // Save Button
              if (_canEditProfile)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _save,
                      child: Text(_isLoading ? 'account_saving'.tr() : 'saveButton'.tr()),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    bool isEnabled = true,
    String? errorText,
    int? maxLength,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: isEnabled,
          inputFormatters: [if (maxLength != null) LengthLimitingTextInputFormatter(maxLength + 1)],
          onChanged: (_) {
            if (label == 'account_first_name'.tr()) {
              setState(() {
                _firstNameError = controller.text.trim().length > _nameMaxLength
                    ? 'account_error_name_max'.tr()
                    : null;
              });
            } else if (label == 'account_last_name'.tr()) {
              setState(() {
                _lastNameError = controller.text.trim().length > _nameMaxLength
                    ? 'account_error_name_max'.tr()
                    : null;
              });
            } else if (label == 'account_email'.tr()) {
              final email = controller.text.trim();
              setState(() {
                _emailError = email.isNotEmpty && !_isValidEmail(email)
                    ? 'account_error_email_format'.tr()
                    : null;
              });
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.transparent),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: errorText != null ? Colors.red : context.colors.accentDefault),
            ),
            hintText: hintText ?? label,
            filled: true,
            fillColor: const Color(0xFFF4F4F4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: controller.text.isNotEmpty && isEnabled
                ? IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () {
                controller.clear();
                if (label == 'account_first_name'.tr()) {
                  setState(() => _firstNameError = null);
                } else if (label == 'account_last_name'.tr()) {
                  setState(() => _lastNameError = null);
                } else if (label == 'account_email'.tr()) {
                  setState(() => _emailError = null);
                }
              },
            )
                : null,
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText, style: const TextStyle(fontSize: 11, color: Colors.red)),
        ],
      ],
    ),
  );

  Widget _buildGenderAndDobRow() {
    final canEdit = _canEditProfile;
    final selected = _selectedGender;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('account_gender'.tr(), style: const TextStyle(fontSize: 12, color: Colors.black87)),
                const SizedBox(height: 4),
                DecoratedBox(
                  decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      _buildGenderChip(
                        label: 'M',
                        isSelected: selected == 'M',
                        onTap: canEdit ? () => setState(() => _selectedGender = 'M') : null,
                      ),
                      _buildGenderChip(
                        label: 'F',
                        isSelected: selected == 'F',
                        onTap: canEdit ? () => setState(() => _selectedGender = 'F') : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('date_of_birth'.tr(), style: const TextStyle(fontSize: 12, color: Colors.black87)),
                const SizedBox(height: 4),
                InkWell(
                  onTap: canEdit ? _showDatePickerSheet : null,
                  borderRadius: BorderRadius.circular(8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _formatDob(_selectedDob),
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedDob == null ? Colors.grey[500] : Colors.black87,
                              ),
                            ),
                          ),
                          Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
                        ],
                      ),
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

  Widget _buildGenderChip({
    required String label,
    required bool isSelected,
    required VoidCallback? onTap,
  }) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? Colors.grey.shade400 : Colors.transparent),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, color: onTap == null ? Colors.grey[500] : Colors.black87),
        ),
      ),
    ),
  );

  Future<void> _showDatePickerSheet() async {
    final initialDate = _selectedDob ?? DateTime(1990, 1, 1);
    DateTime tempDate = initialDate;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SafeArea(
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text('choose_date'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(1900),
                  initialDateTime: initialDate,
                  onDateTimeChanged: (value) => tempDate = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      setState(() => _selectedDob = tempDate);
                      Navigator.of(context).pop();
                    },
                    child: Text('done'.tr()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ OTP Bottom Sheet Widget
class OtpBottomSheetWidget extends StatefulWidget {
  final String pendingEmail;
  final Function(String) onVerify;
  final VoidCallback onResend;
  final VoidCallback onCancel;
  final bool isLoading;
  final int failureCount;
  final int resendAttemptsLeft;

  const OtpBottomSheetWidget({
    super.key,
    required this.pendingEmail,
    required this.onVerify,
    required this.onResend,
    required this.onCancel,
    this.isLoading = false,
    this.failureCount = 0,
    this.resendAttemptsLeft = 3,
  });

  @override
  State<OtpBottomSheetWidget> createState() => _OtpBottomSheetWidgetState();
}

class _OtpBottomSheetWidgetState extends State<OtpBottomSheetWidget> {
  final TextEditingController _otpController = TextEditingController();
  bool _showResend = false;

  @override
  void initState() {
    super.initState();
    _showResend = widget.failureCount >= 1;
  }

  @override
  void didUpdateWidget(OtpBottomSheetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.failureCount != oldWidget.failureCount) {
      setState(() => _showResend = widget.failureCount >= 1);
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpValue = _otpController.text.trim();
    final isCodeComplete = otpValue.length == 4;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            'account_enter_code_from_email'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            'account_verify_email_instruction'.tr(),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            widget.pendingEmail,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          // OTP Input (Styled like design)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              final char = index < otpValue.length ? otpValue[index] : '';
              final isActive = index == otpValue.length && otpValue.length < 4;
              return Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? const Color(0xFF005C30) : Colors.transparent,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  char,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              );
            }),
          ),
          // Hidden TextField for OTP input
          const SizedBox(height: 8),
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _otpController,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          // Resend attempts info
          if (_showResend && widget.resendAttemptsLeft > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'account_resend_attempts'.tr().replaceFirst('%s', '${widget.resendAttemptsLeft}'),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          const SizedBox(height: 16),
          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.isLoading || !isCodeComplete ? null : () => widget.onVerify(otpValue),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF005C30),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                widget.isLoading ? 'account_verifying'.tr() : 'account_confirm_otp'.tr(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Resend Button (shown only after failure)
          if (_showResend)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: widget.isLoading || widget.resendAttemptsLeft <= 0 ? null : widget.onResend,
                child: Text(
                  'account_resend_code'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.resendAttemptsLeft > 0 ? const Color(0xFF005C30) : Colors.grey,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}