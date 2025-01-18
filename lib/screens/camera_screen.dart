// lib/screens/camera_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'preview_screen.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isRearCameraSelected = true;
  double _currentZoomLevel = 1.0;
  double _baseZoomLevel = 1.0;
  final Logger _logger = Logger('CameraScreen');
  bool _isFlashOn = false;
  bool _hasPermission = false;
  final double _minZoomLevel = 1.0;
  final double _maxZoomLevel = 5.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
    if (_hasPermission) {
      await onNewCameraSelected();
    }
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

  Future<void> onNewCameraSelected() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      _logger.warning('No cameras available');
      return;
    }

    final newController = CameraController(
      _isRearCameraSelected ? cameras.first : cameras.last,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    if (_controller != null) {
      await _controller!.dispose();
    }

    try {
      await newController.initialize();
      await newController.setFlashMode(FlashMode.off);
      await newController.setZoomLevel(_currentZoomLevel);
    } on CameraException catch (e) {
      _logger.warning('Error initializing camera: $e');
      _showErrorDialog('Camera Error', 'Failed to initialize camera');
      return;
    }

    if (mounted) {
      setState(() {
        _controller = newController;
        _isCameraInitialized = _controller!.value.isInitialized;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            imageFile: File(image.path),
            fileList: const [],
          ),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return _buildPermissionDeniedUI();
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildCameraPreview(),
            _buildOverlayControls(),
            _buildZoomControl(),
            _buildCameraControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDeniedUI() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_off, size: 64),
            const SizedBox(height: 16),
            const Text('Camera permission is required'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPermissions,
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onScaleStart: (details) {
        _baseZoomLevel = _currentZoomLevel;
      },
      onScaleUpdate: (details) {
        setState(() {
          _currentZoomLevel = (_baseZoomLevel * details.scale)
              .clamp(_minZoomLevel, _maxZoomLevel);
          _controller?.setZoomLevel(_currentZoomLevel);
        });
      },
      child: AspectRatio(
        aspectRatio: 1 / _controller!.value.aspectRatio,
        child: _controller!.buildPreview(),
      ),
    );
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
            ),
            onPressed: () async {
              setState(() => _isFlashOn = !_isFlashOn);
              await _controller?.setFlashMode(
                _isFlashOn ? FlashMode.torch : FlashMode.off,
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentZoomLevel.toStringAsFixed(1)}x',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomControl() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height * 0.2,
      child: RotatedBox(
        quarterTurns: 3,
        child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Slider(
            value: _currentZoomLevel,
            min: _minZoomLevel,
            max: _maxZoomLevel,
            onChanged: (value) {
              setState(() {
                _currentZoomLevel = value;
                _controller?.setZoomLevel(value);
              });
            },
          ),
        ),
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
              icon: const Icon(Icons.image, color: Colors.white, size: 32),
              onPressed: _pickFromGallery,
            ),
            GestureDetector(
              onTap: takePicture,
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
            IconButton(
              icon: Icon(
                _isRearCameraSelected ? Icons.camera_front : Icons.camera_rear,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                setState(() => _isRearCameraSelected = !_isRearCameraSelected);
                onNewCameraSelected();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    final CameraController? cameraController = _controller;
    if (!mounted || cameraController == null || !cameraController.value.isInitialized) {
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
      _showErrorDialog('Camera Error', 'Failed to capture image');
    }
  }
}