// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../../../utils/shared_preferences_manager.dart';
//
// class ImageUploadField extends StatefulWidget {
//   final String label;
//   final Function(String) onChanged;
//   final int templateId;
//   final String? selectedOption; // <-- truyền option, tự map ra overlay
//
//   const ImageUploadField({
//     super.key,
//     required this.label,
//     required this.onChanged,
//     required this.templateId,
//     this.selectedOption,
//   });
//
//   @override
//   State<ImageUploadField> createState() => _ImageUploadFieldState();
// }
//
// class _ImageUploadFieldState extends State<ImageUploadField> {
//   File? _selectedImage;
//   bool _uploading = false;
//   String? _uploadedUrl;
//
//   final ImagePicker _picker = ImagePicker();
//
//   String? get _overlayAsset => widget.selectedOption != null
//       ? optionToOverlay[widget.selectedOption!]
//       : null;
//
//   Future<void> _uploadFile(File file) async {
//     final sfm = await GetIt.instance<SharedPreferencesManager>();
//     final userId = sfm.getInt("user_id");
//
//     setState(() {
//       _uploading = true;
//     });
//
//     try {
//       print(userId);
//       print(widget.templateId);
//       final uri = Uri.parse(
//         "https://drmayday.ibme.edu.vn/urticaria-collector/api/v1/medical-records/upload"
//         "?user_id=$userId&record_type=${widget.templateId}",
//       );
//
//       final request = http.MultipartRequest("POST", uri);
//       request.files.add(await http.MultipartFile.fromPath("file", file.path));
//
//       final response = await request.send();
//       if (response.statusCode == 201) {
//         final body = await response.stream.bytesToString();
//         //final data = jsonDecode(body);
//         final link = body;
//         //data["data"] as String;
//
//         setState(() {
//           _uploadedUrl = link;
//           _uploading = false;
//         });
//
//         widget.onChanged(link);
//       } else {
//         throw Exception("Upload thất bại: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         _uploading = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lỗi upload: $e")),
//         );
//       }
//     }
//   }
//
//   Future<void> _pickFromGallery() async {
//     final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
//     if (picked == null) return;
//     final file = File(picked.path);
//     setState(() {
//       _selectedImage = file;
//     });
//     await _uploadFile(file);
//   }
//
//   Future<void> _openCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => _CustomCameraScreen(
//           camera: firstCamera,
//           overlayAsset: _overlayAsset,
//           onCapture: (file) async {
//             setState(() {
//               _selectedImage = file;
//             });
//             await _uploadFile(file);
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         if (_selectedImage != null)
//           Stack(
//             children: [
//               Image.file(
//                 _selectedImage!,
//                 height: 160,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: InkWell(
//                   onTap: () {
//                     setState(() {
//                       _selectedImage = null;
//                       _uploadedUrl = null;
//                     });
//                     widget.onChanged(""); // báo ra ngoài đã xóa
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black54,
//                       shape: BoxShape.circle,
//                     ),
//                     padding: const EdgeInsets.all(6),
//                     child:
//                         const Icon(Icons.close, color: Colors.white, size: 20),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         if (_uploadedUrl != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 4.0),
//             child: Text(
//               "Đã upload: $_uploadedUrl",
//               style: const TextStyle(color: Colors.green),
//             ),
//           ),
//         const SizedBox(height: 8),
//         _uploading
//             ? const CircularProgressIndicator()
//             : Row(
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.photo),
//                     label: const Text("Chọn ảnh"),
//                     onPressed: _pickFromGallery,
//                   ),
//                   const SizedBox(width: 12),
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Chụp ảnh"),
//                     onPressed: _openCamera,
//                   ),
//                 ],
//               ),
//       ],
//     );
//   }
// }
//
// /// Custom Camera với overlay
// class _CustomCameraScreen extends StatefulWidget {
//   final CameraDescription camera;
//   final String? overlayAsset;
//   final Function(File) onCapture;
//
//   const _CustomCameraScreen({
//     required this.camera,
//     this.overlayAsset,
//     required this.onCapture,
//   });
//
//   @override
//   State<_CustomCameraScreen> createState() => _CustomCameraScreenState();
// }
//
// class _CustomCameraScreenState extends State<_CustomCameraScreen> {
//   CameraController? _controller;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller!.initialize();
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _takePicture() async {
//     try {
//       await _initializeControllerFuture;
//       final image = await _controller!.takePicture();
//
//       final dir = await getTemporaryDirectory();
//       final filePath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final file = File(filePath);
//       await image.saveTo(filePath);
//
//       widget.onCapture(file);
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       debugPrint("Error capturing image: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return CameraPreview(_controller!);
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//           if (widget.overlayAsset != null)
//             Positioned.fill(
//               child: IgnorePointer(
//                 child: Image.asset(
//                   widget.overlayAsset!,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: FloatingActionButton(
//                 onPressed: _takePicture,
//                 child: const Icon(Icons.camera_alt),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Map option -> overlay asset
// const Map<String, String> optionToOverlay = {
//   // Trên mặt
//   "Mặt thẳng": "assets/overlays/face_front.jpeg",
//   "Nghiêng trái": "assets/overlays/face_left.jpeg",
//   "Nghiêng phải": "assets/overlays/face_right.jpeg",
//
//   // Miệng
//   "Miệng": "assets/overlays/mouth.jpeg",
//
//   // Thân
//   "Thân trước": "assets/overlays/body_front.jpeg",
//   "Thân sau": "assets/overlays/body_back.jpeg",
//
//   // Bàn tay
//   "Mặt mu": "assets/overlays/hand_back.jpeg",
//   "Mặt lòng (chụp 2 tay)": "assets/overlays/hand_back.jpeg",
//
//   // Cẳng tay
//   "Mặt trong": "assets/overlays/forearm_inner.jpeg",
//   "Mặt ngoài": "assets/overlays/overarm_outer.jpeg",
//
//   // Cánh tay
//   "Cánh tay - Mặt trong": "assets/overlays/upperarm_inner.jpeg",
//   "Cánh tay - Mặt ngoài": "assets/overlays/upperarm_outer.jpeg",
//
//   // Sinh dục
//   "Sinh dục": "assets/overlays/genital.jpeg",
//
//   // Đùi
//   "Đùi - Mặt trong": "assets/overlays/thigh_inner.jpeg",
//   "Đùi - Mặt ngoài": "assets/overlays/thigh_outer.jpeg",
//
//   // Cẳng chân
//   "Cẳng chân - Mặt trong": "assets/overlays/leg_inner.jpeg",
//   "Cẳng chân - Mặt ngoài": "assets/overlays/leg_outer.jpeg",
//
//   // Bàn chân
//   "Bàn chân - Mặt mu": "assets/overlays/foot_top.jpeg",
//   "Bàn chân - Mặt lòng (chụp 2 chân)": "assets/overlays/foot_bottom.jpeg",
// };
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import '../../../utils/shared_preferences_manager.dart';

class ImageUploadField extends StatefulWidget {
  final String label;
  final Function(String) onChanged;
  final int templateId;
  final String? selectedOption; // <-- truyền option, tự map ra overlay

  const ImageUploadField({
    super.key,
    required this.label,
    required this.onChanged,
    required this.templateId,
    this.selectedOption,
  });

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  File? _selectedImage;
  bool _uploading = false;
  String? _uploadedUrl;

  final ImagePicker _picker = ImagePicker();

  String? get _overlayAsset {
    final overlay = widget.selectedOption != null
        ? optionToOverlay[widget.selectedOption!]
        : null;
    debugPrint(
        "[ImageUploadField] selectedOption = ${widget.selectedOption}, overlayAsset = $overlay");
    return overlay;
  }

  Future<void> _uploadFile(File file) async {
    final sfm = await GetIt.instance<SharedPreferencesManager>();
    final userId = sfm.getInt("user_id");

    setState(() {
      _uploading = true;
    });

    try {
      debugPrint("[ImageUploadField] Uploading file: ${file.path}");
      final uri = Uri.parse(
        "https://drmayday.ibme.edu.vn/urticaria-collector/api/v1/medical-records/upload"
        "?user_id=$userId&record_type=${widget.templateId}",
      );

      final request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath("file", file.path));

      final response = await request.send();
      if (response.statusCode == 201) {
        final body = await response.stream.bytesToString();
        debugPrint("[ImageUploadField] Upload success: $body");

        setState(() {
          _uploadedUrl = body;
          _uploading = false;
        });

        widget.onChanged(body);
      } else {
        throw Exception("Upload thất bại: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("[ImageUploadField] Upload error: $e");
      setState(() {
        _uploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi upload: $e")),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final file = File(picked.path);
    debugPrint("[ImageUploadField] Picked from gallery: ${file.path}");
    setState(() {
      _selectedImage = file;
    });
    await _uploadFile(file);
  }

  Future<void> _openCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    debugPrint(
        "[ImageUploadField] Opening camera with overlay: $_overlayAsset");

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CustomCameraScreen(
          camera: firstCamera,
          overlayAsset: _overlayAsset,
          onCapture: (file) async {
            debugPrint("[ImageUploadField] Captured file: ${file.path}");
            setState(() {
              _selectedImage = file;
            });
            await _uploadFile(file);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (_selectedImage != null)
          Stack(
            children: [
              Image.file(
                _selectedImage!,
                height: 160,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () {
                    debugPrint("[ImageUploadField] Image removed");
                    setState(() {
                      _selectedImage = null;
                      _uploadedUrl = null;
                    });
                    widget.onChanged(""); // báo ra ngoài đã xóa
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        if (_uploadedUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "Đã upload: $_uploadedUrl",
              style: const TextStyle(color: Colors.green),
            ),
          ),
        const SizedBox(height: 8),
        _uploading
            ? const CircularProgressIndicator()
            : Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text("Chọn ảnh"),
                    onPressed: _pickFromGallery,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Chụp ảnh"),
                    onPressed: _openCamera,
                  ),
                ],
              ),
      ],
    );
  }
}

class _CustomCameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final String? overlayAsset;
  final Function(File) onCapture;

  const _CustomCameraScreen({
    required this.camera,
    this.overlayAsset,
    required this.onCapture,
  });

  @override
  State<_CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<_CustomCameraScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCapturing = false;
  bool _showOverlay = true;

  // Animation controllers
  late AnimationController _captureAnimationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();

    _captureAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.6,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    debugPrint(
        "[CustomCameraScreen] Init with overlay: ${widget.overlayAsset}");
  }

  @override
  void dispose() {
    _controller?.dispose();
    _captureAnimationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isCapturing) return;

    try {
      setState(() {
        _isCapturing = true;
      });

      // Animation hiệu ứng chụp ảnh
      await _captureAnimationController.forward();
      await _captureAnimationController.reverse();

      debugPrint("[CustomCameraScreen] Taking picture...");
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      await image.saveTo(filePath);

      debugPrint("[CustomCameraScreen] Saved to $filePath");
      widget.onCapture(file);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("[CustomCameraScreen] Error capturing image: $e");
      setState(() {
        _isCapturing = false;
      });
    }
  }

  void _switchCamera() async {
    final cameras = await availableCameras();
    if (cameras.length < 2) return;

    final currentCamera = _controller?.description;
    CameraDescription newCamera;

    if (currentCamera?.lensDirection == CameraLensDirection.back) {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
    } else {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
    }

    await _controller?.dispose();
    _controller = CameraController(newCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });

    if (_showOverlay) {
      _fadeController.reverse();
    } else {
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "[CustomCameraScreen] build() overlayAsset = ${widget.overlayAsset}");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),

          // Overlay với hiệu ứng mờ
          if (widget.overlayAsset != null && _showOverlay)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.overlayAsset!),
                          fit: BoxFit.contain,
                          opacity: _fadeAnimation.value,
                        ),
                      ),
                      child: CustomPaint(
                        painter: DashedBorderPainter(),
                        child: Container(),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Top Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Overlay toggle button
                if (widget.overlayAsset != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _showOverlay ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleOverlay,
                    ),
                  ),

                // Camera switch button
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.flip_camera_ios, color: Colors.white),
                    onPressed: _switchCamera,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.photo_library, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        // Có thể gọi _pickFromGallery ở đây nếu cần
                      },
                    ),
                  ),

                  // Capture button với animation
                  GestureDetector(
                    onTap: _takePicture,
                    child: AnimatedBuilder(
                      animation: _captureAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              1.0 - (_captureAnimationController.value * 0.1),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _isCapturing ? Colors.red : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: _isCapturing
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  )
                                : const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Flash button (placeholder)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.flash_auto, color: Colors.white),
                      onPressed: () {
                        // Implement flash toggle nếu cần
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Instruction text
          if (widget.overlayAsset != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Căn chỉnh theo khung hướng dẫn và nhấn chụp",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter để vẽ viền nét đứt
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 4.0;

    // Vẽ viền nét đứt xung quanh
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
            20, size.height * 0.1, size.width - 40, size.height * 0.8),
        const Radius.circular(12),
      ));

    _drawDashedPath(canvas, path, paint, dashWidth, dashSpace);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth,
      double dashSpace) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        final length = draw ? dashWidth : dashSpace;
        final extractPath = pathMetric.extractPath(
          distance,
          distance + length,
        );
        if (draw) {
          canvas.drawPath(extractPath, paint);
        }
        distance += length;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// class _CustomCameraScreen extends StatefulWidget {
