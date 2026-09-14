import 'dart:async';

import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/entities/profile/user_profile_data.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/profile/profile_account_service.dart';

/// Pill radius for fields / buttons (matches existing layout; not all tokens expose radius).
const _kFieldRadius = 10.0;

class PersonalData extends ConsumerStatefulWidget {
  final SsoUserInfo userInfo;

  const PersonalData({
    required this.userInfo,
    super.key,
  });

  @override
  ConsumerState<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends ConsumerState<PersonalData> {
  static const int _nameMaxLength = 100;
  static const int _otpResendIntervalSeconds = 60;
  static const int _otpMaxVerifyAttempts = 3;

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

  /// Wall-clock time when the next OTP send/resend is allowed. Survives sheet
  /// dismiss/reopen so the cooldown cannot be bypassed by leaving the screen.
  DateTime? _otpResendAvailableAt;

  /// Failed verify attempts for the current OTP session. Survives sheet reopen.
  int _otpVerifyFailureCount = 0;

  /// Ticks while a cooldown is active so the profile UI can show the remaining time.
  Timer? _otpCooldownTicker;
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;

  String _activeEmail = '';
  String? _pendingEmail;
  String _initialFirstName = '';
  String _initialLastName = '';
  String _currentFirstName = '';
  String _currentLastName = '';
  int _selectedGender = 0;
  int _initialGender = 0;
  DateTime? _selectedBirthDate;
  DateTime? _initialBirthDate;

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

    _currentFirstName = userInfo.getLocalizedFirstName(language);
    _currentLastName = userInfo.getLocalizedLastName(language);

    _firstNameController.text = _currentFirstName;
    _lastNameController.text = _currentLastName;
    _activeEmail = userInfo.mail?.trim() ?? '';
    _emailController.text = _activeEmail;
    _isEmailVerified = userInfo.isEmailVerified;

    _initialFirstName = _currentFirstName;
    _initialLastName = _currentLastName;
    _selectedGender = int.tryParse(userInfo.sex ?? '') ?? 0;
    _initialGender = _selectedGender;
    _selectedBirthDate = _parseBirthDate(userInfo.dob);
    _initialBirthDate = _selectedBirthDate;
    _pendingEmail = null;
    _errorText = null;

    print('📱 Loaded user data - Email: $_activeEmail, isEmailVerified: $_isEmailVerified');
  }

  /// Seconds left before another OTP can be sent. Based on wall clock so it
  /// remains correct after the sheet is dismissed and reopened.
  int get _otpResendSecondsRemaining {
    final until = _otpResendAvailableAt;
    if (until == null) return 0;
    final remaining = until.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  String get _formattedOtpCountdown {
    final remaining = _otpResendSecondsRemaining;
    final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (remaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _startOtpResendCooldown() {
    _otpResendAvailableAt = DateTime.now().add(
      const Duration(seconds: _otpResendIntervalSeconds),
    );
    _startOtpCooldownTicker();
  }

  void _startOtpCooldownTicker() {
    _otpCooldownTicker?.cancel();
    if (_otpResendSecondsRemaining <= 0) return;
    _otpCooldownTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_otpResendSecondsRemaining <= 0) {
        _otpCooldownTicker?.cancel();
        _otpCooldownTicker = null;
      }
      setState(() {});
    });
  }

  void _clearOtpCooldownState() {
    _otpCooldownTicker?.cancel();
    _otpCooldownTicker = null;
    _otpResendAvailableAt = null;
    _otpVerifyFailureCount = 0;
  }

  Future<void> _fetchLatestUserInfo({
    bool updateAuthProvider = true,
    String? overrideFirstName,
    String? overrideLastName,
  }) async {
    try {
      final userInfoJson = await _service.getUserInfo();
      // `/api/user/userinfo` does NOT return `complete_profile` — that flag
      // only comes from `MobileLoginVerifyOtp` at login time. Preserve the
      // original value captured on the existing `widget.userInfo` so the
      // edit/read-only gating doesn't get reset to the default after a refresh.
      final previousAuth = ref.read(authProvider).value;
      final freshParsed = SsoUserInfo.fromJson(userInfoJson);
      // `/api/user/userinfo` may omit a previously-saved but still-unverified
      // email. Fall back to the last known address so it stays visible.
      final freshHasEmail = freshParsed.mail?.trim().isNotEmpty ?? false;
      final fallbackEmail = previousAuth?.mail ?? widget.userInfo.mail;
      var freshUserInfo = freshParsed.copyWith(
        completeProfile: previousAuth?.completeProfile ?? widget.userInfo.completeProfile,
        loginType: previousAuth?.loginType ?? widget.userInfo.loginType,
        isEmailEditable: previousAuth?.isEmailEditable ?? widget.userInfo.isEmailEditable,
        isSSOLocked: previousAuth?.isSSOLocked ?? widget.userInfo.isSSOLocked,
        mail: freshHasEmail ? freshParsed.mail : fallbackEmail,
        isEmailVerified: freshHasEmail
            ? freshParsed.isEmailVerified
            : (previousAuth?.isEmailVerified ?? widget.userInfo.isEmailVerified),
      );

      if (overrideFirstName != null && overrideLastName != null) {
        final fullName = '$overrideFirstName $overrideLastName'.trim();
        freshUserInfo = freshUserInfo.copyWith(arName: fullName, enName: fullName);
      }

      final language = ref.read(appLanguageProvider);

      print(
        '🔄 Fetched fresh user info - Email: ${freshUserInfo.mail}, isEmailVerified: ${freshUserInfo.isEmailVerified}, completeProfile: ${freshUserInfo.completeProfile}',
      );

      setState(() {
        _currentFirstName = freshUserInfo.getLocalizedFirstName(language);
        _currentLastName = freshUserInfo.getLocalizedLastName(language);
        _firstNameController.text = _currentFirstName;
        _lastNameController.text = _currentLastName;
        _activeEmail = freshUserInfo.mail?.trim() ?? '';
        // While email OTP is pending, the server still has the old address — keep
        // showing the address the user is verifying in the field.
        if (_otpPending && _pendingEmail != null && _pendingEmail!.isNotEmpty) {
          _emailController.text = _pendingEmail!;
        } else {
          _emailController.text = _activeEmail;
        }
        _isEmailVerified = freshUserInfo.isEmailVerified;
        _initialFirstName = _currentFirstName;
        _initialLastName = _currentLastName;
        _selectedGender = int.tryParse(freshUserInfo.sex ?? '') ?? _selectedGender;
        _initialGender = _selectedGender;
        _selectedBirthDate = _parseBirthDate(freshUserInfo.dob) ?? _selectedBirthDate;
        _initialBirthDate = _selectedBirthDate;
      });

      if (updateAuthProvider) {
        await ref.read(authProvider.notifier).updateUserInfo(freshUserInfo);
      }
    } catch (e) {
      print('❌ Failed to fetch fresh user info: $e');
    }
  }

