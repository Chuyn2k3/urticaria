import 'package:flutter/material.dart';
import 'package:urticaria/business/page/patient_infomation.dart';
import '../../../../utils/colors.dart';
import '../../model/business_model.dart';
import '../widget/booking_history_item.dart';
import 'package:intl/intl.dart';

class BusinessListBooking extends StatefulWidget {
  BusinessListBooking({Key? key}) : super(key: key);

  @override
  State<BusinessListBooking> createState() => _BusinessListBookingState();
}

class _BusinessListBookingState extends State<BusinessListBooking> {
  DateTime? _fromDate;
  DateTime? _toDate;
  final List<BusinessModel> fakeBusinessList = List.generate(5, (index) {
    return BusinessModel(
      id: 'id_$index',
      xuTriType: 0,
      loai: 1,
      thoiGianRa:
          DateTime.now().subtract(Duration(days: index * 3)).toIso8601String(),
      moTaIcd: 'Chẩn đoán giả định $index',
    );
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PatientInformation(),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.calendar_month, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      'LỊCH SỬ KHÁM, CHỮA BỆNH',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // From date
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            initialDateRange:
                                _fromDate != null && _toDate != null
                                    ? DateTimeRange(
                                        start: _fromDate!, end: _toDate!)
                                    : null,
                          );

                          if (picked != null) {
                            setState(() {
                              _fromDate = picked.start;
                              _toDate = picked.end;
                            });
                          }
                        },
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _fromDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(_fromDate!)
                                      : 'Từ ngày',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const Icon(Icons.calendar_today, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // To date
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _toDate != null
                                    ? DateFormat('dd-MM-yyyy').format(_toDate!)
                                    : 'Đến ngày',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Search button
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: AppColors.primary),
                        ),
                        child:
                            const Icon(Icons.search, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Danh sách lịch sử
          ListView.builder(
            itemCount: fakeBusinessList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final exam = fakeBusinessList[index];
              return BookingHistoryItem(business: exam);
            },
          ),
        ],
      ),
    );
  }
}
