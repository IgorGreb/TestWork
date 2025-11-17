import 'dart:io';

import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/app_layout/text_field_layout.dart';
import 'package:chick_game_prototype/features/profile/profile_controller.dart';
import 'package:chick_game_prototype/features/profile/profile_state.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:chick_game_prototype/widgets/start_btn_widget.dart';
import 'package:chick_game_prototype/widgets/flame_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const List<String> _avatarAssets = [
    'assets/chick_webp/chick.webp',
    'assets/chick_webp/little_chick.webp',
    'assets/profile_webp/profile.webp',
  ];

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  ProviderSubscription<ProfileState>? _profileSubscription;

  @override
  void initState() {
    super.initState();

    final initialState = ref.read(profileControllerProvider);
    usernameController.text = initialState.username;
    emailController.text = initialState.email;

    _profileSubscription = ref.listenManual(profileControllerProvider, (
      previous,
      next,
    ) {
      if (usernameController.text != next.username) {
        usernameController.text = next.username;
      }
      if (emailController.text != next.email) {
        emailController.text = next.email;
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    _profileSubscription?.close();
    super.dispose();
  }

  Future<void> _saveData() async {
    final notifier = ref.read(profileControllerProvider.notifier);
    final success = await notifier.saveProfile(
      username: usernameController.text,
      email: emailController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Saved!' : 'Something went wrong, try again.'),
      ),
    );
  }

  Future<void> pickImage() async => _handleImageSelection(ImageSource.gallery);

  Future<void> takePhoto() async => _handleImageSelection(ImageSource.camera);

  Future<void> _handleImageSelection(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    final success = await ref
        .read(profileControllerProvider.notifier)
        .updateProfileImage(pickedFile);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update photo. Try again.')),
      );
    }
  }

  Future<bool> _handleBackNavigation() async {
    if (!mounted) return false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StartGameScreen()),
    );

    return false;
  }

  void _showAvatarSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1F),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PLEASE MAKE YOUR CHOICE',
                style: TextStyle(color: Colors.white, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              _BottomSheetButton(
                label: 'MAKE A PHOTO',
                onPressed: () {
                  Navigator.pop(context);
                  takePhoto();
                },
              ),
              const SizedBox(height: 10),
              _BottomSheetButton(
                label: 'CHOOSE PHOTO',
                onPressed: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
              const SizedBox(height: 10),
              _BottomSheetButton(
                label: 'CANCEL',
                filled: false,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider? _buildAvatarImage(String? storedPath) {
    if (storedPath == null) return null;

    if (storedPath.startsWith(ProfileController.assetPrefix)) {
      final assetPath = storedPath.substring(
        ProfileController.assetPrefix.length,
      );
      return AssetImage(assetPath);
    }

    final file = File(storedPath);
    if (file.existsSync()) return FileImage(file);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: ChickLayout(
        chickShow: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackBtnLayout(onPressed: _handleBackNavigation),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child:
                      profileState.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : FlamePanel(
                            title: 'PROFILE',
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _showAvatarSourceSheet,
                                    child: CircleAvatar(
                                      radius: 48,
                                      backgroundColor: Colors.white24,
                                      backgroundImage: _buildAvatarImage(
                                        profileState.imagePath,
                                      ),
                                      child:
                                          profileState.imagePath == null
                                              ? const Icon(
                                                Icons.person,
                                                size: 48,
                                                color: Colors.white,
                                              )
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 90,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final asset = _avatarAssets[index];
                                        final isSelected =
                                            profileState.imagePath ==
                                            '${ProfileController.assetPrefix}$asset';
                                        return GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(
                                                  profileControllerProvider
                                                      .notifier,
                                                )
                                                .selectAvatarAsset(asset);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? Colors.yellowAccent
                                                        : Colors.transparent,
                                                width: 3,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 32,
                                              backgroundImage: AssetImage(
                                                asset,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (_, __) => const SizedBox(width: 12),
                                      itemCount: _avatarAssets.length,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFieldLayout(
                                    text: 'Username',
                                    controller: usernameController,
                                    width: double.infinity,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFieldLayout(
                                    text: 'Email',
                                    controller: emailController,
                                    width: double.infinity,
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
                const SizedBox(height: 16),
                StartBtnWidget(
                  label: 'Save',
                  widthFactor: 0.6,
                  heightFactor: 0.13,
                  fontFactor: 0.08,
                  onPressed: _saveData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomSheetButton extends StatelessWidget {
  const _BottomSheetButton({
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: filled ? Colors.white : Colors.transparent,
          side:
              filled
                  ? BorderSide.none
                  : const BorderSide(color: Colors.white, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
