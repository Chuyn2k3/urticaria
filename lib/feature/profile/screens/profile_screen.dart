// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import '../../../cubits/auth/auth_cubit.dart';
// import 'enum/profile_enum.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const themeColor = Color(0xFF0066CC);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Cá nhân',
//           style: TextStyle(
//             color: Color(0xFF1F2937),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Profile Header Card
//             _buildUserCard(),

//             const SizedBox(height: 24),

//             // Menu Items
//             _buildListConfig(context),
//             const SizedBox(height: 32),
//             _buildLogoutButton()
//             // Logout Button
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUserCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: CircleAvatar(
//               radius: 28,
//               backgroundColor: Colors.transparent,
//               child: ClipOval(
//                 child: Image.network(
//                   "https://via.placeholder.com/150", // Avatar từ URL
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => const Icon(
//                     Icons.person,
//                     size: 28,
//                     color: AppColors.whiteColor,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "0342702597",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: const [
//                     Icon(Icons.verified, size: 14, color: Color(0xFF2196F3)),
//                     SizedBox(width: 4),
//                     Text(
//                       "Thành viên từ 2024",
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: const Color(0xFFE3F2FD),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.chevron_right,
//               size: 20,
//               color: Color(0xFF1565C0),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildListConfig(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//           children: ProfileTileType.values
//               .map(
//                 (e) => _buildTile(
//                   context,
//                   icon: e.icon,
//                   label: e.label,
//                 ),
//               )
//               .toList()),
//     );
//   }

//   Widget _buildLogoutButton() {
//     return Container(
//       width: double.infinity,
//       height: 56,
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.red.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.red.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {
//             GetIt.instance<AuthCubit>().logout();
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.logout, color: Colors.red.shade600),
//               const SizedBox(width: 8),
//               Text(
//                 'Đăng xuất',
//                 style: TextStyle(
//                   color: Colors.red.shade600,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTile(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     VoidCallback? onTap,
//     bool isLast = false,
//   }) {
//     return Column(
//       children: [
//         Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(isLast ? 20 : 0),
//             onTap: onTap,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF0066CC).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       icon,
//                       color: const Color(0xFF0066CC),
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       label,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF374151),
//                       ),
//                     ),
//                   ),
//                   Icon(
//                     Icons.chevron_right,
//                     color: Colors.grey.shade400,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         if (!isLast)
//           Divider(
//             height: 1,
//             color: Colors.grey.shade100,
//             indent: 64,
//           ),
//       ],
//     );
//   }
// }