  @override
  void dispose() {
    _otpCooldownTicker?.cancel();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isOtpUser => widget.userInfo.loginType == SsoLoginType.otp;

  /// Returned by `MobileLoginVerifyOtp`:
  /// - `true`  → user signed up via OTP only → editing allowed.
  /// - `false` → user already has an SSO/Nafath account → profile is owned by SSO,
  ///   so editing must be blocked even though they logged in via OTP.
  bool get _hasCompleteOtpProfile => widget.userInfo.completeProfile;

  bool get _canEditProfile => _isOtpUser && _hasCompleteOtpProfile;

  bool get _canEditEmail => _isOtpUser && _hasCompleteOtpProfile && widget.userInfo.isEmailEditable;

  DateTime? _parseBirthDate(String? dob) {
    if (dob == null || dob.trim().isEmpty) return null;

    final normalized = dob.trim();
    final dashParts = normalized.split('-');
    if (dashParts.length == 3) {
      final year = int.tryParse(dashParts[0]);
      final month = int.tryParse(dashParts[1]);
      final day = int.tryParse(dashParts[2]);
      if (year != null && month != null && day != null) {
        return DateTime(year, month, day);
      }
    }

    final slashParts = normalized.split('/');
    if (slashParts.length == 3) {
      final a = int.tryParse(slashParts[0]) ?? 0;
      final b = int.tryParse(slashParts[1]) ?? 0;
      final c = int.tryParse(slashParts[2]) ?? 0;
      if (c > 1800) {
        return DateTime(c, b, a);
      }
      if (a > 1800) {
        return DateTime(a, b, c);
      }
    }

    return null;
  }

  String _formatBirthDateForDisplay(SsoUserInfo userInfo) {
    final hijri = userInfo.getHijriBirthDate();
    if (hijri.isNotEmpty) return hijri;
    return userInfo.dob?.trim() ?? '';
  }

  String _displayBirthDate() {
    if (_selectedBirthDate != null) {
      final date = _selectedBirthDate!;
      final gregorian = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      final hijri = widget.userInfo.copyWith(dob: gregorian).getHijriBirthDate();
      if (hijri.isNotEmpty) return hijri;
      return _formatBirthDateForApi(date);
    }
    return _formatBirthDateForDisplay(widget.userInfo);
  }

  String _formatBirthDateForApi(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  Future<void> _pickBirthDate() async {
    if (!_canEditProfile) return;

    final now = DateTime.now();
    final initial = _selectedBirthDate ?? DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null && mounted) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  /// True when first name, last name, email, gender, or birth date differs from saved values.
  bool _hasUnsavedChanges() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final nameChanged = first != _currentFirstName || last != _currentLastName;
    final emailChanged = email != _activeEmail;
    final genderChanged = _selectedGender != _initialGender;
    final birthDateChanged = _selectedBirthDate != _initialBirthDate;
    return nameChanged || emailChanged || genderChanged || birthDateChanged;
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
    if (_isOtpUser && email.isNotEmpty && !_isValidEmail(email)) {
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

    final newFirstName = _firstNameController.text.trim();
    final newLastName = _lastNameController.text.trim();
    final newEmail = _emailController.text.trim();
    final emailChanged = newEmail != _activeEmail;
    final nameChanged = newFirstName != _currentFirstName || newLastName != _currentLastName;
    final genderChanged = _selectedGender != _initialGender;
    final birthDateChanged = _selectedBirthDate != _initialBirthDate;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final profileChanges = <String, dynamic>{};
      if (nameChanged && _canEditProfile) {
        profileChanges['firstname'] = newFirstName;
        profileChanges['lastname'] = newLastName;
      }
      if (genderChanged && _canEditProfile && _selectedGender > 0) {
        profileChanges['gender'] = _selectedGender.toString();
      }
      if (birthDateChanged && _canEditProfile && _selectedBirthDate != null) {
        profileChanges['birthDate'] = _formatBirthDateForApi(_selectedBirthDate!);
      }

      final hasProfileChanges = profileChanges.isNotEmpty;
      if (hasProfileChanges) {
        await _service.updateUserProfile(changes: profileChanges);
        await _fetchLatestUserInfo(
          updateAuthProvider: !emailChanged,
          overrideFirstName: nameChanged ? newFirstName : null,
          overrideLastName: nameChanged ? newLastName : null,
        );

        setState(() {
          if (nameChanged) {
            _currentFirstName = newFirstName;
            _initialFirstName = newFirstName;
            _currentLastName = newLastName;
            _initialLastName = newLastName;
          }
          if (genderChanged) {
            _initialGender = _selectedGender;
          }
          if (birthDateChanged) {
            _initialBirthDate = _selectedBirthDate;
          }
          if (!emailChanged) {
            _activeEmail = newEmail;
            _emailController.text = _activeEmail;
          } else {
            _emailController.text = newEmail;
          }
        });

        if (mounted && !emailChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('account_save_success'.tr())),
          );
        }
      }

      if (emailChanged && newEmail.isNotEmpty && _canEditEmail) {
        if (_otpResendSecondsRemaining > 0) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('account_error_wait_before_resend'.tr())),
          );
          if (_sessionId != null && _pendingEmail != null) {
            setState(() => _otpPending = true);
            _showOtpBottomSheet();
          }
          return;
        }
        final sessionId = await _service.sendVerificationEmail(newEmail);
        if (!mounted) return;
        setState(() {
          _sessionId = sessionId;
          _otpPending = true;
          _pendingEmail = newEmail;
          _isEmailVerified = false;
          _errorText = null;
          _isLoading = false;
          _otpVerifyFailureCount = 0;
          _startOtpResendCooldown();
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('verification_code_sent'.tr())),
          );
          _showOtpBottomSheet();
        });
      } else if (!emailChanged && hasProfileChanges) {
        setState(() => _isLoading = false);
      } else {
        setState(() => _isLoading = false);
      }
    } on DioException catch (e) {
      _handleDioError(e);
      setState(() => _isLoading = false);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Profile save failed: $e');
      }
      if (!mounted) return;
      setState(() {
        _errorText = 'account_error_save_failed'.tr();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateEmailAfterVerification() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final currentFirstName = _firstNameController.text.trim();
      final currentLastName = _lastNameController.text.trim();

      await _service.updateUserProfile(
        changes: <String, dynamic>{
          'firstname': currentFirstName,
          'lastname': currentLastName,
          'email': _pendingEmail,
        },
      );

      await _fetchLatestUserInfo(
        overrideFirstName: currentFirstName,
        overrideLastName: currentLastName,
      );

      setState(() {
        _activeEmail = _pendingEmail ?? _activeEmail;
        _emailController.text = _activeEmail;
        _isEmailVerified = true;
        _otpPending = false;
        _sessionId = null;
        _pendingEmail = null;
        _clearOtpCooldownState();
        _currentFirstName = currentFirstName;
        _currentLastName = currentLastName;
        _initialFirstName = currentFirstName;
        _initialLastName = currentLastName;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('account_email_verified_success'.tr())),
        );
      }
    } catch (e) {
      setState(() {
        _errorText = 'account_error_save_failed'.tr();
        _isLoading = false;
      });
    }
  }

  /// Sends a verification code for the already-saved (but unverified) email and
  /// opens the OTP sheet. Used when the address hasn't changed, so the normal
  /// "Save" path (which only triggers OTP on an email change) wouldn't fire.
  Future<void> _verifySavedEmail() async {
    final email = _activeEmail.trim();
    if (email.isEmpty || !_canEditEmail) return;

    // Cooldown still active from a previous send — reopen the sheet with the
    // remaining timer instead of issuing a fresh code that would bypass it.
    if (_otpResendSecondsRemaining > 0) {
      if (_sessionId != null && (_pendingEmail ?? email).isNotEmpty) {
        setState(() {
          _otpPending = true;
          _pendingEmail ??= email;
        });
        _showOtpBottomSheet();
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('account_error_wait_before_resend'.tr())),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final sessionId = await _service.sendVerificationEmail(email);
      if (!mounted) return;
      setState(() {
        _sessionId = sessionId;
        _otpPending = true;
        _pendingEmail = email;
        _isEmailVerified = false;
        _isLoading = false;
        _otpVerifyFailureCount = 0;
        _startOtpResendCooldown();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('verification_code_sent'.tr())),
        );
        _showOtpBottomSheet();
      });
    } on DioException catch (e) {
      _handleDioError(e);
      setState(() => _isLoading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorText = 'account_error_save_failed'.tr();
        _isLoading = false;
      });
    }
  }

  void _showOtpBottomSheet() {
    // Use listen:false — this runs from async save / post-frame callbacks.
    final colors = context.themeRead.colors;
    final sheetBackground = context.profileCardColor;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBackground,
      barrierColor: colors.screenOverlayDimming40,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OtpBottomSheetWidget(
        pendingEmail: _pendingEmail!,
        onVerify: _verifyOtp,
        onResend: _resendOtp,
        onCancel: _cancelOtpVerification,
        onFailureCountChanged: (count) {
          _otpVerifyFailureCount = count;
        },
        resendAttemptsLeft: _resendAttemptsLeft,
        initialFailureCount: _otpVerifyFailureCount,
        initialSecondsRemaining: _otpResendSecondsRemaining,
      ),
    );
    // Do not cancel OTP on dismiss — countdown and failure count must survive
    // leaving and reopening the sheet. Explicit close (X) still cancels.
  }

  /// Verifies the OTP entered in the bottom sheet.
  ///
  /// Returns `true` when verification succeeded (and the email was updated),
  /// `false` otherwise. The bottom sheet uses this result to clear its
  /// inputs / show an inline error — we can't drive its state via the
  /// parent's `setState` because the modal lives in a separate route and
  /// won't rebuild from parent rebuilds.
  Future<bool> _verifyOtp(String otp) async {
    if (_sessionId == null) {
      setState(() => _errorText = 'account_error_session_expired'.tr());
      return false;
    }

    try {
      final ok = await _service.verifyEmail(sessionId: _sessionId!, otp: otp);
      if (ok) {
        // Clear before pop so the sheet's `.then` does not run `_cancelOtpVerification`
        // and revert the email while `_updateEmailAfterVerification` is still running.
        if (mounted) {
          setState(() => _otpPending = false);
        }
        if (mounted) Navigator.of(context).pop();
        await _updateEmailAfterVerification();
        return true;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('account_error_invalid_otp'.tr())),
        );
      }
      return false;
    } on DioException catch (e) {
      final msg = e.response?.statusCode == 409
          ? 'account_error_otp_expired_or_invalid'.tr()
          : (e.message ?? 'account_error_verify_otp_failed'.tr());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
      return false;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('account_error_verify_otp_failed'.tr())),
        );
      }
      return false;
    }
  }

  /// Returns `true` when the code was re-sent successfully. The bottom sheet
  /// uses the result to (re)start its resend countdown only on success.
  Future<bool> _resendOtp() async {
    final email = _pendingEmail?.trim() ?? '';
    if (email.isEmpty) {
      setState(() => _errorText = 'account_error_session_expired'.tr());
      return false;
    }
    if (_otpResendSecondsRemaining > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('account_error_wait_before_resend'.tr())),
      );
      return false;
    }
    if (_resendAttemptsLeft <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('account_error_no_resend_attempts'.tr())),
      );
      return false;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      // The generic `/api/user/ReSendOtp` endpoint has no valid `reSendOtpType`
      // for the email-verification flow (server rejects it as invalid), so we
      // re-issue the code through `SendVerificationEmail`, which returns a fresh
      // session id that the next verify step must use.
      final newSessionId = await _service.sendVerificationEmail(email);
      setState(() {
        _sessionId = newSessionId;
        _resendAttemptsLeft--;
        _otpVerifyFailureCount = 0;
        _startOtpResendCooldown();
        _errorText = null;
        _isLoading = false;
      });
      return true;
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg = code == 409
          ? 'account_error_wait_before_resend'.tr()
          : code == 429
          ? 'account_error_too_many_requests'.tr()
          : (e.message ?? 'account_error_resend_failed'.tr());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      setState(() => _isLoading = false);
      return false;
    } catch (_) {
      setState(() {
        _errorText = 'account_error_resend_failed'.tr();
        _isLoading = false;
      });
      return false;
    }
  }

  void _cancelOtpVerification() {
    final emailToKeep = _pendingEmail ?? _emailController.text.trim();
    setState(() {
      _otpPending = false;
      _pendingEmail = null;
      _sessionId = null;
      // Keep cooldown + failure count so leaving and coming back cannot bypass
      // the retry timeout. Cleared only after a successful verification.
      // Keep the address the user was verifying (dismiss sheet / swipe / back).
      // Server still has `_activeEmail` until they complete OTP.
      if (emailToKeep.isNotEmpty) {
        _emailController.text = emailToKeep;
      } else {
        _emailController.text = _activeEmail;
      }
      final display = _emailController.text.trim();
      if (display.isEmpty || display != _activeEmail) {
        _isEmailVerified = false;
      } else {
        _isEmailVerified = widget.userInfo.isEmailVerified;
      }
    });
  }

  Future<void> _refreshUserInfo() async {
    try {
      await ref.read(authProvider.notifier).forceUpdate();
      _loadUserData();
    } catch (e) {
      if (kDebugMode) print('Failed to refresh user info: $e');
    }
  }

  void _handleDioError(DioException e) {
    setState(() {
      _errorText = e.response?.statusCode == 409
          ? 'account_error_wait_before_resend'.tr()
          : e.response?.statusCode == 429
          ? 'account_error_too_many_requests'.tr()
          : (e.message ?? 'account_error_save_failed'.tr());
    });
  }

  bool _shouldShowField({required bool isEditable, String? value}) {
    if (isEditable) return true;
    return value != null && value.trim().isNotEmpty;
  }

  bool _shouldShowGender({required bool isEditable}) {
    if (isEditable) return true;
    final sex = widget.userInfo.sex;
    if (sex == null || sex.trim().isEmpty) return false;
    return (int.tryParse(sex) ?? 0) > 0;
  }

  bool _shouldShowBirthDate({required bool isEditable, required String display}) {
    if (isEditable) return true;
    return display.trim().isNotEmpty;
  }

  List<Widget> _buildProfileFieldSections(
    BuildContext context, {
    required Language language,
    required SsoUserInfo userInfo,
    required String birthDateDisplay,
  }) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final sections = <Widget>[];

    void addSection(Widget section) {
      if (sections.isNotEmpty) {
        sections.add(const SizedBox(height: 16));
      }
      sections.add(section);
    }

    final firstName = userInfo.getLocalizedFirstName(language);
    if (_shouldShowField(isEditable: _canEditProfile, value: firstName)) {
      addSection(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'account_first_name'.tr()),
            const SizedBox(height: 6),
            if (_canEditProfile) ...[
              _buildPillField(
                context,
                controller: _firstNameController,
                hintText: 'account_first_name_hint'.tr(),
                errorText: _firstNameError,
                maxLength: _nameMaxLength,
                onChanged: (_) => setState(() {
                  _firstNameError = _firstNameController.text.trim().length > _nameMaxLength
                      ? 'account_error_name_max'.tr()
                      : null;
                }),
              ),
              if (_firstNameError != null) _buildErrorText(context, _firstNameError!),
            ] else
              _buildReadOnlyPill(context, firstName),
          ],
        ),
      );
    }

    final lastName = userInfo.getLocalizedLastName(language);
    if (_shouldShowField(isEditable: _canEditProfile, value: lastName)) {
      addSection(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'account_last_name'.tr()),
            const SizedBox(height: 6),
            if (_canEditProfile) ...[
              _buildPillField(
                context,
                controller: _lastNameController,
                hintText: 'account_last_name_hint'.tr(),
                errorText: _lastNameError,
                maxLength: _nameMaxLength,
                onChanged: (_) => setState(() {
                  _lastNameError = _lastNameController.text.trim().length > _nameMaxLength
                      ? 'account_error_name_max'.tr()
                      : null;
                }),
              ),
              if (_lastNameError != null) _buildErrorText(context, _lastNameError!),
            ] else
              _buildReadOnlyPill(context, lastName),
          ],
        ),
      );
    }

    final showGender = _shouldShowGender(isEditable: _canEditProfile);
    final showBirthDate = _shouldShowBirthDate(isEditable: _canEditProfile, display: birthDateDisplay);
    if (showGender || showBirthDate) {
      addSection(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showGender) ...[
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'account_gender'.tr()),
                    const SizedBox(height: 6),
                    _GenderToggle(
                      selected: _canEditProfile ? _selectedGender : int.tryParse(userInfo.sex ?? '') ?? 0,
                      onChanged: _canEditProfile ? (value) => setState(() => _selectedGender = value) : null,
                    ),
                  ],
                ),
              ),
              if (showBirthDate) const SizedBox(width: 12),
            ],
            if (showBirthDate)
              Flexible(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'date_of_birth'.tr()),
                    const SizedBox(height: 6),
                    if (_canEditProfile)
                      GestureDetector(
                        onTap: _pickBirthDate,
                        child: _buildReadOnlyPill(context, birthDateDisplay),
                      )
                    else
                      _buildReadOnlyPill(context, birthDateDisplay),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    final email = userInfo.mail ?? '';
    if (_shouldShowField(isEditable: _canEditEmail, value: email)) {
      addSection(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'account_email'.tr()),
            const SizedBox(height: 6),
            if (_canEditEmail) ...[
              _buildPillField(
                context,
                controller: _emailController,
                hintText: 'emailFieldHint'.tr(),
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (_) {
                  final trimmedEmail = _emailController.text.trim();
                  setState(() {
                    _emailError = trimmedEmail.isNotEmpty && !_isValidEmail(trimmedEmail)
                        ? 'account_error_email_format'.tr()
                        : null;
                  });
                },
              ),
              if (_emailError != null) _buildErrorText(context, _emailError!),
              if (_otpPending) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.mark_email_unread_outlined, color: colors.warningDefault, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'account_verify_email_instruction'.tr(),
                        style: textStyles.captionMediumRegular.copyWith(
                          color: colors.warningOnContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_otpResendSecondsRemaining > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    'account_resend_code_in'.tr().replaceFirst('%s', _formattedOtpCountdown),
                    style: textStyles.captionMediumRegular.copyWith(
                      color: colors.foregroundMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _showOtpBottomSheet,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.accentDefault,
                      side: BorderSide(color: colors.accentDefault),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_kFieldRadius),
                      ),
                    ),
                    child: Text(
                      'account_enter_code_from_email'.tr(),
                      style: textStyles.buttonM.copyWith(color: colors.accentDefault),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      _isEmailVerified ? Icons.check_circle : Icons.warning_amber_rounded,
                      color: _isEmailVerified ? colors.successDefault : colors.warningDefault,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isEmailVerified ? 'account_email_verified'.tr() : 'account_email_not_verified'.tr(),
                      style: textStyles.captionMediumRegular.copyWith(
                        color: _isEmailVerified ? colors.successDefault : colors.warningOnContainer,
                      ),
                    ),
                  ],
                ),
                // Saved-but-unverified email that the user hasn't changed:
                // offer an explicit action to verify it (Save won't fire since
                // there's no change to persist).
                // Also show while a cooldown is still running after cancel, so
                // the remaining wait time stays visible.
                if ((!_isEmailVerified && _activeEmail.isNotEmpty && _emailController.text.trim() == _activeEmail) ||
                    _otpResendSecondsRemaining > 0) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 44,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isLoading || _otpResendSecondsRemaining > 0 ? null : _verifySavedEmail,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.accentDefault,
                        disabledForegroundColor: colors.foregroundDefault,
                        side: BorderSide(
                          color: _otpResendSecondsRemaining > 0 ? colors.borderSoft : colors.accentDefault,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_kFieldRadius),
                        ),
                      ),
                      child: Text(
                        _otpResendSecondsRemaining > 0
                            ? 'account_resend_code_in'.tr().replaceFirst('%s', _formattedOtpCountdown)
                            : 'account_verify_email_button'.tr(),
                        style: textStyles.buttonM.copyWith(
                          color: _otpResendSecondsRemaining > 0 ? colors.foregroundDefault : colors.accentDefault,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ] else
              _buildReadOnlyEmailPill(
                context,
                value: email,
                isVerified: _isEmailVerified,
              ),
          ],
        ),
      );
    }

    if (_shouldShowField(isEditable: false, value: userInfo.arName)) {
      addSection(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'arabicFullName'.tr()),
            const SizedBox(height: 6),
            _buildReadOnlyPill(context, userInfo.arName!),
          ],
        ),
      );
    }

    if (_shouldShowField(isEditable: false, value: userInfo.enName)) {
      addSection(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'englishFullName'.tr()),
            const SizedBox(height: 6),
            _buildReadOnlyPill(context, userInfo.enName!),
          ],
        ),
      );
    }

    if (_shouldShowField(isEditable: false, value: userInfo.nationality)) {
      addSection(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'nationality'.tr()),
            const SizedBox(height: 6),
            _buildReadOnlyPill(context, userInfo.nationality!),
          ],
        ),
      );
    }

    return sections;
  }

  // ─── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final language = ref.read(appLanguageProvider);
    final userInfo = widget.userInfo;
    final colors = context.colors;
    final textStyles = context.textStyles;

    final hasFieldErrors = _firstNameError != null || _lastNameError != null || _emailError != null;
    final hasChanges = _hasUnsavedChanges();
    final birthDateDisplay = _displayBirthDate();
    final profileFields = _buildProfileFieldSections(
      context,
      language: language,
      userInfo: userInfo,
      birthDateDisplay: birthDateDisplay,
    );

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 20,
            bottom: _canEditProfile ? MediaQuery.of(context).size.height - 500 : 20,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.profileCardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...profileFields,
                if (_errorText != null && _errorText!.isNotEmpty) ...[
                  if (profileFields.isNotEmpty) const SizedBox(height: 12),
                  Text(
                    _errorText!,
                    style: textStyles.captionMediumRegular.copyWith(color: colors.errorDefault),
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Fixed Save button (only when edit implementation is enabled) ──
        if (_canEditProfile && !_otpPending)
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height - 250,
            child: Container(
              color: Colors.transparent,
              child: SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: hasFieldErrors || !hasChanges
                      ? null
                      : _isLoading
                      ? () {}
                      : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.accentDefault,
                    disabledBackgroundColor: colors.neutralContainerMuted,
                    disabledForegroundColor: colors.foregroundMuted,
                    foregroundColor: colors.staticWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_kFieldRadius),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: colors.staticWhite,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'account_saving'.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textStyles.buttonL.copyWith(color: colors.staticWhite),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'saveButton'.tr(),
                          style: textStyles.buttonL.copyWith(color: colors.staticWhite),
                        ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ─── UI Helpers ──────────────────────────────────────────────────────────

  Widget _buildLabel(BuildContext context, String text) => Text(
    text,
    style: context.textStyles.captionLargeMedium.copyWith(
      color: context.colors.foregroundDefault,
    ),
  );

  Widget _buildErrorText(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 4, left: 4),
    child: Text(
      text,
      style: context.textStyles.captionMediumRegular.copyWith(
        color: context.colors.errorDefault,
      ),
    ),
  );

  Widget _buildReadOnlyPill(BuildContext context, String value) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.profileFieldFillColor,
        borderRadius: BorderRadius.circular(_kFieldRadius),
      ),
      child: Text(
        value,
        style: textStyles.bodyLargeRegular.copyWith(color: colors.foregroundDefault),
      ),
    );
  }

  Widget _buildReadOnlyEmailPill(
    BuildContext context, {
    required String value,
    required bool isVerified,
  }) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.profileFieldFillColor,
        borderRadius: BorderRadius.circular(_kFieldRadius),
      ),
      child: Row(
        children: [
          if (!isVerified && value.isNotEmpty) ...[
            Icon(
              Icons.warning_amber_rounded,
              color: colors.warningDefault,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              value,
              style: textStyles.bodyLargeRegular.copyWith(color: colors.foregroundDefault),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
    int? maxLength,
    void Function(String)? onChanged,
  }) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final hasError = errorText != null;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength + 1),
      ],
      onChanged: onChanged,
      style: textStyles.bodyLargeRegular.copyWith(color: colors.foregroundDefault),
      cursorColor: colors.accentDefault,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyles.bodyLargeRegular.copyWith(color: colors.foregroundMuted),
        filled: true,
        fillColor: context.profileFieldFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_kFieldRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_kFieldRadius),
          borderSide: hasError ? BorderSide(color: colors.errorDefault, width: 1.5) : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_kFieldRadius),
          borderSide: hasError
              ? BorderSide(color: colors.errorDefault, width: 1.5)
              : BorderSide(color: colors.accentDefault, width: 1.5),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  controller.clear();
                  setState(() {});
                  if (onChanged != null) onChanged('');
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: colors.foregroundSoft,
                ),
              )
            : null,
      ),
    );
  }
}

