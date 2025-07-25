import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/chatbot/models/chat_model.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(ChatbotInitial());

  final List<ChatMessage> _messages = [];
  final List<FAQ> _faqs = [
    FAQ(
      id: '1',
      question: 'Làm thế nào để đặt lịch khám?',
      answer:
          'Bạn có thể đặt lịch khám bằng cách:\n1. Vào mục "Đặt lịch khám"\n2. Chọn bác sĩ phù hợp\n3. Chọn ngày và giờ khám\n4. Xác nhận thông tin',
      keywords: ['đặt lịch', 'khám', 'appointment', 'booking'],
      category: 'booking',
    ),
    FAQ(
      id: '2',
      question: 'Tôi cần chuẩn bị gì khi đến khám?',
      answer:
          'Khi đến khám, bạn cần mang theo:\n• Giấy tờ tùy thân (CMND/CCCD)\n• Thẻ bảo hiểm y tế (nếu có)\n• Kết quả xét nghiệm cũ (nếu có)\n• Danh sách thuốc đang sử dụng',
      keywords: ['chuẩn bị', 'giấy tờ', 'mang theo', 'khám'],
      category: 'preparation',
    ),
    FAQ(
      id: '3',
      question: 'Triệu chứng mày đay cấp tính là gì?',
      answer:
          'Mày đay cấp tính có các triệu chứng:\n• Nổi mẩn đỏ, ngứa\n• Sưng môi, mí mắt\n• Thời gian kéo dài < 6 tuần\n• Có thể do dị ứng thức ăn, thuốc',
      keywords: ['mày đay', 'cấp tính', 'triệu chứng', 'ngứa', 'sưng'],
      category: 'symptoms',
    ),
    FAQ(
      id: '4',
      question: 'Khi nào cần đến cấp cứu?',
      answer:
          'Bạn cần đến cấp cứu ngay khi có:\n• Khó thở, thở khò khè\n• Sưng mặt, cổ họng nghiêm trọng\n• Choáng váng, ngất xỉu\n• Nôn mửa liên tục',
      keywords: ['cấp cứu', 'khó thở', 'sưng', 'nguy hiểm', 'emergency'],
      category: 'emergency',
    ),
  ];

  void initializeChat() {
    _messages.clear();
    _messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message:
          'Xin chào! Tôi là trợ lý ảo của bệnh viện. Tôi có thể giúp bạn:\n\n• Đặt lịch khám\n• Trả lời câu hỏi về bệnh\n• Hướng dẫn sử dụng app\n• Hỗ trợ khẩn cấp\n\nBạn cần hỗ trợ gì?',
      isUser: false,
      timestamp: DateTime.now(),
      type: ChatMessageType.text,
    ));
    emit(ChatbotLoaded(_messages));
  }

  void sendMessage(String message) {
    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    emit(ChatbotLoaded(List.from(_messages)));

    // Process and respond
    _processMessage(message);
  }

  void _processMessage(String message) {
    emit(ChatbotTyping());

    Future.delayed(const Duration(seconds: 1), () {
      String response = _generateResponse(message);
      List<QuickReply>? quickReplies = _generateQuickReplies(message);

      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: response,
        isUser: false,
        timestamp: DateTime.now(),
        type: quickReplies != null
            ? ChatMessageType.quickReply
            : ChatMessageType.text,
        metadata: quickReplies != null ? {'quickReplies': quickReplies} : null,
      );

      _messages.add(botMessage);
      emit(ChatbotLoaded(List.from(_messages)));
    });
  }

  String _generateResponse(String message) {
    final lowerMessage = message.toLowerCase();

    // Check for emergency keywords
    if (_containsEmergencyKeywords(lowerMessage)) {
      return 'Tôi nhận thấy bạn có thể gặp tình huống khẩn cấp. Vui lòng:\n\n🚨 Gọi cấp cứu: 115\n🏥 Đến bệnh viện gần nhất\n📞 Liên hệ hotline: 1900-xxxx\n\nBạn có cần tôi hỗ trợ thêm không?';
    }

    // Search in FAQ
    for (final faq in _faqs) {
      if (faq.keywords.any((keyword) => lowerMessage.contains(keyword))) {
        return faq.answer;
      }
    }

    // Default responses based on keywords
    if (lowerMessage.contains('đặt lịch') || lowerMessage.contains('khám')) {
      return 'Tôi có thể giúp bạn đặt lịch khám. Bạn muốn:\n\n1. Xem danh sách bác sĩ\n2. Chọn ngày khám\n3. Hướng dẫn đặt lịch\n\nVui lòng chọn một tùy chọn.';
    }

    if (lowerMessage.contains('triệu chứng') || lowerMessage.contains('bệnh')) {
      return 'Tôi có thể cung cấp thông tin về các triệu chứng phổ biến của bệnh da liễu. Bạn quan tâm đến:\n\n• Mày đay cấp tính\n• Mày đay mạn tính\n• Viêm da dị ứng\n• Các bệnh da khác';
    }

    // Default response
    return 'Tôi hiểu bạn đang cần hỗ trợ. Dưới đây là một số câu hỏi thường gặp:\n\n• Làm thế nào để đặt lịch khám?\n• Triệu chứng mày đay là gì?\n• Cần chuẩn bị gì khi khám?\n• Khi nào cần cấp cứu?\n\nBạn có thể hỏi tôi bất kỳ điều gì!';
  }

  List<QuickReply>? _generateQuickReplies(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('đặt lịch')) {
      return [
        QuickReply(id: '1', text: 'Xem bác sĩ', action: 'view_doctors'),
        QuickReply(
            id: '2', text: 'Hướng dẫn đặt lịch', action: 'booking_guide'),
        QuickReply(id: '3', text: 'Liên hệ hỗ trợ', action: 'contact_support'),
      ];
    }

    if (lowerMessage.contains('triệu chứng')) {
      return [
        QuickReply(id: '1', text: 'Mày đay cấp', action: 'acute_urticaria'),
        QuickReply(id: '2', text: 'Mày đay mạn', action: 'chronic_urticaria'),
        QuickReply(id: '3', text: 'Tự kiểm tra', action: 'self_check'),
      ];
    }

    return null;
  }

  bool _containsEmergencyKeywords(String message) {
    final emergencyKeywords = [
      'khó thở',
      'thở khó',
      'ngạt thở',
      'sưng cổ',
      'sưng mặt',
      'choáng váng',
      'ngất',
      'nôn mửa',
      'cấp cứu',
      'khẩn cấp'
    ];

    return emergencyKeywords.any((keyword) => message.contains(keyword));
  }

  void handleQuickReply(String action) {
    String response = '';

    switch (action) {
      case 'view_doctors':
        response =
            'Đây là danh sách bác sĩ hiện có:\n\n👨‍⚕️ BS. Lê Thị Mai - Da liễu\n👨‍⚕️ BS. Nguyễn Văn Hùng - Da liễu\n👩‍⚕️ BS. Trần Thị Hương - Da liễu\n\nBạn có muốn đặt lịch với bác sĩ nào không?';
        break;
      case 'booking_guide':
        response =
            'Hướng dẫn đặt lịch khám:\n\n1️⃣ Chọn "Đặt lịch khám" ở trang chủ\n2️⃣ Chọn bác sĩ phù hợp\n3️⃣ Chọn ngày và giờ trống\n4️⃣ Xác nhận thông tin\n5️⃣ Nhận thông báo xác nhận\n\nBạn có cần hỗ trợ thêm không?';
        break;
      case 'acute_urticaria':
        response =
            'Mày đay cấp tính:\n\n🔸 Thời gian: < 6 tuần\n🔸 Triệu chứng: Nổi mẩn đỏ, ngứa\n🔸 Nguyên nhân: Dị ứng thức ăn, thuốc\n🔸 Điều trị: Thuốc kháng histamin\n\nNếu có triệu chứng nghiêm trọng, hãy đến khám ngay!';
        break;
      default:
        response =
            'Tôi sẽ hỗ trợ bạn với vấn đề này. Bạn có thể mô tả chi tiết hơn không?';
    }

    final botMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: response,
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(botMessage);
    emit(ChatbotLoaded(List.from(_messages)));
  }

  void connectToLiveAgent() {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message:
          'Đang kết nối bạn với nhân viên hỗ trợ... Vui lòng chờ trong giây lát.',
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(message);
    emit(ChatbotLoaded(List.from(_messages)));

    // Simulate connection to live agent
    Future.delayed(const Duration(seconds: 3), () {
      final agentMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message:
            'Xin chào! Tôi là nhân viên hỗ trợ Mai Anh. Tôi có thể giúp gì cho bạn?',
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(agentMessage);
      emit(ChatbotConnectedToAgent(List.from(_messages)));
    });
  }
}

abstract class ChatbotState {}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessage> messages;
  ChatbotLoaded(this.messages);
}

class ChatbotTyping extends ChatbotState {}

class ChatbotConnectedToAgent extends ChatbotState {
  final List<ChatMessage> messages;
  ChatbotConnectedToAgent(this.messages);
}

class ChatbotError extends ChatbotState {
  final String message;
  ChatbotError(this.message);
}
