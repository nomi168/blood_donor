import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FaceScanCamera extends StatefulWidget {
  const FaceScanCamera({super.key});

  @override
  State<FaceScanCamera> createState() => _FaceScanCameraState();
}

class _FaceScanCameraState extends State<FaceScanCamera>
    with SingleTickerProviderStateMixin {
  CameraController? controller;
  late AnimationController animationController;

  List<CameraDescription> cameras = [];
  bool isFrontCamera = true;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    initCamera();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();

    final selectedCamera = cameras.firstWhere(
      (camera) =>
          camera.lensDirection ==
          (isFrontCamera
              ? CameraLensDirection.front
              : CameraLensDirection.back),
    );

    controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();
    setState(() {});
  }

  Future<void> switchCamera() async {
    isFrontCamera = !isFrontCamera;

    await controller?.dispose();
    controller = null;

    await initCamera();
  }

  Future<void> toggleFlash() async {
    if (controller == null) return;

    isFlashOn = !isFlashOn;

    await controller!.setFlashMode(
      isFlashOn ? FlashMode.torch : FlashMode.off,
    );

    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
        
          CameraPreview(controller!),

          
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Flash
                  IconButton(
                    onPressed: toggleFlash,
                    icon: Icon(
                      isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  /// Switch camera
                  IconButton(
                    onPressed: switchCamera,
                    icon: const Icon(
                      Icons.cameraswitch,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Face frame
          Center(
            child: Container(
              width: 260,
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.greenAccent,
                  width: 3,
                ),
              ),
            ),
          ),

          /// Scanner line
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Positioned(
                top: 150 + (260 * animationController.value),
                left: 50,
                right: 50,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withValues(alpha: .8),
                        blurRadius: 10,
                      )
                    ],
                  ),
                ),
              );
            },
          ),

          /// Animated dots
          Positioned(
            bottom: 160,
            left: 0,
            right: 0,
            child: AnimatedDots(animation: animationController),
          ),

          /// Capture button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                child: const Icon(Icons.camera_alt),
                onPressed: () async {
                  final file = await controller!.takePicture();
                  Navigator.pop(context, File(file.path));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedDots extends StatelessWidget {
  final AnimationController animation;

  const AnimatedDots({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        int activeDot = (animation.value * 3).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: index == activeDot ? 14 : 8,
              height: index == activeDot ? 14 : 8,
              decoration: BoxDecoration(
                color: Colors.greenAccent.withValues(
                  alpha: index == activeDot ? 1 : 0.4,
                ),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
