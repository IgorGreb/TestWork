import 'dart:io';

import 'package:chick_game_prototype/app_layout/back_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/chick_layout.dart';
import 'package:chick_game_prototype/app_layout/menu_btn_layout.dart';
import 'package:chick_game_prototype/app_layout/text_field_layout.dart';
import 'package:chick_game_prototype/core/constants/custom_colors.dart';
import 'package:chick_game_prototype/features/profile/profile_controller.dart';
import 'package:chick_game_prototype/features/profile/profile_state.dart';
import 'package:chick_game_prototype/screens/start_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
          height: 160,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  takePhoto();
                },
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

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final bool adaptForIphone =
        Theme.of(context).platform == TargetPlatform.iOS && screenHeight < 750;

    final double cardWidthFactor = adaptForIphone ? 0.92 : 0.85;
    final double avatarRadius = adaptForIphone ? 38 : 45;
    final double titleFontSize = screenWidth * (adaptForIphone ? 0.06 : 0.07);

    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: ChickLayout(
        chickShow: 0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compactHeight = constraints.maxHeight < 700;
            final spacing =
                compactHeight ? screenHeight * 0.015 : screenHeight * 0.025;

            Widget content;

            if (profileState.isLoading) {
              content = const Center(child: CircularProgressIndicator());
            } else {
              content = Container(
                width: screenWidth * (compactHeight ? 0.95 : cardWidthFactor),
                decoration: BoxDecoration(
                  color: CustomColors.some.withOpacity(0.5),
                  border: Border.all(color: CustomColors.pink, width: 2),
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  image: const DecorationImage(
                    image: AssetImage('assets/info_webp/Rectangle 7.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: spacing,
                  horizontal: screenWidth * 0.04,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PROFILE',
                      style: GoogleFonts.rubikMonoOne(
                        fontSize: titleFontSize,
                        color: Colors.white,
                      ),
                    ),

                    /// Avatar
                    GestureDetector(
                      onTap: _showAvatarSourceSheet,
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.white24,
                        backgroundImage: _buildAvatarImage(
                          profileState.imagePath,
                        ),
                        child:
                            profileState.imagePath == null
                                ? const Icon(
                                  Icons.person,
                                  size: 45,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                    ),

                    SizedBox(height: spacing),

                    /// Avatar asset picker
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (context, index) {
                          final asset = _avatarAssets[index];
                          final isSelected =
                              profileState.imagePath ==
                              '${ProfileController.assetPrefix}$asset';

                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(profileControllerProvider.notifier)
                                  .selectAvatarAsset(asset);
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage(asset),
                              child:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: _avatarAssets.length,
                      ),
                    ),

                    TextFieldLayout(
                      text: 'Username',
                      controller: usernameController,
                      width: double.infinity,
                    ),

                    TextFieldLayout(
                      text: 'Email',
                      controller: emailController,
                      width: double.infinity,
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackBtnLayout(onPressed: _handleBackNavigation),
                  ),
                  SizedBox(height: spacing),
                  Expanded(child: Center(child: content)),
                  SizedBox(height: spacing),
                  MenuBtnLayout(
                    btnText: 'SAVE',
                    routeName: '',
                    onTapOverride: _saveData,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
