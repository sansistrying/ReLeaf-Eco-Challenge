//lib/screens/preview_screen.dart

import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/action_button.dart';
import 'package:logging/logging.dart';

class PreviewScreen extends StatelessWidget {
  final File imageFile;
  final List<File> fileList;
  final Logger _logger = Logger('PreviewScreen');

  PreviewScreen({
    Key? key,
    required this.imageFile,
    required this.fileList,
  }) : super(key: key);

  // Implement image processing and eco-action validation
  void processAndValidateImage() {
    // Add image processing logic here
    // Add eco-action validation logic here
    _logger.info('Image processed and eco-action validated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionButton(
                      icon: Icons.close,
                      onPressed: () => Navigator.pop(context),
                      label: 'Discard',
                    ),
                    ActionButton(
                      icon: Icons.check,
                      onPressed: () {
                        processAndValidateImage();
                        Navigator.pop(context);
                      },
                      label: 'Submit',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

