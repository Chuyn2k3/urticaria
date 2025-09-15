// // import 'package:flutter/material.dart';
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:urticaria/cubit/profile/profile_cubit.dart';
// // import 'package:urticaria/feature/live/chat_socket.dart';
// //
// // import 'agora_config.dart';
// //
// // class LiveDetailPage extends StatefulWidget {
// //   final AgoraConfig config;
// //
// //   const LiveDetailPage({super.key, required this.config});
// //
// //   @override
// //   State<LiveDetailPage> createState() => _LiveDetailPageState();
// // }
// //
// // class _LiveDetailPageState extends State<LiveDetailPage> {
// //   late RtcEngine _engine;
// //   int? _remoteUid;
// //   bool _joined = false;
// //   final chatSocket = ChatSocket();
// //
// //   final List<CommentMessage> _messages = [];
// //   final TextEditingController _controller = TextEditingController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initSocket();
// //     _initAgora();
// //   }
// //
// //   void initSocket() {
// //     chatSocket.initSocket();
// //     chatSocket.socket?.emit('join-live', {
// //       "channelName": widget.config.channelName,
// //       "patientId": userId,
// //       "staffId": widget.config.doctorId,
// //     });
// //
// //     chatSocket.socket?.on('comment', (data) {
// //       setState(() {
// //         _messages.insert(
// //             0, CommentMessage.fromJson(data)); // thêm tin nhắn mới lên đầu
// //       });
// //     });
// //   }
// //
// //   Future<void> _initAgora() async {
// //     _engine = createAgoraRtcEngine();
// //     await _engine.initialize(
// //       RtcEngineContext(appId: widget.config.appId ?? ""),
// //     );
// //
// //     _engine.registerEventHandler(
// //       RtcEngineEventHandler(
// //         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
// //           setState(() => _joined = true);
// //         },
// //         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
// //           setState(() => _remoteUid = remoteUid);
// //         },
// //         onUserOffline: (RtcConnection connection, int remoteUid,
// //             UserOfflineReasonType reason) {
// //           setState(() => _remoteUid = null);
// //         },
// //         onError: (code, mess) {
// //           print("onErr:$code - $mess");
// //         },
// //       ),
// //     );
// //
// //     await _engine.enableVideo();
// //     await _engine.enableAudio();
// //
// //     await _engine.joinChannel(
// //       token: widget.config.rtcToken ?? "",
// //       channelId: widget.config.channelName ?? "",
// //       uid: userId, // viewer để 0
// //       options: const ChannelMediaOptions(
// //         clientRoleType: ClientRoleType.clientRoleAudience,
// //         autoSubscribeAudio: true,
// //         autoSubscribeVideo: true,
// //       ),
// //     );
// //   }
// //
// //   void _sendMessage() {
// //     if (_controller.text.trim().isEmpty) return;
// //     final text = _controller.text.trim();
// //
// //     // chatSocket.socket?.emit("comment", {
// //     //   'channelName': widget.config.channelName ?? "",
// //     //   'message': text,
// //     //   "userId": 6,
// //     //   "userType": "patient",
// //     // });
// //     chatSocket.socket?.emitWithAck("comment", {
// //       'channelName': widget.config.channelName!,
// //       'message': text,
// //       "userId": 6,
// //       "userType": "patient",
// //     }, ack: (data) {
// //       debugPrint("SendMessage: Nhận phản hồi từ server: $data");
// //       if (data != null && data is Map && data['status'] == 'success') {
// //         debugPrint("SendMessage: Server xác nhận tin nhắn gửi thành công");
// //         // _showSnackBar("Tin nhắn đã được gửi!");
// //       } else {
// //         debugPrint(
// //             "SendMessage: Lỗi từ server hoặc dữ liệu không hợp lệ: $data");
// //         // _showSnackBar("Lỗi gửi tin nhắn, vui lòng thử lại.");
// //       }
// //     });
// //     _controller.clear();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _engine.leaveChannel();
// //     _engine.release();
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Live Detail")),
// //       body: Column(
// //         children: [
// //           // video chiếm 2/3
// //           Expanded(
// //             flex: 2,
// //             child: _remoteUid != null
// //                 ? AgoraVideoView(
// //                     controller: VideoViewController.remote(
// //                       rtcEngine: _engine,
// //                       canvas: VideoCanvas(uid: _remoteUid),
// //                       connection: RtcConnection(
// //                         channelId: widget.config.channelName ?? "",
// //                       ),
// //                     ),
// //                   )
// //                 : _joined
// //                     ? const Center(child: Text("Waiting for doctor to join..."))
// //                     : const Center(child: CircularProgressIndicator()),
// //           ),
// //
// //           // list message chiếm 1/3
// //           Expanded(
// //             flex: 1,
// //             child: ListView.builder(
// //               reverse: true, // tin nhắn mới ở dưới cùng
// //               itemCount: _messages.length,
// //               itemBuilder: (context, index) {
// //                 final msg = _messages[index];
// //                 return Container(
// //                     margin: EdgeInsets.only(left: 8), child: Text(msg.message));
// //               },
// //             ),
// //           ),
// //
// //           // input
// //           Container(
// //             width: MediaQuery.of(context).size.width,
// //             height: 60,
// //             color: Colors.white,
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _controller,
// //                     decoration:
// //                         const InputDecoration(hintText: "Nhập nội dung"),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   onPressed: _sendMessage,
// //                   icon: const Icon(
// //                     Icons.send,
// //                     color: Colors.blue,
// //                     size: 24,
// //                   ),
// //                 )
// //               ],
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class CommentMessage {
// //   final String message;
// //   final CommentUser user;
// //   final DateTime timestamp;
// //
// //   CommentMessage({
// //     required this.message,
// //     required this.user,
// //     required this.timestamp,
// //   });
// //
// //   factory CommentMessage.fromJson(Map<String, dynamic> json) {
// //     return CommentMessage(
// //       message: json['message'] ?? '',
// //       user: CommentUser.fromJson(json['user'] ?? {}),
// //       timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       "message": message,
// //       "user": user.toJson(),
// //       "timestamp": timestamp.toIso8601String(),
// //     };
// //   }
// // }
// //
// // class CommentUser {
// //   final int id;
// //   final String name;
// //   final String email;
// //
// //   CommentUser({
// //     required this.id,
// //     required this.name,
// //     required this.email,
// //   });
// //
// //   factory CommentUser.fromJson(Map<String, dynamic> json) {
// //     return CommentUser(
// //       id: json['id'] ?? 0,
// //       name: json['name'] ?? '',
// //       email: json['email'] ?? '',
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       "id": id,
// //       "name": name,
// //       "email": email,
// //     };
// //   }
// // }
// //////////////////
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:urticaria/cubit/profile/profile_cubit.dart';
// import 'package:urticaria/feature/live/chat_socket.dart';
// import 'package:urticaria/feature/live/agora_config.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:async';
// import 'package:urticaria/di/locator.dart';
// import 'package:flutter/scheduler.dart';
//
// import '../../cubit/Internet/internet_cubit.dart';
//
// class LiveDetailPage extends StatefulWidget {
//   final AgoraConfig config;
//
//   const LiveDetailPage({super.key, required this.config});
//
//   @override
//   State<LiveDetailPage> createState() => _LiveDetailPageState();
// }
//
// class _LiveDetailPageState extends State<LiveDetailPage>
//     with TickerProviderStateMixin {
//   late final RtcEngine _engine;
//   final ChatSocket chatSocket = ChatSocket();
//   final TextEditingController _controller = TextEditingController();
//   final ValueNotifier<List<CommentMessage>> _messagesNotifier =
//       ValueNotifier([]);
//   late AnimationController _pulseController;
//   late AnimationController _slideController;
//
//   final ValueNotifier<int?> _remoteUid = ValueNotifier(null);
//   final ValueNotifier<bool> _joined = ValueNotifier(false);
//   final ValueNotifier<bool> _chatExpanded = ValueNotifier(false);
//   Timer? _sendMessageDebounce;
//   Timer? _snackBarDebounce;
//
//   static const int maxMessages = 50;
//
//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     // Initialize InternetCubit
//     context.read<InternetCubit>().checkConnection();
//     initSocket();
//     _initAgora();
//   }
//
//   void initSocket() async {
//     final profileCubit = serviceLocator<ProfileUserCubit>();
//     final user = profileCubit.inforUser();
//     final userId = user?.id ?? 6; // Default patient ID
//     await chatSocket.initSocket();
//     chatSocket.socket?.off('connect');
//     chatSocket.socket?.off('disconnect');
//     chatSocket.socket?.off('reconnect');
//     chatSocket.socket?.off('comment');
//     chatSocket.socket?.on('connect', (_) {
//       chatSocket.socket?.emit('join-live', {
//         "channelName": widget.config.channelName ?? '',
//         "patientId": userId,
//         "staffId": widget.config.doctorId,
//       });
//       _showSnackBar("Kết nối socket thành công");
//     });
//     chatSocket.socket?.on('disconnect', (_) {
//       _showSnackBar("Mất kết nối socket, đang thử lại...");
//     });
//     chatSocket.socket?.on('reconnect', (_) {
//       _showSnackBar("Kết nối lại socket thành công");
//       chatSocket.socket?.emit('join-live', {
//         "channelName": widget.config.channelName ?? '',
//         "patientId": userId,
//         "staffId": widget.config.doctorId,
//       });
//     });
//     chatSocket.socket?.on('comment', (data) {
//       _messagesNotifier.value = [
//         CommentMessage.fromJson(data),
//         ..._messagesNotifier.value.take(maxMessages - 1),
//       ];
//     });
//   }
//
//   Future<void> _initAgora() async {
//     if (widget.config.appId == null ||
//         widget.config.rtcToken == null ||
//         widget.config.channelName == null) {
//       _showSnackBar("Lỗi: Thiếu cấu hình Agora");
//       return;
//     }
//
//     if (context.read<InternetCubit>().state is NotConnectedState) {
//       _showSnackBar(
//           "Không có kết nối mạng, vui lòng kiểm tra WiFi hoặc dữ liệu di động.");
//       return;
//     }
//
//     try {
//       _engine = createAgoraRtcEngine();
//       await _engine.initialize(RtcEngineContext(appId: widget.config.appId!));
//       await _engine.enableVideo();
//       await _engine.enableAudio();
//
//       _engine.registerEventHandler(
//         RtcEngineEventHandler(
//           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             if (!mounted) return;
//             _joined.value = true;
//             if (context.read<InternetCubit>().state is ConnectedState) {
//               _pulseController.repeat();
//             }
//           },
//           onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//             if (!mounted) return;
//             _remoteUid.value = remoteUid;
//           },
//           onUserOffline: (RtcConnection connection, int remoteUid,
//               UserOfflineReasonType reason) {
//             if (!mounted) return;
//             _remoteUid.value = null;
//           },
//           onConnectionLost: (RtcConnection connection) async {
//             if (!mounted) return;
//             _joined.value = false;
//             _pulseController.stop();
//             _showSnackBar("Mất kết nối Agora, đang thử reconnect...");
//             await _engine.leaveChannel();
//             _retryJoinChannel();
//           },
//           onRejoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             _showSnackBar("Kết nối lại Agora thành công!");
//             _joined.value = true;
//             if (context.read<InternetCubit>().state is ConnectedState) {
//               _pulseController.repeat();
//             }
//           },
//           onNetworkQuality: (RtcConnection connection, int remoteUid,
//               QualityType txQuality, QualityType rxQuality) {
//             if (txQuality.index > QualityType.qualityGood.index) {
//               _showSnackBar("Chất lượng mạng yếu, vui lòng kiểm tra kết nối.");
//             }
//           },
//           onError: (ErrorCodeType code, String msg) {
//             debugPrint("Agora onError: $code - $msg");
//             _showSnackBar("Lỗi Agora: $msg");
//           },
//         ),
//       );
//
//       final profileCubit = serviceLocator<ProfileUserCubit>();
//       final user = profileCubit.inforUser();
//       final userId = user?.id ?? 6;
//
//       await _engine.joinChannel(
//         token: widget.config.rtcToken!,
//         channelId: widget.config.channelName!,
//         uid: userId,
//         options: const ChannelMediaOptions(
//           clientRoleType: ClientRoleType.clientRoleAudience,
//           autoSubscribeAudio: true,
//           autoSubscribeVideo: true,
//         ),
//       );
//     } catch (e) {
//       debugPrint("Error initializing Agora: $e");
//       _showSnackBar("Lỗi khởi tạo Agora: $e");
//     }
//   }
//
//   Future<void> _retryJoinChannel() async {
//     try {
//       if (context.read<InternetCubit>().state is NotConnectedState) {
//         _showSnackBar(
//             "Không có kết nối mạng, vui lòng kiểm tra WiFi hoặc dữ liệu di động.");
//         return;
//       }
//
//       final profileCubit = serviceLocator<ProfileUserCubit>();
//       final user = profileCubit.inforUser();
//       final userId = user?.id ?? 6;
//
//       await _engine.joinChannel(
//         token: widget.config.rtcToken!,
//         channelId: widget.config.channelName!,
//         uid: userId,
//         options: const ChannelMediaOptions(
//           clientRoleType: ClientRoleType.clientRoleAudience,
//           autoSubscribeAudio: true,
//           autoSubscribeVideo: true,
//         ),
//       );
//       _joined.value = true;
//       _showSnackBar("Kết nối lại thành công!");
//     } catch (e) {
//       _showSnackBar("Không thể kết nối lại: $e");
//     }
//   }
//
//   void _sendMessage() {
//     if (_controller.text.trim().isEmpty || widget.config.channelName == null)
//       return;
//     _sendMessageDebounce?.cancel();
//     _sendMessageDebounce = Timer(const Duration(milliseconds: 300), () {
//       final profileCubit = serviceLocator<ProfileUserCubit>();
//       final user = profileCubit.inforUser();
//       final userId = user?.id ?? 6;
//       print("userId $userId");
//       final text = _controller.text.trim();
//
//       chatSocket.socket?.emit("comment", {
//         'channelName': widget.config.channelName!,
//         'message': text,
//         "userId": userId,
//         "userType": "patient",
//       });
//       _controller.clear();
//     });
//   }
//
//   void _toggleChat() {
//     _chatExpanded.value = !_chatExpanded.value;
//     if (_chatExpanded.value) {
//       _slideController.forward();
//     } else {
//       _slideController.reverse();
//     }
//   }
//
//   void _showSnackBar(String message) {
//     if (!mounted) return;
//     _snackBarDebounce?.cancel();
//     _snackBarDebounce = Timer(const Duration(milliseconds: 500), () {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(message),
//             backgroundColor: Colors.black87,
//             behavior: SnackBarBehavior.floating,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       });
//     });
//   }
//
//   Future<void> _cleanup() async {
//     try {
//       await _engine.leaveChannel();
//       await _engine.release();
//       chatSocket.socket?.disconnect();
//       chatSocket.socket?.dispose();
//     } catch (e) {
//       debugPrint("Error during cleanup: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     _sendMessageDebounce?.cancel();
//     _snackBarDebounce?.cancel();
//     _pulseController.dispose();
//     _slideController.dispose();
//     _controller.dispose();
//     _messagesNotifier.dispose();
//     _remoteUid.dispose();
//     _joined.dispose();
//     _chatExpanded.dispose();
//     _cleanup();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await _cleanup();
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () async {
//               await _cleanup();
//               if (context.mounted) Navigator.pop(context);
//             },
//           ),
//           title: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   "Live: ${widget.config.channelName}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               LiveIndicator(pulseController: _pulseController),
//             ],
//           ),
//         ),
//         body: SafeArea(
//           child: BlocBuilder<InternetCubit, InternetState>(
//             builder: (context, internetState) {
//               return ValueListenableBuilder<bool>(
//                 valueListenable: _joined,
//                 builder: (context, joined, child) {
//                   return Stack(
//                     children: [
//                       ValueListenableBuilder<int?>(
//                         valueListenable: _remoteUid,
//                         builder: (context, remoteUid, child) {
//                           return VideoView(
//                             remoteUid: remoteUid,
//                             joined: joined,
//                             engine: _engine,
//                             channelName: widget.config.channelName ?? '',
//                           );
//                         },
//                       ),
//                       Positioned(
//                         top: 20,
//                         left: 20,
//                         child: NetworkStatus(
//                           isNetworkConnected: internetState is ConnectedState,
//                           isJoined: joined,
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 20,
//                         left: 20,
//                         child: ValueListenableBuilder<bool>(
//                           valueListenable: _chatExpanded,
//                           builder: (context, chatExpanded, child) {
//                             return ChatPanel(
//                               chatExpanded: chatExpanded,
//                               slideController: _slideController,
//                               messagesNotifier: _messagesNotifier,
//                               controller: _controller,
//                               sendMessage: _sendMessage,
//                               toggleChat: _toggleChat,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LiveIndicator extends StatelessWidget {
//   final AnimationController pulseController;
//
//   const LiveIndicator({super.key, required this.pulseController});
//
//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: AnimatedBuilder(
//         animation: pulseController,
//         builder: (context, child) {
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.red.withOpacity(0.8 + 0.2 * pulseController.value),
//                   Colors.redAccent
//                       .withOpacity(0.8 + 0.2 * pulseController.value),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.red.withOpacity(0.3),
//                   blurRadius: 8,
//                   spreadRadius: pulseController.value * 2,
//                 ),
//               ],
//             ),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: 8,
//                   height: 8,
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 6),
//                 Text(
//                   "LIVE",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class NetworkStatus extends StatelessWidget {
//   final bool isNetworkConnected;
//   final bool isJoined;
//
//   const NetworkStatus({
//     super.key,
//     required this.isNetworkConnected,
//     required this.isJoined,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.black.withOpacity(0.8),
//             Colors.black.withOpacity(0.6),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: (isNetworkConnected && isJoined)
//               ? Colors.green.withOpacity(0.5)
//               : Colors.red.withOpacity(0.5),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             isNetworkConnected && isJoined ? Icons.wifi : Icons.wifi_off,
//             color: isNetworkConnected && isJoined ? Colors.green : Colors.red,
//             size: 18,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             isNetworkConnected ? "Đã kết nối" : "Mất kết nối",
//             style: TextStyle(
//               color: isNetworkConnected && isJoined ? Colors.green : Colors.red,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatPanel extends StatelessWidget {
//   final bool chatExpanded;
//   final AnimationController slideController;
//   final ValueNotifier<List<CommentMessage>> messagesNotifier;
//   final TextEditingController controller;
//   final VoidCallback sendMessage;
//   final VoidCallback toggleChat;
//
//   const ChatPanel({
//     super.key,
//     required this.chatExpanded,
//     required this.slideController,
//     required this.messagesNotifier,
//     required this.controller,
//     required this.sendMessage,
//     required this.toggleChat,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//         height: chatExpanded ? MediaQuery.of(context).size.height * 0.45 : 60,
//         width: MediaQuery.of(context).size.width * 0.75,
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.8),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withOpacity(0.2)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.blue.withOpacity(0.8),
//                     Colors.blueAccent.withOpacity(0.6),
//                   ],
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.chat_bubble_outline,
//                       color: Colors.white, size: 18),
//                   const SizedBox(width: 8),
//                   const Expanded(
//                     child: Text(
//                       "Trò chuyện",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: toggleChat,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         chatExpanded ? Icons.expand_less : Icons.expand_more,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: AnimatedBuilder(
//                 animation: slideController,
//                 builder: (context, child) {
//                   return Opacity(
//                     opacity: slideController.value,
//                     child: child,
//                   );
//                 },
//                 child: ValueListenableBuilder<List<CommentMessage>>(
//                   valueListenable: messagesNotifier,
//                   builder: (context, messages, child) {
//                     return ListView.separated(
//                       reverse: true,
//                       physics: const BouncingScrollPhysics(),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       itemCount: messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = messages[index];
//                         print("msg ${msg.toJson()}");
//                         return Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                                 color: Colors.white.withOpacity(0.1)),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: 32,
//                                 height: 32,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [Colors.blue, Colors.blueAccent],
//                                   ),
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.blue.withOpacity(0.3),
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     msg.user.name.isNotEmpty
//                                         ? msg.user.name
//                                         : '?',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       msg.user.name.isNotEmpty
//                                           ? msg.user.name
//                                           : 'Unknown',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       msg.message,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                         height: 1.3,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       msg.timestamp
//                                           .toString()
//                                           .substring(11, 16),
//                                       style: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 10,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(height: 4),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             AnimatedBuilder(
//               animation: slideController,
//               builder: (context, child) {
//                 return Visibility(
//                   visible: slideController.status == AnimationStatus.completed,
//                   child: Container(
//                     margin: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: controller,
//                             decoration: const InputDecoration(
//                               hintText: "Nhập tin nhắn...",
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 12),
//                               hintStyle: TextStyle(color: Colors.grey),
//                             ),
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(right: 4),
//                           decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Colors.blue, Colors.blueAccent],
//                             ),
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             onPressed: sendMessage,
//                             icon: const Icon(Icons.send,
//                                 color: Colors.white, size: 20),
//                             padding: const EdgeInsets.all(8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class VideoView extends StatelessWidget {
//   final int? remoteUid;
//   final bool joined;
//   final RtcEngine engine;
//   final String channelName;
//
//   const VideoView({
//     super.key,
//     required this.remoteUid,
//     required this.joined,
//     required this.engine,
//     required this.channelName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return remoteUid != null
//         ? ClipRRect(
//             borderRadius: BorderRadius.circular(0),
//             child: AgoraVideoView(
//               controller: VideoViewController.remote(
//                 rtcEngine: engine,
//                 canvas: VideoCanvas(uid: remoteUid),
//                 connection: RtcConnection(channelId: channelName),
//               ),
//             ),
//           )
//         : Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.grey[900]!, Colors.black],
//               ),
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (!joined)
//                     const CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                       strokeWidth: 3,
//                     ),
//                   const SizedBox(height: 24),
//                   Text(
//                     joined ? "Đang chờ bác sĩ tham gia..." : "Đang kết nối...",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }
//
// class CommentMessage {
//   final String message;
//   final CommentUser user;
//   final DateTime timestamp;
//
//   CommentMessage({
//     required this.message,
//     required this.user,
//     required this.timestamp,
//   });
//
//   factory CommentMessage.fromJson(Map<String, dynamic> json) {
//     try {
//       return CommentMessage(
//         message: json['message']?.toString() ?? '',
//         user: CommentUser.fromJson(json['user'] ?? {}),
//         timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
//             DateTime.now(),
//       );
//     } catch (e) {
//       debugPrint("Error parsing CommentMessage: $e");
//       return CommentMessage(
//         message: '',
//         user: CommentUser(id: 6, name: 'Unknown', email: ''),
//         timestamp: DateTime.now(),
//       );
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "message": message,
//       "user": user.toJson(),
//       "timestamp": timestamp.toIso8601String(),
//     };
//   }
// }
//
// class CommentUser {
//   final int id;
//   final String name;
//   final String email;
//
//   CommentUser({
//     required this.id,
//     required this.name,
//     required this.email,
//   });
//
//   factory CommentUser.fromJson(Map<String, dynamic> json) {
//     return CommentUser(
//       id: json['id']?.toInt() ?? 5,
//       name: json['name']?.toString() ?? 'Unknown',
//       email: json['email']?.toString() ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {"id": id, "name": name, "email": email};
//   }
// }
