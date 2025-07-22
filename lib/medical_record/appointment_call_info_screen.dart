import 'package:flutter/material.dart';
import '../widget/button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentCallInfoScreen extends StatelessWidget {
  const AppointmentCallInfoScreen({super.key});

  void _callNow(BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: '02432222944');
    await launchUrl(uri);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể thực hiện cuộc gọi.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0066CC);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hẹn khám qua điện thoại'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quý khách vui lòng liên hệ trực tiếp với bệnh viện để được hỗ trợ đặt lịch khám:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.phone, color: themeColor),
                        SizedBox(width: 12),
                        Text(
                          'Hotline: 024.32222944',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.access_time, color: themeColor),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Thời gian nhận cuộc gọi:\nThứ 2 - Thứ 7 (7:00 - 17:00)',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: themeColor),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Địa chỉ: Số 15A đường Phương Mai - Phường Kim Liên - Hà Nội',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SaveButton(
              title: "Gọi ngay",
              onPressed: () => _callNow(context),
              color: themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
