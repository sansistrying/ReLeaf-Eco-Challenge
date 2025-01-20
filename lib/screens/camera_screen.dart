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
  bool _isRearCameraSelected = true;
  double _currentZoomLevel = 1.0;
  double _baseZoomLevel = 1.0;
  final Logger _logger = Logger('CameraScreen');
  bool _hasPermission = false;
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
        setState(() => _hasPermission = false);
        return;
      }

      setState(() => _hasPermission = true);
      await onNewCameraSelected(cameras);
    } catch (e) {
      _logger.severe('Error initializing camera: $e');
      setState(() => _hasPermission = false);
      _showErrorDialog('Camera Error', 'Failed to initialize camera');
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

  Future<void> onNewCameraSelected(List<CameraDescription> cameras) async {
    final CameraController? oldController = _controller;
    if (oldController != null) {
      _controller = null;
      await oldController.dispose();
    }

    final CameraController newController = CameraController(
      _isRearCameraSelected ? cameras.first : cameras.last,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    try {
      await newController.initialize();
      await newController.setFlashMode(FlashMode.off);
      await newController.setZoomLevel(_currentZoomLevel);

      setState(() {
        _controller = newController;
        _isCameraInitialized = true;
      });
    } on CameraException catch (e) {
      _logger.severe('Error initializing camera: $e');
      _showErrorDialog('Camera Error', 'Failed to initialize camera');
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
      backgroundColor: Colors.black,
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
            const Icon(Icons.no_photography, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Camera Access Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enable camera access to continue',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeCamera,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
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

    return GestureDetector(
      onScaleStart: (details) {
        _baseZoomLevel = _currentZoomLevel;
      },
      onScaleUpdate: (details) {
        if (_controller == null) return;

        setState(() {
          _currentZoomLevel = (_baseZoomLevel * details.scale)
              .clamp(_minZoomLevel, _maxZoomLevel);
          _controller!.setZoomLevel(_currentZoomLevel);
        });
      },
      child: CameraPreview(_controller!),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentZoomLevel.toStringAsFixed(1)}x',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
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
            activeColor: Colors.white,
            inactiveColor: Colors.white30,
            onChanged: (value) {
              if (_controller == null) return;
              setState(() {
                _currentZoomLevel = value;
                _controller!.setZoomLevel(value);
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
            IconButton(
              icon: Icon(
                _isRearCameraSelected
                    ? Icons.camera_front
                    : Icons.camera_rear,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () async {
                setState(() => _isRearCameraSelected = !_isRearCameraSelected);
                final cameras = await availableCameras();
                await onNewCameraSelected(cameras);
              },
            ),
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
    } on CameraException catch (e) {
      _logger.severe('Error taking picture: $e');
      _showErrorDialog('Camera Error', 'Failed to capture image');
    }
  }
}