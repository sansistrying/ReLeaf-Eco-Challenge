// camera_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'preview_screen.dart';
import 'package:logging/logging.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isRearCameraSelected = true;
  final double _currentZoomLevel = 1.0;
  final Logger _logger = Logger('CameraScreen');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onNewCameraSelected();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected();
    }
  }

  void onNewCameraSelected() async {
    final cameras = await availableCameras();
    final newController = CameraController(
      _isRearCameraSelected ? cameras.first : cameras.last,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    if (_controller != null) {
      await _controller!.dispose();
    }

    try {
      await newController.initialize();
    } on CameraException catch (e) {
      _logger.warning('Error initializing camera: $e');
      return;
    }

    if (mounted) {
      setState(() {
        _controller = newController;
        _isCameraInitialized = _controller!.value.isInitialized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (_isCameraInitialized)
              AspectRatio(
                aspectRatio: 1 / _controller!.value.aspectRatio,
                child: _controller!.buildPreview(),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black87,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() => _isRearCameraSelected = !_isRearCameraSelected);
                          onNewCameraSelected();
                        },
                        iconSize: 30,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          _isRearCameraSelected
                              ? Icons.camera_front
                              : Icons.camera_rear,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: takePicture,
                        iconSize: 50,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.circle, color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Zoom: ${_currentZoomLevel.toStringAsFixed(1)}x',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    final CameraController? cameraController = _controller;
    if (!mounted || cameraController == null || cameraController.value.isTakingPicture) {
      return;
    }

    try {
      final XFile file = await cameraController.takePicture();
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            imageFile: File(file.path),
            fileList: const [],
          ),
        ),
      );
    } on CameraException catch (e) {
      _logger.warning('Error occurred while taking picture: $e');
    }
  }
}