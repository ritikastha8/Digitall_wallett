import 'package:digital_wallett_system/app/theme/theme_extensions.dart';
import 'package:digital_wallett_system/core/utils/snackbar_utils.dart';
import 'package:digital_wallett_system/features/transfer/presentation/pages/send_money_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/load_money_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/my_qr_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/qr_scanner_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/pages/topup_page.dart';
import 'package:digital_wallett_system/features/wallet/presentation/state/wallet_state.dart';
import 'package:digital_wallett_system/features/wallet/presentation/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomesScreen extends ConsumerStatefulWidget {
  const HomesScreen({super.key});

  @override
  ConsumerState<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends ConsumerState<HomesScreen> {
  final List<XFile> _selectedMedia = [];
  // IMAGES, VIDEO
  final ImagePicker _imagePicker = ImagePicker();
  bool _amountVisible = true;

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

      // // upload image to server
      // await ref
      //     .read(itemViewModelProvider.notifier)
      //     .uploadPhoto(File(photo.path));
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
          //     .read(itemViewModelProvider.notifier)
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
          // // upload image to server
          // await ref
          //     .read(itemViewModelProvider.notifier)
          //     .uploadPhoto(File(image.path));
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

  // // code for video
  // Future<void> _pickFromVideo() async {
  //   try {
  //     final hasPermission = await _askuserPermission(Permission.camera);
  //     if (!hasPermission) return;

  //     final hasMicPermission = await _askuserPermission(Permission.microphone);
  //     if (!hasMicPermission) return;

  //     final XFile? video = await _imagePicker.pickVideo(
  //       source: ImageSource.camera,
  //       maxDuration: const Duration(minutes: 1),
  //     );

  //     if (video != null) {
  //       setState(() {
  //         _selectedMedia.clear();
  //         _selectedMedia.add(video);
  //       });
  //     }
  //   } catch (e) {
  //     _showPermissionDeniedDialog();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletViewModelProvider.notifier).loadBalance();
    });
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // --- Section Title ---
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 32,
                fontFamily: "Roboto Semibold",
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 30),
            // --- Balance Card ---
            Consumer(
              builder: (context, ref, _) {
                final walletState = ref.watch(walletViewModelProvider);
                final notifier = ref.read(walletViewModelProvider.notifier);
                final balanceText = walletState.status == WalletStatus.loaded &&
                        walletState.wallet != null
                    ? "NPR ${walletState.wallet!.balance.toStringAsFixed(2)}"
                    : "NPR 0.00";
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD87920),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (walletState.status == WalletStatus.loading)
                                const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              else if (walletState.status == WalletStatus.loaded &&
                                  walletState.wallet != null)
                                Text(
                                  _amountVisible
                                      ? balanceText
                                      : "XXXXXX",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else if (walletState.status == WalletStatus.error)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      walletState.errorMessage ?? 'Error',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => notifier.loadBalance(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  _amountVisible ? balanceText : "XXXXXX",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              const Text("Balance", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() => _amountVisible = !_amountVisible);
                          },
                          icon: Icon(
                            _amountVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey.shade700,
                          ),
                          tooltip: _amountVisible ? 'Hide amount' : 'Show amount',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 60),

            // --- Section Title ---
            const Padding(
              padding: EdgeInsets.only(left: 34),
              child: Text(
                "Operations",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: "Roboto Semibold",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- Operations Grid ---
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Button 1
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoadMoneyPage())).then((_) => ref.read(walletViewModelProvider.notifier).loadBalance()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.download, size: 28),
                      SizedBox(height: 6),
                      Text("Load\nMoney", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Button 2
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SendMoneyPage()),
                    ).then((_) {
                      ref.read(walletViewModelProvider.notifier).loadBalance();
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.upload, size: 28),
                      SizedBox(height: 6),
                      Text("Send\nMoney", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Button 3
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyQrPage())),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code, size: 28),
                      SizedBox(height: 6),
                      Text("My QR", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Button 4
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TopupPage())).then((_) => ref.read(walletViewModelProvider.notifier).loadBalance()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone_android, size: 28),
                      SizedBox(height: 6),
                      Text("Topup\n& Data", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                // Button 5
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScannerPage())).then((_) => ref.read(walletViewModelProvider.notifier).loadBalance());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code_scanner, size: 28),
                      SizedBox(height: 6),
                      Text("QR\nScanner", textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