// ─── Gender Toggle ──────────────────────────────────────────────────────────

class _GenderToggle extends StatelessWidget {
  final int selected;
  final ValueChanged<int>? onChanged;

  const _GenderToggle({required this.selected, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: ['M', 'F'].map((g) {
        final genderValue = g == 'M' ? 1 : 2;
        final isSelected = (g == 'M' && selected == 1) || (g == 'F' && selected == 2);
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: GestureDetector(
            onTap: onChanged == null ? null : () => onChanged!(genderValue),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.profileFieldFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? colors.accentDefault : colors.borderSoft,
                  width: isSelected ? 2 : 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                g,
                style: textStyles.bodyLargeSemiBold.copyWith(
                  color: isSelected ? colors.accentDefault : colors.foregroundSoft,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── OTP Bottom Sheet ───────────────────────────────────────────────────────

class OtpBottomSheetWidget extends StatefulWidget {
  final String pendingEmail;

  /// Returns `true` when the OTP was accepted by the server, `false` otherwise.
  /// We use the result to clear the entered digits and surface an inline error
  /// inside the sheet — the parent's `setState` cannot reach this widget
  /// because it lives in a separate modal route.
  final Future<bool> Function(String otp) onVerify;

  /// Returns `true` when the code was re-sent successfully, so the sheet can
  /// restart its countdown; `false` leaves the countdown untouched.
  final Future<bool> Function() onResend;
  final VoidCallback onCancel;
  final int resendAttemptsLeft;

  /// Seconds the user must wait between resend requests (server-enforced).
  final int resendIntervalSeconds;

  /// Failed verify attempts restored when reopening the sheet.
  final int initialFailureCount;

  /// Remaining cooldown seconds restored when reopening the sheet.
  final int initialSecondsRemaining;

  final int maxVerifyAttempts;

  /// Keeps the parent in sync so failure count survives sheet dismiss/reopen.
  final ValueChanged<int> onFailureCountChanged;

  const OtpBottomSheetWidget({
    super.key,
    required this.pendingEmail,
    required this.onVerify,
    required this.onResend,
    required this.onCancel,
    required this.onFailureCountChanged,
    this.resendAttemptsLeft = 3,
    this.resendIntervalSeconds = 60,
    this.initialFailureCount = 0,
    this.initialSecondsRemaining = 60,
    this.maxVerifyAttempts = 3,
  });

  @override
  State<OtpBottomSheetWidget> createState() => _OtpBottomSheetWidgetState();
}

class _OtpBottomSheetWidgetState extends State<OtpBottomSheetWidget> {
  String _otpValue = '';
  bool _isVerifying = false;
  bool _isResending = false;

  /// Persistent count of failed verification attempts. Only reset when a new
  /// code is sent (resend) — NOT when the user simply retypes, otherwise the
  /// 3-attempt limit could never be reached.
  late int _failureCount;

  /// Drives the red box styling for the most recent failure; cleared visually
  /// once the user starts a fresh entry (without resetting `_failureCount`).
  bool _showErrorStyling = false;

  Timer? _resendTimer;
  late int _secondsRemaining;

  bool get _hasError => _showErrorStyling;
  bool get _attemptsExhausted => _failureCount >= widget.maxVerifyAttempts;
  bool get _canResend => _secondsRemaining <= 0 && !_isResending && widget.resendAttemptsLeft > 0;

  @override
  void initState() {
    super.initState();
    _failureCount = widget.initialFailureCount;
    // Restore remaining cooldown from the parent (wall-clock), so leaving and
    // reopening the sheet cannot reset or bypass the retry timeout.
    _secondsRemaining = widget.initialSecondsRemaining;
    if (_secondsRemaining > 0) {
      _tickResendCountdown();
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() => _secondsRemaining = widget.resendIntervalSeconds);
    _tickResendCountdown();
  }

  void _tickResendCountdown() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get _formattedCountdown {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;
    setState(() => _isResending = true);
    final ok = await widget.onResend();
    if (!mounted) return;
    setState(() {
      _isResending = false;
      _otpValue = '';
      // A fresh code resets both the failure counter and the error styling.
      _failureCount = 0;
      _showErrorStyling = false;
    });
    widget.onFailureCountChanged(0);
    if (ok) {
      _startResendCountdown();
    }
  }

  Future<void> _submit() async {
    if (_isVerifying || _otpValue.length != 4 || _attemptsExhausted) return;

    setState(() => _isVerifying = true);
    final success = await widget.onVerify(_otpValue);
    if (!mounted) return;

    if (success) {
      // Parent will pop the sheet on success; nothing else to do.
      setState(() => _isVerifying = false);
      return;
    }

    // Wrong / expired OTP → clear the boxes, mark error, count the attempt.
    setState(() {
      _isVerifying = false;
      _failureCount++;
      _showErrorStyling = true;
      _otpValue = '';
    });
    widget.onFailureCountChanged(_failureCount);
  }

  void _appendDigit(String d) {
    if (_isVerifying || _otpValue.length >= 4 || _attemptsExhausted) return;
    setState(() {
      _otpValue += d;
      // Clear only the red styling once the user starts a fresh entry — keep
      // `_failureCount` so the 3-attempt limit still applies.
      if (_showErrorStyling && _otpValue.length == 1) {
        _showErrorStyling = false;
      }
    });
    if (_otpValue.length == 4) {
      _submit();
    }
  }

  void _deleteDigit() {
    if (_isVerifying || _attemptsExhausted) return;
    if (_otpValue.isNotEmpty) {
      setState(() => _otpValue = _otpValue.substring(0, _otpValue.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final isCodeComplete = _otpValue.length == 4;
    final hasError = _hasError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Drag handle ───────────────────────────────────────────────
        const SizedBox(height: 12),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: colors.borderSoft,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),

        // ── Header row ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'account_enter_code_from_email'.tr(),
                  style: textStyles.h4SemiBold.copyWith(color: colors.foregroundDefault),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onCancel();
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: context.profileFieldFillColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.close, size: 16, color: colors.foregroundSoft),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // ── Subtitle ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_attemptsExhausted)
                Text(
                  'account_error_max_otp_attempts'.tr(),
                  style: textStyles.captionLargeRegular.copyWith(color: colors.errorDefault),
                )
              else
                Text(
                  'account_verify_email_instruction'.tr(),
                  style: textStyles.captionLargeRegular.copyWith(color: colors.foregroundMuted),
                ),
              const SizedBox(height: 2),
              Text(
                widget.pendingEmail,
                style: textStyles.captionLargeSemiBold.copyWith(color: colors.foregroundDefault),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── 4-box OTP display ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // OTP is always entered/displayed left-to-right, even in Arabic (RTL).
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (i) {
                final char = i < _otpValue.length ? _otpValue[i] : '';
                final isActive = i == _otpValue.length && _otpValue.length < 4;
                final boxError = hasError;

                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: context.profileFieldFillColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: boxError
                          ? colors.errorDefault
                          : isActive
                          ? colors.accentDefault
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    char,
                    style: textStyles.h3SemiBold.copyWith(color: colors.foregroundDefault),
                  ),
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ── "Get the code again" ──────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _isVerifying || !_canResend ? null : _handleResend,
              style: FilledButton.styleFrom(
                backgroundColor: colors.accentDefault,
                // Use the same visible surface as OTP fields — neutralContainerMuted
                // blends into the sheet in dark mode and hides the countdown label.
                disabledBackgroundColor: context.profileFieldFillColor,
                foregroundColor: colors.staticWhite,
                disabledForegroundColor: colors.foregroundDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_kFieldRadius),
                ),
              ),
              child: _isResending
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.staticWhite),
                      ),
                    )
                  : Text(
                      _secondsRemaining > 0
                          ? 'account_resend_code_in'.tr().replaceFirst('%s', _formattedCountdown)
                          : 'account_resend_code'.tr(),
                      style: textStyles.buttonM.copyWith(
                        color: _canResend ? colors.staticWhite : colors.foregroundDefault,
                      ),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ── Custom numpad ─────────────────────────────────────────────
        _NumPad(
          onDigit: _appendDigit,
          onDelete: _deleteDigit,
          onDone: isCodeComplete && !_isVerifying && !_attemptsExhausted ? _submit : null,
        ),

        SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
      ],
    );
  }
}

// ─── Custom NumPad ──────────────────────────────────────────────────────────

class _NumPad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onDelete;
  final VoidCallback? onDone;

  const _NumPad({
    required this.onDigit,
    required this.onDelete,
    this.onDone,
  });

  static const _subLabels = {
    '2': 'ABC',
    '3': 'DEF',
    '4': 'GHI',
    '5': 'JKL',
    '6': 'MNO',
    '7': 'PQRS',
    '8': 'TUV',
    '9': 'WXYZ',
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final borderSide = BorderSide(color: colors.borderSoft, width: 0.5);
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];

    // Numpad digits must stay LTR (1-2-3) even when the app locale is RTL.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: rows
            .map(
              (row) => IntrinsicHeight(
                child: Row(
                  children: row.map((key) {
                    final isDelete = key == '⌫';
                    final isEmpty = key == '';

                    return Expanded(
                      child: GestureDetector(
                        onTap: isEmpty
                            ? null
                            : isDelete
                            ? onDelete
                            : () => onDigit(key),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: isEmpty ? null : context.profileFieldFillColor,
                            border: Border(
                              top: borderSide,
                              right: borderSide,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: isEmpty
                              ? const SizedBox.shrink()
                              : isDelete
                              ? Icon(
                                  Icons.backspace_outlined,
                                  size: 20,
                                  color: colors.foregroundDefault,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      key,
                                      style: textStyles.h3Medium.copyWith(color: colors.foregroundDefault),
                                    ),
                                    if (_subLabels.containsKey(key))
                                      Text(
                                        _subLabels[key]!,
                                        style: textStyles.captionSmallMedium.copyWith(
                                          color: colors.foregroundMuted,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
