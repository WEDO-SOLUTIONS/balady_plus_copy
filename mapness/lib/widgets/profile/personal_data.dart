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
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/profile/profile_account_service.dart';

/// Pill radius for fields / buttons (matches existing layout; not all tokens expose radius).
const _kFieldRadius = 10.0;

/// Flip to `true` when profile edit, save, and email OTP flows are enabled in this build.
const kPersonalDataShowImpl = false;

class PersonalData extends ConsumerStatefulWidget {
  final SsoUserInfo userInfo;

  /// When `false`, all fields are read-only: no text inputs, save button, or OTP sheet.
  final bool showImpl;

  const PersonalData({
    required this.userInfo,
    this.showImpl = kPersonalDataShowImpl,
    super.key,
  });

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
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;

  String _activeEmail = '';
  String? _pendingEmail;
  String _initialFirstName = '';
  String _initialLastName = '';
  String _currentFirstName = '';
  String _currentLastName = '';

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
    _pendingEmail = null;
    _errorText = null;

    print('📱 Loaded user data - Email: $_activeEmail, isEmailVerified: $_isEmailVerified');
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
      var freshUserInfo = SsoUserInfo.fromJson(userInfoJson).copyWith(
        completeProfile: previousAuth?.completeProfile ?? widget.userInfo.completeProfile,
        loginType: previousAuth?.loginType ?? widget.userInfo.loginType,
        isEmailEditable: previousAuth?.isEmailEditable ?? widget.userInfo.isEmailEditable,
        isSSOLocked: previousAuth?.isSSOLocked ?? widget.userInfo.isSSOLocked,
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isSsoUser => widget.userInfo.loginType == SsoLoginType.nationalId;

  bool get _isOtpUser => widget.userInfo.loginType == SsoLoginType.otp;

  /// Returned by `MobileLoginVerifyOtp`:
  /// - `true`  → user signed up via OTP only → editing allowed.
  /// - `false` → user already has an SSO/Nafath account → profile is owned by SSO,
  ///   so editing must be blocked even though they logged in via OTP.
  bool get _hasCompleteOtpProfile => widget.userInfo.completeProfile;

  bool get _canEditProfile => widget.showImpl && _isOtpUser && _hasCompleteOtpProfile;

  bool get _canEditEmail => widget.showImpl && _isOtpUser && _hasCompleteOtpProfile && widget.userInfo.isEmailEditable;

  /// True when first name, last name, or email differs from the last saved values.
  bool _hasUnsavedChanges() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final nameChanged = first != _currentFirstName || last != _currentLastName;
    final emailChanged = email != _activeEmail;
    return nameChanged || emailChanged;
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
    if (!widget.showImpl) return;
    if (!_validateForm()) return;

    final newFirstName = _firstNameController.text.trim();
    final newLastName = _lastNameController.text.trim();
    final newEmail = _emailController.text.trim();
    final emailChanged = newEmail != _activeEmail;
    final nameChanged = newFirstName != _currentFirstName || newLastName != _currentLastName;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      if ((nameChanged && _canEditProfile) || (emailChanged && _canEditEmail)) {
        final completeProfileData = <String, dynamic>{
          'firstname': newFirstName,
          'lastname': newLastName,
        };
        if (!emailChanged) completeProfileData['email'] = _activeEmail;

        await _service.updateUserProfile(changes: completeProfileData);
        // Avoid auth-provider rebuild while opening the OTP sheet (can dispose this widget).
        await _fetchLatestUserInfo(
          updateAuthProvider: !emailChanged,
          overrideFirstName: nameChanged ? newFirstName : null,
          overrideLastName: nameChanged ? newLastName : null,
        );

        setState(() {
          _currentFirstName = newFirstName;
          _currentLastName = newLastName;
          _initialFirstName = newFirstName;
          _initialLastName = newLastName;
          if (!emailChanged) {
            _activeEmail = newEmail;
            _emailController.text = _activeEmail;
          } else {
            // `_fetchLatestUserInfo` just ran and filled the field from the API,
            // which still has the previous email (or none). Restore what the user typed.
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
        final sessionId = await _service.sendVerificationEmail(newEmail);
        if (!mounted) return;
        setState(() {
          _sessionId = sessionId;
          _otpPending = true;
          _pendingEmail = newEmail;
          _isEmailVerified = false;
          _errorText = null;
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('verification_code_sent'.tr())),
          );
          _showOtpBottomSheet();
        });
      } else if (!emailChanged && nameChanged) {
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
        resendAttemptsLeft: _resendAttemptsLeft,
      ),
    ).then((_) {
      if (_otpPending && mounted) _cancelOtpVerification();
    });
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
      final code = e.response?.statusCode;
      final msg = code == 409
          ? 'account_error_wait_before_resend'.tr()
          : code == 429
          ? 'account_error_too_many_requests'.tr()
          : (e.message ?? 'account_error_resend_failed'.tr());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      setState(() => _isLoading = false);
    } catch (_) {
      setState(() {
        _errorText = 'account_error_resend_failed'.tr();
        _isLoading = false;
      });
    }
  }

  void _cancelOtpVerification() {
    final emailToKeep = _pendingEmail ?? _emailController.text.trim();
    setState(() {
      _otpPending = false;
      _pendingEmail = null;
      _sessionId = null;
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

  // ─── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final language = ref.read(appLanguageProvider);
    final userInfo = widget.userInfo;
    final isSso = _isSsoUser;
    final isOtp = _isOtpUser;
    final colors = context.colors;
    final textStyles = context.textStyles;

    final hasFieldErrors = _firstNameError != null || _lastNameError != null || _emailError != null;
    final hasChanges = _hasUnsavedChanges();
    // When saving, use a no-op onPressed so the button stays in the "enabled" style;
    // `onPressed: null` would apply disabled styling and fade the white saving text.

    return Stack(
      children: [
        // ── Scrollable content ────────────────────────────────────────
        SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 20,
            bottom: widget.showImpl ? MediaQuery.of(context).size.height - 500 : 20,
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
                // ── First Name ────────────────────────────────────
                _buildLabel(context, 'account_first_name'.tr()),
                const SizedBox(height: 6),
                if (isOtp && _canEditProfile) ...[
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
                  _buildReadOnlyPill(context, userInfo.getLocalizedFirstName(language)),

                const SizedBox(height: 16),

                // ── Last Name ─────────────────────────────────────
                _buildLabel(context, 'account_last_name'.tr()),
                const SizedBox(height: 6),
                if (isOtp && _canEditProfile) ...[
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
                  _buildReadOnlyPill(context, userInfo.getLocalizedLastName(language)),

                const SizedBox(height: 16),

                // ── Gender + Date of Birth (SSO) ──────────────────
                if (isSso) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userInfo.sex != null)
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, 'account_gender'.tr()),
                              const SizedBox(height: 6),
                              _GenderToggle(
                                selected: int.tryParse(userInfo.sex ?? '') ?? 0,
                              ),
                            ],
                          ),
                        ),

                      if ((userInfo.sex != null && userInfo.sex!.isNotEmpty) &&
                          (userInfo.dob != null && userInfo.dob!.isNotEmpty))
                        const SizedBox(width: 12),

                      if (userInfo.dob != null && userInfo.dob!.isNotEmpty)
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, 'date_of_birth'.tr()),
                              const SizedBox(height: 6),
                              _buildReadOnlyPill(context, userInfo.dob!),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Email ─────────────────────────────────────────
                _buildLabel(context, 'account_email'.tr()),
                const SizedBox(height: 6),
                if (isOtp && _canEditEmail) ...[
                  _buildPillField(
                    context,
                    controller: _emailController,
                    hintText: 'emailFieldHint'.tr(),
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                    onChanged: (_) {
                      final email = _emailController.text.trim();
                      setState(() {
                        _emailError = email.isNotEmpty && !_isValidEmail(email)
                            ? 'account_error_email_format'.tr()
                            : null;
                      });
                    },
                  ),
                  if (_emailError != null) _buildErrorText(context, _emailError!),
                  if (!_otpPending) ...[
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
                  ],
                ] else ...[
                  Row(
                    children: [
                      Expanded(child: _buildReadOnlyPill(context, userInfo.mail ?? '')),
                      if (isOtp) ...[
                        const SizedBox(width: 8),
                        Icon(
                          _isEmailVerified ? Icons.check_circle : Icons.warning_amber_rounded,
                          color: _isEmailVerified ? colors.successDefault : colors.warningDefault,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ],

                // ── SSO extra fields ──────────────────────────────
                if (isSso) ...[
                  if (userInfo.arName != null && userInfo.arName!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildLabel(context, 'arabicFullName'.tr()),
                    const SizedBox(height: 6),
                    _buildReadOnlyPill(context, userInfo.arName!),
                  ],
                  if (userInfo.enName != null && userInfo.enName!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildLabel(context, 'englishFullName'.tr()),
                    const SizedBox(height: 6),
                    _buildReadOnlyPill(context, userInfo.enName!),
                  ],
                  if (userInfo.nationality != null && userInfo.nationality!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildLabel(context, 'nationality'.tr()),
                    const SizedBox(height: 6),
                    _buildReadOnlyPill(context, userInfo.nationality!),
                  ],
                ],

                // ── Global error ──────────────────────────────────
                if (_errorText != null && _errorText!.isNotEmpty) ...[
                  const SizedBox(height: 12),
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

  const _GenderToggle({required this.selected});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: ['M', 'F'].map((g) {
        final isSelected = (g == 'M' && selected == 1) || (g == 'F' && selected == 2);
        return Padding(
          padding: const EdgeInsets.only(right: 6),
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
  final VoidCallback onResend;
  final VoidCallback onCancel;
  final int resendAttemptsLeft;

  const OtpBottomSheetWidget({
    super.key,
    required this.pendingEmail,
    required this.onVerify,
    required this.onResend,
    required this.onCancel,
    this.resendAttemptsLeft = 3,
  });

  @override
  State<OtpBottomSheetWidget> createState() => _OtpBottomSheetWidgetState();
}

class _OtpBottomSheetWidgetState extends State<OtpBottomSheetWidget> {
  String _otpValue = '';
  bool _isVerifying = false;
  int _failureCount = 0;

  bool get _hasError => _failureCount > 0;
  bool get _showResendHint => _failureCount >= 1;

  Future<void> _submit() async {
    if (_isVerifying || _otpValue.length != 4) return;

    setState(() => _isVerifying = true);
    final success = await widget.onVerify(_otpValue);
    if (!mounted) return;

    if (success) {
      // Parent will pop the sheet on success; nothing else to do.
      setState(() => _isVerifying = false);
      return;
    }

    // Wrong / expired OTP → clear the boxes, mark error, let user retry.
    setState(() {
      _isVerifying = false;
      _failureCount++;
      _otpValue = '';
    });
  }

  void _appendDigit(String d) {
    if (_isVerifying || _otpValue.length >= 4) return;
    setState(() {
      _otpValue += d;
      // Clear previous error styling once the user starts typing again.
      if (_failureCount > 0 && _otpValue.length == 1) {
        _failureCount = 0;
      }
    });
    if (_otpValue.length == 4) {
      _submit();
    }
  }

  void _deleteDigit() {
    if (_isVerifying) return;
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
              if (_showResendHint && widget.resendAttemptsLeft > 0)
                Text(
                  'account_resend_attempts'.tr().replaceFirst(
                    '%s',
                    context.digits('${widget.resendAttemptsLeft}'),
                  ),
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

        const SizedBox(height: 20),

        // ── "Get the code again" ──────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _isVerifying || widget.resendAttemptsLeft <= 0 ? null : widget.onResend,
              style: FilledButton.styleFrom(
                backgroundColor: colors.accentDefault,
                disabledBackgroundColor: colors.neutralContainerMuted,
                foregroundColor: colors.accentOnAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_kFieldRadius),
                ),
              ),
              child: _isVerifying
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.accentOnAccent),
                      ),
                    )
                  : Text(
                      'account_resend_code'.tr(),
                      style: textStyles.buttonM.copyWith(color: colors.accentOnAccent),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ── Custom numpad ─────────────────────────────────────────────
        _NumPad(
          onDigit: _appendDigit,
          onDelete: _deleteDigit,
          onDone: isCodeComplete && !_isVerifying ? _submit : null,
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

    return Column(
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
    );
  }
}
