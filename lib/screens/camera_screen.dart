// lib/screens/camera_screen.dart
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
  bool _isRearCameraSelected = false; // Front camera by default
  double _currentZoomLevel = 1.0;
  final Logger _logger = Logger('CameraScreen');
  bool _isFlashOn = false;
  final double _minZoomLevel = 1.0;
  final double _maxZoomLevel = 5.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _logger.warning('No cameras available');
        return;
      }

      // Find front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final CameraController cameraController = CameraController(
        frontCamera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      await cameraController.initialize();
      await cameraController.setFlashMode(FlashMode.off);
      
      // Get min and max zoom levels
      if (mounted) {
        setState(() {
          _controller = cameraController;
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _logger.severe('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
      _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            _buildCameraPreview(),
            _buildOverlayControls(),
            _buildCameraControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _controller == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    return CameraPreview(_controller!);
  }

  Widget _buildOverlayControls() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () async {
              if (_controller == null) return;
              setState(() => _isFlashOn = !_isFlashOn);
              await _controller!.setFlashMode(
                _isFlashOn ? FlashMode.torch : FlashMode.off,
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isRearCameraSelected ? Icons.camera_front : Icons.camera_rear,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () async {
              setState(() => _isRearCameraSelected = !_isRearCameraSelected);
              await _initializeCamera();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCameraControls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 120,
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.photo_library,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                // Implement gallery picker
              },
            ),
            GestureDetector(
              onTap: _takePicture,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.all(8),
                ),
              ),
            ),
            const SizedBox(width: 64), // Placeholder for symmetry
          ],
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      _showErrorDialog('Error', 'Camera is not ready');
      return;
    }

    if (cameraController.value.isTakingPicture) {
      return;
    }

    try {
      final XFile photo = await cameraController.takePicture();
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            imageFile: File(photo.path),
            fileList: const [],
          ),
        ),
      );
    } catch (e) {
      _logger.severe('Error taking picture: $e');
      _showErrorDialog('Camera Error', 'Failed to capture image');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}