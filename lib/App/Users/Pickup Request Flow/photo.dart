import 'package:flutter/cupertino.dart';

import 'dart:io';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Image Picker :
import 'package:image_picker/image_picker.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Questionnaire :
import 'package:public_health/App/Users/Pickup%20Request%20Flow/questionnaire.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  XFile? _image;

  Future<void> _pickImage() async {
    final source = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
            child: const Text('Photo Library'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );

    if (source == null) return;

    final image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void _goNext() {
    if (mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (_) => QuestionnairePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Hero card with target rings
          Container(
            width: double.infinity,
            height: 320,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: BoxBorder.all(color: AppColors.textPrimary),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, 0),
                  child: _image == null
                      ? Image.asset(AssetMapper.bucket, width: 100)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(_image!.path),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),

                Align(
                  alignment: const Alignment(-1, 1.1),
                  child: Text(
                    l10n.wasteVerification,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          Text(
            l10n.wasteVerificationSubtitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottom: Column(
        children: [
          AppPrimaryButton(
            text: _image == null ? l10n.addPhoto : l10n.next,
            onPressed: _image == null ? _pickImage : _goNext,
          ),
          const SizedBox(height: 12),
          AppSecondaryButton(
            text: l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