//   final CameraDescription camera;
//   final String? overlayAsset;
//   final Function(File) onCapture;
//
//   const _CustomCameraScreen({
//     required this.camera,
//     this.overlayAsset,
//     required this.onCapture,
//   });
//
//   @override
//   State<_CustomCameraScreen> createState() => _CustomCameraScreenState();
// }
//
// class _CustomCameraScreenState extends State<_CustomCameraScreen> {
//   CameraController? _controller;
//   late Future<void> _initializeControllerFuture;
//   List<CameraDescription>? _availableCameras;
//   int _selectedCameraIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera(widget.camera);
//     _loadAvailableCameras();
//   }
//
//   Future<void> _loadAvailableCameras() async {
//     _availableCameras = await availableCameras();
//     setState(() {});
//   }
//
//   Future<void> _initializeCamera(CameraDescription camera) async {
//     _controller?.dispose();
//     _controller = CameraController(camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller!.initialize();
//     if (mounted) setState(() {});
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _switchCamera() async {
//     if (_availableCameras == null || _availableCameras!.length < 2) return;
//     setState(() {
//       _selectedCameraIndex =
//           (_selectedCameraIndex + 1) % _availableCameras!.length;
//     });
//     await _initializeCamera(_availableCameras![_selectedCameraIndex]);
//   }
//
//   Future<void> _takePicture() async {
//     try {
//       debugPrint("[CustomCameraScreen] Taking picture...");
//       await _initializeControllerFuture;
//       final image = await _controller!.takePicture();
//
//       final dir = await getTemporaryDirectory();
//       final filePath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final file = File(filePath);
//       await image.saveTo(filePath);
//
//       debugPrint("[CustomCameraScreen] Saved to $filePath");
//       widget.onCapture(file);
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       debugPrint("[CustomCameraScreen] Error capturing image: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lỗi chụp ảnh: $e")),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return Center(
//                   child: AspectRatio(
//                     aspectRatio: _controller!.value.aspectRatio,
//                     child: CameraPreview(_controller!),
//                   ),
//                 );
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//           // Khung nét đứt với vẽ khuôn mặt
//           Center(
//             child: DottedBorder(
//               borderType: BorderType.RRect,
//               radius: const Radius.circular(12),
//               dashPattern: const [6, 4], // Độ dài nét đứt và khoảng cách
//               color: Colors.white.withOpacity(0.5), // Màu viền mờ
//               strokeWidth: 2,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.7,
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 child: CustomPaint(
//                   painter: FaceOutlinePainter(),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             right: 16,
//             child: IconButton(
//               icon: const Icon(Icons.flip_camera_ios,
//                   color: Colors.white, size: 30),
//               onPressed: _switchCamera,
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: FloatingActionButton(
//                 backgroundColor: Colors.white,
//                 onPressed: _takePicture,
//                 child: const Icon(Icons.camera_alt, color: Colors.black),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 80,
//             left: 0,
//             right: 0,
//             child: Text(
//               "Căn chỉnh theo khung hình",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Lớp vẽ khuôn mặt
// class FaceOutlinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.5) // Màu nét vẽ mờ
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//
//     // Vẽ đường viền mặt (hình elip)
//     final facePath = Path()
//       ..addOval(Rect.fromCenter(
//         center: Offset(size.width / 2, size.height / 2),
//         width: size.width * 0.9,
//         height: size.height * 0.9,
//       ));
//     canvas.drawPath(facePath, paint);
//
//     // Vẽ tóc (đường cong trên đầu)
//     final hairPath = Path()
//       ..moveTo(size.width * 0.2, size.height * 0.2)
//       ..quadraticBezierTo(
//         size.width / 2,
//         size.height * 0.1,
//         size.width * 0.8,
//         size.height * 0.2,
//       );
//     canvas.drawPath(hairPath, paint);
//
//     // Vẽ mắt trái
//     canvas.drawOval(
//       Rect.fromCenter(
//         center: Offset(size.width * 0.35, size.height * 0.4),
//         width: size.width * 0.15,
//         height: size.height * 0.1,
//       ),
//       paint,
//     );
//
//     // Vẽ mắt phải
//     canvas.drawOval(
//       Rect.fromCenter(
//         center: Offset(size.width * 0.65, size.height * 0.4),
//         width: size.width * 0.15,
//         height: size.height * 0.1,
//       ),
//       paint,
//     );
//
//     // Vẽ mũi
//     canvas.drawLine(
//       Offset(size.width * 0.5, size.height * 0.5),
//       Offset(size.width * 0.5, size.height * 0.6),
//       paint,
//     );
//
//     // Vẽ miệng
//     final mouthPath = Path()
//       ..moveTo(size.width * 0.4, size.height * 0.7)
//       ..quadraticBezierTo(
//         size.width / 2,
//         size.height * 0.75,
//         size.width * 0.6,
//         size.height * 0.7,
//       );
//     canvas.drawPath(mouthPath, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

/// Custom Camera với overlay
// class _CustomCameraScreen extends StatefulWidget {
//   final CameraDescription camera;
//   final String? overlayAsset;
//   final Function(File) onCapture;
//
//   const _CustomCameraScreen({
//     required this.camera,
//     this.overlayAsset,
//     required this.onCapture,
//   });
//
//   @override
//   State<_CustomCameraScreen> createState() => _CustomCameraScreenState();
// }
//
// class _CustomCameraScreenState extends State<_CustomCameraScreen> {
//   CameraController? _controller;
//   late Future<void> _initializeControllerFuture;
//   List<CameraDescription> _cameras = [];
//   int _currentCameraIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }
//
//   Future<void> _initCamera() async {
//     _cameras = await availableCameras();
//     _startCamera(_currentCameraIndex);
//   }
//
//   void _startCamera(int index) {
//     _controller?.dispose();
//     _controller = CameraController(
//       _cameras[index],
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//     _initializeControllerFuture = _controller!.initialize();
//     setState(() {});
//   }
//
//   void _switchCamera() {
//     if (_cameras.length > 1) {
//       _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
//       _startCamera(_currentCameraIndex);
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _takePicture() async {
//     try {
//       await _initializeControllerFuture;
//       final image = await _controller!.takePicture();
//
//       final dir = await getTemporaryDirectory();
//       final filePath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final file = File(filePath);
//       await image.saveTo(filePath);
//
//       widget.onCapture(file);
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       debugPrint("[CustomCameraScreen] Error capturing image: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return CameraPreview(_controller!);
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//
//           // Overlay trong suốt
//           if (widget.overlayAsset != null)
//             Positioned.fill(
//               child: IgnorePointer(
//                 child: ColorFiltered(
//                   colorFilter: ColorFilter.mode(
//                     Colors.white.withOpacity(0.1), // mờ mờ
//                     BlendMode.srcATop,
//                   ),
//                   child: Image.asset(
//                     widget.overlayAsset!,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//
//           // Nút Back (góc trên trái)
//           SafeArea(
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: IconButton(
//                 icon:
//                     const Icon(Icons.arrow_back, color: Colors.white, size: 28),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ),
//
//           // Nút đổi camera (góc trên phải)
//           SafeArea(
//             child: Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                 icon: const Icon(Icons.cameraswitch,
//                     color: Colors.white, size: 28),
//                 onPressed: _switchCamera,
//               ),
//             ),
//           ),
//
//           // Nút chụp ảnh (giữa dưới)
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: GestureDetector(
//                 onTap: _takePicture,
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 4),
//                   ),
//                   child: const Center(
//                     child: Icon(Icons.circle, color: Colors.white, size: 50),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

/// Map option -> overlay asset
const Map<String, String> optionToOverlay = {
  "Mặt thẳng": "assets/overlays/face_front.jpeg",
  "Nghiêng trái": "assets/overlays/face_left.jpeg",
  "Nghiêng phải": "assets/overlays/face_right.jpeg",
  "Miệng": "assets/overlays/mouth.jpeg",
  "Thân trước": "assets/overlays/body_front.jpeg",
  "Thân sau": "assets/overlays/body_back.jpeg",
  "Mặt mu": "assets/overlays/hand_back.jpeg",
  "Mặt lòng (chụp 2 tay)": "assets/overlays/hand_back.jpeg",
  "Mặt trong": "assets/overlays/forearm_inner.jpeg",
  "Mặt ngoài": "assets/overlays/overarm_outer.jpeg",
  "Cánh tay - Mặt trong": "assets/overlays/upperarm_inner.jpeg",
  "Cánh tay - Mặt ngoài": "assets/overlays/upperarm_outer.jpeg",
  "Sinh dục": "assets/overlays/genital.jpeg",
  "Đùi - Mặt trong": "assets/overlays/thigh_inner.jpeg",
  "Đùi - Mặt ngoài": "assets/overlays/thigh_outer.jpeg",
  "Cẳng chân - Mặt trong": "assets/overlays/leg_inner.jpeg",
  "Cẳng chân - Mặt ngoài": "assets/overlays/leg_outer.jpeg",
  "Bàn chân - Mặt mu": "assets/overlays/foot_top.jpeg",
  "Bàn chân - Mặt lòng (chụp 2 chân)": "assets/overlays/foot_bottom.jpeg",
};
