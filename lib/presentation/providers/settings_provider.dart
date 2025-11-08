import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munchups_app/domain/entities/app_content_entity.dart';
import 'package:munchups_app/domain/entities/faq_entity.dart';
import 'package:munchups_app/domain/usecases/data/change_password_usecase.dart';
import 'package:munchups_app/domain/usecases/data/fetch_app_content_usecase.dart';
import 'package:munchups_app/domain/usecases/data/fetch_faq_content_usecase.dart';
import 'package:munchups_app/domain/usecases/data/submit_contact_usecase.dart';
import 'package:munchups_app/domain/usecases/data/update_profile_usecase.dart';
import 'package:munchups_app/core/usecases/usecase.dart';

class SettingsProvider extends ChangeNotifier {
  final FetchAppContentUseCase fetchAppContentUseCase;
  final FetchFaqContentUseCase fetchFaqContentUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final SubmitContactUseCase submitContactUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  SettingsProvider({
    required this.fetchAppContentUseCase,
    required this.fetchFaqContentUseCase,
    required this.changePasswordUseCase,
    required this.submitContactUseCase,
    required this.updateProfileUseCase,
  });

  AppContentEntity? _content;
  FaqEntity? _faq;

  bool _isContentLoading = false;
  bool _isFaqLoading = false;
  bool _isSubmitting = false;

  String _contentError = '';
  String _faqError = '';
  String _submitError = '';
  String _submitMessage = '';

  AppContentEntity? get content => _content;
  FaqEntity? get faq => _faq;

  bool get isContentLoading => _isContentLoading;
  bool get isFaqLoading => _isFaqLoading;
  bool get isSubmitting => _isSubmitting;

  String get contentError => _contentError;
  String get faqError => _faqError;
  String get submitError => _submitError;
  String get submitMessage => _submitMessage;

  Future<void> loadContent({bool forceRefresh = false}) async {
    if (_content != null && !forceRefresh) return;

    _isContentLoading = true;
    _contentError = '';
    notifyListeners();

    try {
      final result = await fetchAppContentUseCase(NoParams());
      result.fold(
        (failure) => _contentError = failure.message,
        (entity) => _content = entity,
      );
    } catch (e) {
      _contentError = e.toString();
    } finally {
      _isContentLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFaq({bool forceRefresh = false}) async {
    if (_faq != null && !forceRefresh) return;

    _isFaqLoading = true;
    _faqError = '';
    notifyListeners();

    try {
      final result = await fetchFaqContentUseCase(NoParams());
      result.fold(
        (failure) => _faqError = failure.message,
        (entity) => _faq = entity,
      );
    } catch (e) {
      _faqError = e.toString();
    } finally {
      _isFaqLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(Map<String, dynamic> body) async {
    _isSubmitting = true;
    _submitError = '';
    _submitMessage = '';
    notifyListeners();

    try {
      final result = await changePasswordUseCase(body);
      return result.fold((failure) {
        _submitError = failure.message;
        return false;
      }, (response) {
        _submitMessage = response['msg']?.toString() ?? 'Password updated';
        return true;
      });
    } catch (e) {
      _submitError = e.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> submitContact(Map<String, dynamic> body) async {
    _isSubmitting = true;
    _submitError = '';
    _submitMessage = '';
    notifyListeners();

    try {
      final result = await submitContactUseCase(body);
      return result.fold((failure) {
        _submitError = failure.message;
        return false;
      }, (response) {
        _submitMessage = response['msg']?.toString() ?? 'Submitted';
        return true;
      });
    } catch (e) {
      _submitError = e.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(UpdateProfileParams params) async {
    _isSubmitting = true;
    _submitError = '';
    _submitMessage = '';
    notifyListeners();

    try {
      final result = await updateProfileUseCase(params);
      return result.fold((failure) {
        _submitError = failure.message;
        return false;
      }, (response) {
        _submitMessage = response['msg']?.toString() ?? 'Profile updated';
        return true;
      });
    } catch (e) {
      _submitError = e.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearSubmitState() {
    _submitError = '';
    _submitMessage = '';
    notifyListeners();
  }
}
