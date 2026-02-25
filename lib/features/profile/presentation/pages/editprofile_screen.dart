import 'dart:io';
import 'package:digital_wallett_system/app/routes/app_routes.dart';
import 'package:digital_wallett_system/app/theme/app_colors.dart';
import 'package:digital_wallett_system/app/theme/theme_extensions.dart';
import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileNumberController;

  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  int _imageVersion = DateTime.now().millisecondsSinceEpoch;

  void _showSuccessToast(String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        left: 24,
        right: 24,
        bottom: 80,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  String? _resolveProfileImageUrl(String? profilePicturePath) {
    if (profilePicturePath == null || profilePicturePath.trim().isEmpty) {
      return null;
    }
    final path = profilePicturePath.trim().replaceAll('\\', '/');
    final baseUrl = path.startsWith('http://') || path.startsWith('https://')
        ? path
        : '${ApiEndpoints.imageBaseUrll}$path';
    return '$baseUrl?v=$_imageVersion';
  }

  @override
  void initState() {
    super.initState();
    final userSession = ref.read(userSessionServiceProvider);

    // Initialize controllers with current data
    _nameController = TextEditingController(
      text: userSession.getCurrentUserFullName() ?? "",
    );
    _mobileNumberController = TextEditingController(
      text: userSession.getCurrentUserMobileNumber() ?? "",
    );

    // Re-render avatar if name changes (for initials)
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  // --- IMAGE PICKING LOGIC ---

  Future<void> _showPickOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Profile Photo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _handleImagePick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _handleImagePick(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImagePick(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = Platform.isAndroid
          ? await Permission.photos.request()
          : await Permission.photos.request();
    }

    if (status.isGranted || status.isLimited) {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageVersion = DateTime.now().millisecondsSinceEpoch;
        });
      }
    } else {
      _showSettingsDialog();
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Please enable permissions in settings to change your photo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(onPressed: openAppSettings, child: const Text('Settings')),
        ],
      ),
    );
  }

  // --- SAVE LOGIC ---

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final userSession = ref.read(userSessionServiceProvider);
    try {
      final apiClient = ref.read(apiClientProvider);
      String? uploadedProfilePath;

      // Upload image via dedicated endpoint. This is the path your backend
      // usually persists as imageUrl.
      if (_imageFile != null) {
        final uploadFormData = FormData.fromMap({
          'profilePhoto': await MultipartFile.fromFile(
            _imageFile!.path,
            filename: _imageFile!.path.split('/').last,
          ),
        });
        try {
          final uploadResponse = await apiClient.uploadFile(
            ApiEndpoints.profileUploadPhoto,
            formData: uploadFormData,
            options: Options(contentType: 'multipart/form-data'),
          );
          final uploadData = uploadResponse.data;
          if (uploadData is Map<String, dynamic>) {
            final dynamic inner = uploadData['data'];
            if (inner is String) {
              uploadedProfilePath = inner;
            } else if (inner is Map<String, dynamic>) {
              uploadedProfilePath =
                  (inner['imageUrl'] ??
                          inner['profilePhoto'] ??
                          inner['profilePicture'] ??
                          inner['path'] ??
                          inner['image'])
                      ?.toString();
            }
          }
        } catch (_) {}
      }

      // Build multipart form exactly like Postman/backend contract.
      final Map<String, dynamic> data = {
        "name": _nameController.text.trim(),
        "fullName": _nameController.text.trim(),
        "mobileNumber": _mobileNumberController.text.trim(),
      };
      if (uploadedProfilePath != null && uploadedProfilePath.isNotEmpty) {
        data['imageUrl'] = uploadedProfilePath;
      }
      Future<FormData> buildFormData() async {
        final map = Map<String, dynamic>.from(data);
        if (_imageFile != null) {
          map['profilePhoto'] = await MultipartFile.fromFile(
            _imageFile!.path,
            filename: _imageFile!.path.split('/').last,
          );
        }
        return FormData.fromMap(map);
      }

      // API Call with fallback endpoints/methods.
      Response<dynamic>? response;
      final userId = userSession.getCurrentUserId();
      final endpoints = <String>[
        '/user/auth/update-profile',
        '/user/auth/updateProfile',
        if (userId != null && userId.isNotEmpty)
          '/user/auth/update-profile/$userId',
        if (userId != null && userId.isNotEmpty)
          '/user/auth/updateProfile/$userId',
      ];
      final methods = <String>['PUT', 'PATCH'];
      final multipartOptions = Options(contentType: 'multipart/form-data');

      for (final endpoint in endpoints) {
        for (final method in methods) {
          try {
            response = method == 'PUT'
                ? await apiClient.put(
                    endpoint,
                    data: await buildFormData(),
                    options: multipartOptions,
                  )
                : await apiClient.dio.patch(
                    endpoint,
                    data: await buildFormData(),
                    options: multipartOptions,
                  );
            break;
          } on DioException catch (e) {
            if (e.response?.statusCode == 404 ||
                e.response?.statusCode == 405) {
              continue;
            }
            rethrow;
          }
        }
        if (response != null) break;
      }

      if (response == null) {
        // If profile route is missing but image upload succeeded, still sync UI/session.
        if (uploadedProfilePath != null && uploadedProfilePath.isNotEmpty) {
          await userSession.updateeProfile(
            fullName: _nameController.text.trim(),
            mobileNumber: _mobileNumberController.text.trim(),
            profilePicture: uploadedProfilePath,
          );
          if (mounted) {
            setState(() {
              _imageVersion = DateTime.now().millisecondsSinceEpoch;
            });
            _showSuccessToast('Profile photo updated');
            Navigator.pop(context, {
              'fullName': _nameController.text.trim(),
              'mobileNumber': _mobileNumberController.text.trim(),
              'profilePicture': uploadedProfilePath,
            });
          }
          return;
        }
        throw DioException(
          requestOptions: RequestOptions(path: endpoints.join(', ')),
          message: 'Update profile endpoint not found on server',
        );
      }

      if (response.statusCode == 200) {
        final responseData = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};
        final updatedUser = responseData['data'] is Map<String, dynamic>
            ? responseData['data'] as Map<String, dynamic>
            : responseData;

        String fullName =
            (updatedUser['fullName'] ?? updatedUser['name'])?.toString() ??
            _nameController.text.trim();
        String mobileNumber =
            updatedUser['mobileNumber']?.toString() ??
            _mobileNumberController.text.trim();
        String? profilePicture =
            (updatedUser['profilePicture'] ??
                    updatedUser['profilePhoto'] ??
                    updatedUser['imageUrl'])
                ?.toString();

        if (profilePicture == null || profilePicture.isEmpty) {
          try {
            final whoamiResponse = await apiClient.get(ApiEndpoints.whoami);
            final whoamiData = whoamiResponse.data is Map<String, dynamic>
                ? whoamiResponse.data as Map<String, dynamic>
                : <String, dynamic>{};
            final whoamiUser = whoamiData['data'] is Map<String, dynamic>
                ? whoamiData['data'] as Map<String, dynamic>
                : whoamiData;
            profilePicture =
                (whoamiUser['profilePicture'] ??
                        whoamiUser['profilePhoto'] ??
                        whoamiUser['imageUrl'])
                    ?.toString();
            fullName =
                (whoamiUser['fullName'] ?? whoamiUser['name'])?.toString() ??
                fullName;
            mobileNumber =
                whoamiUser['mobileNumber']?.toString() ?? mobileNumber;
          } catch (_) {}
        }

        // 3. Update local storage so other screens reflect changes
        await userSession.updateeProfile(
          fullName: fullName,
          mobileNumber: mobileNumber,
          profilePicture: profilePicture,
        );
        if (mounted) {
          setState(() {
            _imageVersion = DateTime.now().millisecondsSinceEpoch;
          });
        }

        if (mounted) {
          _showSuccessToast('Profile updated successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile Updated Successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, {
            'fullName': fullName,
            'mobileNumber': mobileNumber,
            'profilePicture': profilePicture,
          });
        }
      }
    } on DioException catch (e) {
      debugPrint("DIO ERROR: ${e.response?.data ?? e.message}");
      final responseData = e.response?.data;
      String message = "Failed to update profile";
      if (responseData is Map && responseData['message'] != null) {
        message = responseData['message'].toString();
      } else if (responseData is String && responseData.trim().isNotEmpty) {
        message = responseData.contains('Cannot PUT')
            ? 'Update endpoint not found on server (PUT)'
            : responseData;
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- UI COMPONENTS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            //         // Check if there is actually a page to go back to
            // if (Navigator.canPop(context)) {
            //   Navigator.pop(context);
            // } else {
            //   // If no page exists (preventing black screen), go to Dashboard
            //   // Adjust the route name to match your app's route for Dashboard
            //   Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
            // }
            AppRoutes.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatarSection(),
              const SizedBox(height: 40),

              _buildTextField(
                label: 'Full Name',
                controller: _nameController,
                icon: Icons.person_outline,
                validator: (val) => (val == null || val.isEmpty)
                    ? "Name cannot be empty"
                    : null,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                label: 'Mobile Number',
                controller: _mobileNumberController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Mobile number required";
                  }
                  if (val.length < 10) return "Must be 10 digits";
                  return null;
                },
              ),

              const SizedBox(height: 50),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    final userSession = ref.watch(userSessionServiceProvider);
    final String? serverImagePath = userSession.getCurrentUserProfilePicture();
    final serverImageUrl = _resolveProfileImageUrl(serverImagePath);
    final String initial = _nameController.text.isNotEmpty
        ? _nameController.text[0].toUpperCase()
        : "?";

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.primary,
            child: CircleAvatar(
              radius: 57,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : (serverImageUrl != null
                            ? NetworkImage(serverImageUrl)
                            : null)
                        as ImageProvider?,
              child: (_imageFile == null && serverImageUrl == null)
                  ? Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showPickOptions,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.darkBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.background,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLength: maxLength,
          validator: validator,
          style: TextStyle(color: context.textPrimary),
          decoration: InputDecoration(
            counterText: "",
            hintStyle: TextStyle(color: context.textSecondary50),
            filled: true,
            fillColor: enabled
                ? context.inputFillColor
                : context.inputFillColor.withValues(alpha: 0.6),
            prefixIcon: Icon(icon, color: context.textPrimary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'UPDATE PROFILE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
