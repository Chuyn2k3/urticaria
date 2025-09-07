// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import '../../../constant/color.dart';

// class ImageUploadWidget extends StatefulWidget {
//   final String label;
//   final List<String> imagePaths;
//   final Function(List<String>) onImagesChanged;
//   final bool enabled;
//   final int maxImages;

//   const ImageUploadWidget({
//     Key? key,
//     required this.label,
//     required this.imagePaths,
//     required this.onImagesChanged,
//     this.enabled = true,
//     this.maxImages = 5,
//   }) : super(key: key);

//   @override
//   State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
// }

// class _ImageUploadWidgetState extends State<ImageUploadWidget> {
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     if (widget.imagePaths.length >= widget.maxImages) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Tối đa ${widget.maxImages} ảnh')),
//       );
//       return;
//     }

//     try {
//       final XFile? image = await _picker.pickImage(
//         source: source,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         final List<String> newPaths = List.from(widget.imagePaths);
//         newPaths.add(image.path);
//         widget.onImagesChanged(newPaths);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Lỗi khi chọn ảnh')),
//       );
//     }
//   }

//   void _removeImage(int index) {
//     final List<String> newPaths = List.from(widget.imagePaths);
//     newPaths.removeAt(index);
//     widget.onImagesChanged(newPaths);
//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Chụp ảnh'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Chọn từ thư viện'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey[300]!),
//               borderRadius: BorderRadius.circular(8),
//               color: widget.enabled ? AppColors.whiteColor : Colors.grey[50],
//             ),
//             child: Column(
//               children: [
//                 if (widget.imagePaths.isNotEmpty) ...[
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 8,
//                       mainAxisSpacing: 8,
//                     ),
//                     itemCount: widget.imagePaths.length,
//                     itemBuilder: (context, index) {
//                       return Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.file(
//                               File(widget.imagePaths[index]),
//                               width: double.infinity,
//                               height: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           if (widget.enabled)
//                             Positioned(
//                               top: 4,
//                               right: 4,
//                               child: GestureDetector(
//                                 onTap: () => _removeImage(index),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(4),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.red,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: AppColors.whiteColor,
//                                     size: 16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                 ],
//                 if (widget.enabled &&
//                     widget.imagePaths.length < widget.maxImages)
//                   ElevatedButton.icon(
//                     onPressed: _showImageSourceDialog,
//                     icon: const Icon(Icons.add_a_photo),
//                     label: Text(
//                       widget.imagePaths.isEmpty ? 'Thêm ảnh' : 'Thêm ảnh khác',
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: AppColors.whiteColor,
//                       minimumSize: const Size(double.infinity, 48),
//                     ),
//                   ),
//                 if (!widget.enabled && widget.imagePaths.isEmpty)
//                   const Text(
//                     'Chưa có ảnh',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urticaria/constant/color.dart';
import 'dart:io';

class ImageUploadWidget extends StatefulWidget {
  final String label;
  final List<String> imagePaths;
  final Function(List<String>) onImagesChanged;
  final bool enabled;
  final int maxImages;

  const ImageUploadWidget({
    Key? key,
    required this.label,
    required this.imagePaths,
    required this.onImagesChanged,
    this.enabled = true,
    this.maxImages = 5,
  }) : super(key: key);

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (widget.imagePaths.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tối đa ${widget.maxImages} ảnh'),
          backgroundColor: AppColors.warningColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final List<String> newPaths = List.from(widget.imagePaths);
        newPaths.add(image.path);
        widget.onImagesChanged(newPaths);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lỗi khi chọn ảnh'),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeImage(int index) {
    final List<String> newPaths = List.from(widget.imagePaths);
    newPaths.removeAt(index);
    widget.onImagesChanged(newPaths);
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.photo_camera,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                          ),
                          title: const Text(
                            'Chụp ảnh',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: const Text(
                            'Sử dụng camera để chụp ảnh mới',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.photo_library,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                          ),
                          title: const Text(
                            'Chọn từ thư viện',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: const Text(
                            'Chọn ảnh có sẵn từ thư viện',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 0.1,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: widget.enabled
                  ? AppColors.whiteColor
                  : AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderColor,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (widget.imagePaths.isNotEmpty) ...[
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: widget.imagePaths.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(widget.imagePaths[index]),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (widget.enabled)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.errorColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: AppColors.whiteColor,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (widget.enabled &&
                      widget.imagePaths.length < widget.maxImages)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _showImageSourceDialog,
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                          size: 22,
                        ),
                        label: Text(
                          widget.imagePaths.isEmpty
                              ? 'Thêm ảnh'
                              : 'Thêm ảnh khác',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.whiteColor,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  if (!widget.enabled && widget.imagePaths.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.borderColor.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.textSecondary.withOpacity(0.7),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Chưa có ảnh',
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.8),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
