import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:urticaria/cubit/profile/profile_cubit.dart';
import 'package:urticaria/feature/live/chat_socket.dart';

import 'agora_config.dart';

class LiveDetailPage extends StatefulWidget {
  final AgoraConfig config;

  const LiveDetailPage({super.key, required this.config});

  @override
  State<LiveDetailPage> createState() => _LiveDetailPageState();
}

class _LiveDetailPageState extends State<LiveDetailPage> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _joined = false;
  final chatSocket = ChatSocket();

  final List<CommentMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSocket();
    _initAgora();
  }

  void initSocket() {
    chatSocket.initSocket();
    chatSocket.socket?.emit('join-live', {
      "channelName": widget.config.channelName,
      "patientId": userId,
      "staffId": widget.config.doctorId,
    });
    chatSocket.socket?.on('comment', (data) {
      setState(() {
        _messages.insert(
            0, CommentMessage.fromJson(data)); // thêm tin nhắn mới lên đầu
      });
    });
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(appId: widget.config.appId ?? ""),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() => _joined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() => _remoteUid = null);
        },
        onError: (code, mess) {
          print("onErr:$code - $mess");
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.enableAudio();

    await _engine.joinChannel(
      token: widget.config.rtcToken ?? "",
      channelId: widget.config.channelName ?? "",
      uid: userId, // viewer để 0
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final text = _controller.text.trim();

    chatSocket.socket?.emit("comment", {
      'channelName': widget.config.channelName ?? "",
      'message': text,
      "userId": 6,
      "userType": "patient",
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Detail")),
      body: Column(
        children: [
          // video chiếm 2/3
          Expanded(
            flex: 2,
            child: _remoteUid != null
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(
                        channelId: widget.config.channelName ?? "",
                      ),
                    ),
                  )
                : _joined
                    ? const Center(child: Text("Waiting for doctor to join..."))
                    : const Center(child: CircularProgressIndicator()),
          ),

          // list message chiếm 1/3
          Expanded(
            flex: 1,
            child: ListView.builder(
              reverse: true, // tin nhắn mới ở dưới cùng
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
               return Container(margin:EdgeInsets.only(left: 8), child: Text(msg.message));
              },
            ),
          ),

          // input
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: "Nhập nội dung"),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                    size: 24,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CommentMessage {
  final String message;
  final CommentUser user;
  final DateTime timestamp;

  CommentMessage({
    required this.message,
    required this.user,
    required this.timestamp,
  });

  factory CommentMessage.fromJson(Map<String, dynamic> json) {
    return CommentMessage(
      message: json['message'] ?? '',
      user: CommentUser.fromJson(json['user'] ?? {}),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "user": user.toJson(),
      "timestamp": timestamp.toIso8601String(),
    };
  }
}

class CommentUser {
  final int id;
  final String name;
  final String email;

  CommentUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
    };
  }
}
