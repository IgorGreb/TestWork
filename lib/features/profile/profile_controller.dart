import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_state.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
      final controller = ProfileController();
      controller.loadProfile(); // Ліниво підтягуємо збережені дані після створення провайдера.
      return controller;
    });

class ProfileController extends StateNotifier<ProfileState> {
  static const assetPrefix = 'asset::';
  ProfileController() : super(const ProfileState());

  SharedPreferences? _prefs;
  String? _documentsPath; // Кешований шлях до директорії Documents цього застосунку.

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    final prefs = await _ensurePrefs();
    final username = prefs.getString('username') ?? '';
    final email = prefs.getString('email') ?? '';
    final storedImageName = prefs.getString('profile_image');
    String? resolvedImagePath;
    if (storedImageName != null) {
      if (storedImageName.startsWith(assetPrefix)) {
        resolvedImagePath = storedImageName;
      } else {
        // У налаштуваннях зберігаємо лише ім'я файлу, а повний шлях добудовуємо під час читання.
        final path = await _resolveImagePath(storedImageName);
        if (path != null && await File(path).exists()) {
          resolvedImagePath = path;
        } else {
          await prefs.remove('profile_image');
        }
      }
    }

    state = state.copyWith(
      username: username,
      email: email,
      imagePath: resolvedImagePath,
      isLoading: false,
    );
  }

  Future<bool> saveProfile({
    required String username,
    required String email,
  }) async {
    state = state.copyWith(isProcessing: true);
    try {
      final prefs = await _ensurePrefs();
      await prefs.setString('username', username);
      await prefs.setString('email', email);

      state = state.copyWith(
        username: username,
        email: email,
        isProcessing: false,
      );
      return true;
    } catch (_) {
      state = state.copyWith(isProcessing: false);
      return false;
    }
  }

  Future<bool> updateProfileImage(XFile pickedFile) async {
    state = state.copyWith(isProcessing: true);
    try {
      final savedImage = await _saveImageLocally(pickedFile);
      if (savedImage == null) {
        state = state.copyWith(isProcessing: false);
        return false;
      }

      final prefs = await _ensurePrefs();
      final previousPath = prefs.getString('profile_image');
      if (previousPath != null && previousPath != savedImage.fileName) {
        // Якщо користувач змінив фото — чистимо попередній файл з Documents.
        final oldResolvedPath = await _resolveImagePath(previousPath);
        if (oldResolvedPath != null) {
          final oldFile = File(oldResolvedPath);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        }
      }

      await prefs.setString('profile_image', savedImage.fileName);
      state = state.copyWith(
        imagePath: savedImage.fullPath,
        isProcessing: false,
      );
      return true;
    } catch (_) {
      state = state.copyWith(isProcessing: false);
      return false;
    }
  }

  Future<_SavedImage?> _saveImageLocally(XFile file) async {
    try {
      final directoryPath = await _documentsDirectoryPath();
      final extension =
          file.name.contains('.')
              ? file.name.substring(file.name.lastIndexOf('.'))
              : '';
      final fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}$extension';
      final newPath = p.join(directoryPath, fileName);
      final newFile = await File(file.path).copy(newPath);
      return _SavedImage(fileName: fileName, fullPath: newFile.path);
    } catch (_) {
      return null;
    }
  }

  Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance(); // Щоб не створювати новий екземпляр щоразу.
    return _prefs!;
  }

  Future<String> _documentsDirectoryPath() async {
    if (_documentsPath != null) {
      return _documentsPath!;
    }
    final directory = await getApplicationDocumentsDirectory();
    _documentsPath = directory.path;
    return _documentsPath!;
  }

  Future<String?> _resolveImagePath(String fileName) async {
    if (fileName.startsWith(assetPrefix)) {
      return fileName;
    }
    final directoryPath = await _documentsDirectoryPath();
    return p.join(directoryPath, fileName);
  }

  Future<void> selectAvatarAsset(String assetPath) async {
    final prefs = await _ensurePrefs();
    final storedValue = '$assetPrefix$assetPath';
    await prefs.setString('profile_image', storedValue);
    state = state.copyWith(imagePath: storedValue);
  }
}

class _SavedImage {
  final String fileName;
  final String fullPath;

  const _SavedImage({required this.fileName, required this.fullPath});
}
