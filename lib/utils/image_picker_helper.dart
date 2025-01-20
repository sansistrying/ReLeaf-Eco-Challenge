// lib/utils/image_picker_helper.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async'; // Add this import for Completer
import 'app_logger.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from camera or gallery
  static Future<File?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
      );

      if (pickedFile == null) {
        AppLogger.info('No image selected');
        return null;
      }

      return File(pickedFile.path);
    } catch (e) {
      AppLogger.error('Error picking image', error: e);
      return null;
    }
  }

  /// Pick multiple images from gallery
  static Future<List<File>> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
      );

      return pickedFiles.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      AppLogger.error('Error picking multiple images', error: e);
      return [];
    }
  }

  /// Pick a video from camera or gallery
  static Future<File?> pickVideo({
    required ImageSource source,
    Duration? maxDuration,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: source,
        maxDuration: maxDuration,
      );

      if (pickedFile == null) {
        AppLogger.info('No video selected');
        return null;
      }

      return File(pickedFile.path);
    } catch (e) {
      AppLogger.error('Error picking video', error: e);
      return null;
    }
  }

  /// Get image dimensions
  static Future<Size?> getImageDimensions(File imageFile) async {
    try {
      final Image image = Image.file(imageFile);
      final Completer<Size> completer = Completer<Size>();

      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(
              Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              ),
            );
          },
        ),
      );

      return await completer.future;
    } catch (e) {
      AppLogger.error('Error getting image dimensions', error: e);
      return null;
    }
  }

  /// Check if file is an image
  static bool isImageFile(File file) {
    final String path = file.path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif') ||
        path.endsWith('.webp');
  }

  /// Check if file is a video
  static bool isVideoFile(File file) {
    final String path = file.path.toLowerCase();
    return path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.avi') ||
        path.endsWith('.wmv') ||
        path.endsWith('.mkv');
  }

  /// Get file size in MB
  static double getFileSizeInMB(File file) {
    return file.lengthSync() / (1024 * 1024);
  }

  /// Show image picker modal
  static Future<File?> showImagePickerModal(BuildContext context) async {
    File? pickedFile;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  pickedFile = await pickImage(source: ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  pickedFile = await pickImage(source: ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    return pickedFile;
  }
}