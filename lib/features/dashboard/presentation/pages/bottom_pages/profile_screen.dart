import 'dart:io';

import 'package:digital_wallett_system/app/routes/app_routes.dart';
import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/app/theme/theme_extensions.dart';
import 'package:digital_wallett_system/app/theme/theme_provider.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/core/utils/snackbar_utils.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/login_page.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:digital_wallett_system/features/bank/presentation/pages/load_from_bank_page.dart';
import 'package:digital_wallett_system/features/notifications/presentation/pages/notification_list_page.dart';
import 'package:digital_wallett_system/features/feedback/presentation/pages/share_feedback_page.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/presentation/pages/support_messages_page.dart';
import 'package:digital_wallett_system/features/terms/presentation/pages/terms_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/link_bank_page.dart';
import 'package:digital_wallett_system/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:digital_wallett_system/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:digital_wallett_system/features/dashboard/presentation/view_model/dashboard_viewmodel.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/profile/presentation/pages/editprofile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // const ProfileScreen({super.key});

  final List<XFile> _selectedMedia = [];
  int _imageVersion = DateTime.now().millisecondsSinceEpoch;
  // IMAGES, VIDEO
  final ImagePicker _imagePicker = ImagePicker();

  Future<bool> _askuserPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  String? _resolveProfileImageUrl(String? profilePicturePath) {
    if (profilePicturePath == null || profilePicturePath.trim().isEmpty) {
      return null;
    }
    final normalizedPath = profilePicturePath.trim().replaceAll('\\', '/');
    final url =
        normalizedPath.startsWith('http://') ||
            normalizedPath.startsWith('https://')
        ? normalizedPath
        : '${ApiEndpoints.imageBaseUrll}$normalizedPath';
    return '$url?v=$_imageVersion';
  }

  Future<void> _refreshProfileData() async {
    final userSession = ref.read(userSessionServiceProvider);
    setState(() {
      _imageVersion = DateTime.now().millisecondsSinceEpoch;
      _selectedMedia.clear();
    });
    try {
      final authDs = ref.read(authRemoteDatasourceProvider);
      if (authDs is AuthRemoteDatasource) {
        final freshUser = await authDs.getWhoami();
        if (freshUser != null) {
          await userSession.updateeProfile(
            fullName: freshUser.fullName,
            mobileNumber: freshUser.mobileNumber,
            profilePicture: freshUser.profilePicture,
          );
        }
      }
    } catch (_) {}
    if (mounted) {
      setState(() {});
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Give Permission "),
        content: Text("To use this feature go to permission settings "),
        actions: [
          TextButton(onPressed: () {}, child: Text('Cancel')),
          TextButton(onPressed: () {}, child: Text('Open Settings')),
        ],
      ),
    );
  }

  // code for camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _askuserPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(photo);
      });

      // upload image to server
      await ref
          .read(dashboardViewModelProvider.notifier)
          .uploadPhoto(File(photo.path));
      await _syncUploadedPhotoToSession();
    }
  }

  // code for gallery
  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );

        if (images.isNotEmpty) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.addAll(images);
          });
          //   // upload image to server
          // await ref
          //     .read(dashboardViewModelProvider.notifier)
          //     .uploadPhoto(File(images.path));
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.add(image);
          });
          // upload image to server
          await ref
              .read(dashboardViewModelProvider.notifier)
              .uploadPhoto(File(image.path));
          await _syncUploadedPhotoToSession();
          if (mounted) {
            setState(() {
              _imageVersion = DateTime.now().millisecondsSinceEpoch;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Gallery Error $e');

      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Cannot access your gallery. Please open the camera and take a photo',
        );
      }
    }
  }

  Future<void> _navigateToEditProfile() async {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    // );
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    if (!mounted) return;
    if (result is Map<String, dynamic>) {
      final userSession = ref.read(userSessionServiceProvider);
      await userSession.updateeProfile(
        fullName:
            result['fullName']?.toString() ??
            userSession.getCurrentUserFullName() ??
            'User',
        mobileNumber:
            result['mobileNumber']?.toString() ??
            userSession.getCurrentUserMobileNumber() ??
            '',
        profilePicture: result['profilePicture']?.toString(),
      );
    }
    await _refreshProfileData();
  }

  Future<void> _syncUploadedPhotoToSession() async {
    final dashboardState = ref.read(dashboardViewModelProvider);
    final imageName = dashboardState.uploadPhotoName;
    if (dashboardState.status != DashboardStatus.loaded ||
        imageName == null ||
        imageName.trim().isEmpty) {
      return;
    }

    final userSession = ref.read(userSessionServiceProvider);
    await userSession.updateeProfile(
      fullName: userSession.getCurrentUserFullName() ?? 'User',
      mobileNumber: userSession.getCurrentUserMobileNumber() ?? '',
      profilePicture: imageName,
    );
    if (mounted) {
      setState(() {
        _imageVersion = DateTime.now().millisecondsSinceEpoch;
      });
    }
  }

  // code for dialogBox : showDialog for menu
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.browse_gallery),
                title: Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.video_call),
              //   title: Text('Record Video'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickFromVideo();
              //   },
              // ),
              if (_selectedMedia.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete Picture',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedMedia.clear(); // remove the image/video
                    });
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userSession = ref.read(userSessionServiceProvider);
    final String userName = userSession.getCurrentUserFullName() ?? 'User';
    final String mobileNumber = userSession.getCurrentUserMobileNumber() ?? '';
    final profileImagePath = userSession.getCurrentUserProfilePicture();
    final profileImageUrl = _resolveProfileImageUrl(profileImagePath);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------------- HEADER ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 32),
                decoration: const BoxDecoration(
                  gradient: AppColors.thiirdGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: GestureDetector(
                        onTap: _pickMedia, //  open camera/gallery
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,

                            // IMAGE HERE
                            backgroundImage: _selectedMedia.isNotEmpty
                                ? FileImage(File(_selectedMedia.first.path))
                                : (profileImageUrl != null
                                      ? NetworkImage(profileImageUrl)
                                      : null),

                            // FALLBACK LETTER
                            child:
                                _selectedMedia.isEmpty &&
                                    profileImageUrl == null
                                ? Text(
                                    userName[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),

                      // CircleAvatar(
                      //   radius: 56,
                      //   backgroundColor: Colors.white,
                      //   child: Text(
                      //     userName[0],
                      //     style: const TextStyle(
                      //       fontSize: 40,
                      //       fontWeight: FontWeight.bold,
                      //       color: AppColors.primary,
                      //     ),
                      //   ),
                      // ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      mobileNumber,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- MENU ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {
                        _navigateToEditProfile();
                      },
                    ),
                    const SizedBox(height: 12),

                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationListPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    _MenuItem(
                      icon: Icons.account_balance_outlined,
                      title: 'Link bank account',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LinkBankPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    _MenuItem(
                      icon: Icons.savings_outlined,
                      title: 'Load from bank (by account)',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoadFromBankPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    _MenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms & conditions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    _MenuItem(
                      icon: Icons.support_agent_outlined,
                      title: 'Report Problem',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SupportMessagesPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuItem(
                      icon: Icons.feedback_outlined,
                      title: 'Share feedback',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ShareFeedbackPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    _ThemeToggleItem(ref: ref),
                    const SizedBox(height: 12),
                    _LightSensorThemeToggleItem(ref: ref),
                    const SizedBox(height: 12),

                    _MenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      iconColor: AppColors.error,
                      titleColor: AppColors.error,
                      onTap: () {
                        _showLogoutDialog(context, ref);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 12, color: context.textSecondary60),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- LOGOUT DIALOG ----------------
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                AppRoutes.pushAndRemoveUntil(context, const LoginPage());
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- MENU ITEM ----------------
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.cardShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withAlpha(
                    (0.1 * 255).toInt(),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor ?? AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? context.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: context.textSecondary50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- THEME TOGGLE ----------------
class _ThemeToggleItem extends StatelessWidget {
  final WidgetRef ref;

  const _ThemeToggleItem({required this.ref});

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    isDark ? 'On' : 'Off',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isDark,
              onChanged: (value) {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              },
              activeTrackColor: AppColors.primary,
              activeThumbColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _LightSensorThemeToggleItem extends StatelessWidget {
  final WidgetRef ref;

  const _LightSensorThemeToggleItem({required this.ref});

  @override
  Widget build(BuildContext context) {
    final isEnabled = ref.watch(lightSensorThemeEnabledProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.wb_sunny_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Light Sensor Auto Theme',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    isEnabled ? 'On' : 'Off',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: (value) {
                ref
                    .read(lightSensorThemeEnabledProvider.notifier)
                    .setEnabled(value);
              },
              activeTrackColor: AppColors.primary,
              activeThumbColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
