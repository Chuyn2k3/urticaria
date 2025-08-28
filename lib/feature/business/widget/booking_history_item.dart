import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urticaria/models/business_model.dart';
import '../../../constant/color.dart';
import '../page/business_detail_screen.dart';

class BookingHistoryItem extends StatelessWidget {
  final BusinessModel business;

  const BookingHistoryItem({
    super.key,
    required this.business,
  });

  @override
  Widget build(BuildContext context) {
    final examDate = business.thoiGianRa != null &&
            business.thoiGianRa!.isNotEmpty
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(business.thoiGianRa!))
        : '';

    final status =
        (business.sinhHieuChamSocDto as Map<String, dynamic>?)?['status'] ??
            'pending';
    final symptoms =
        (business.sinhHieuChamSocDto as Map<String, dynamic>?)?['symptoms'] ??
            '';
    final images = (business.sinhHieuChamSocDto
            as Map<String, dynamic>?)?['images'] as List<dynamic>? ??
        [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusinessDetailScreen(
                  idBusiness: business.id,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12), // Giảm từ 16
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        business.key ?? 'Không xác định',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildStatusChip(status),
                  ],
                ),
                const SizedBox(height: 6),
                if (symptoms.isNotEmpty) ...[
                  Text(
                    symptoms,
                    style: const TextStyle(
                      fontSize: 14, // giảm từ 16
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
                if (business.moTaIcd?.isNotEmpty == true) ...[
                  Row(
                    children: [
                      Icon(Icons.medical_information,
                          color: Colors.grey.shade600, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          business.moTaIcd!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                if (business.vao?.isNotEmpty == true) ...[
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey.shade600, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        business.vao!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                if (images.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.photo_library,
                          color: Colors.grey.shade600, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${images.length} hình ảnh',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Icon(Icons.access_time,
                        color: Colors.grey.shade600, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      examDate.isNotEmpty ? examDate : 'Chưa xác định',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Text(
                          'Chi tiết',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.chevron_right,
                            size: 14, color: AppColors.primaryColor),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        statusText = 'Chờ khám';
        break;
      case 'inProgress':
        statusColor = Colors.blue;
        statusIcon = Icons.medical_services;
        statusText = 'Đang khám';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Hoàn thành';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Đã hủy';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Không xác định';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 14),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
