import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/colors.dart';
import '../../../utils/styles.dart';

class PatientInformation extends StatefulWidget {
  const PatientInformation({Key? key}) : super(key: key);

  @override
  State<PatientInformation> createState() => _PatientInformationState();
}

class _PatientInformationState extends State<PatientInformation> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: AppColors.lightSilver,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề + nút thu gọn
          Row(
            children: [
              Expanded(
                child: Text('I. Thông tin người bệnh', style: Styles.titleItem),
              ),
              IconButton(
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              )
            ],
          ),
          const Divider(color: AppColors.primary),
          if (_isExpanded) ...[
            _renderValueInformation("Họ và tên: ", 'Phạm Viết Chuyên', context),
            _renderValueInformation("Mã: ", '19001011', context),
            _renderValueInformation(
                "Ngày sinh: ", formatDateSafe("2025-05-07T17:07:33"), context),
            _renderValueInformation("Điện thoại: ", '111111111', context),
            _renderValueInformation("Địa chỉ: ", 'HN', context),
          ]
        ],
      ),
    );
  }

  String formatDateSafe(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'Không rõ';
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return 'Không rõ';
    }
  }

  Widget _renderValueInformation(
      String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width / 3,
            ),
            child: Text(title, style: Styles.content),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Styles.titleItem,
            ),
          )
        ],
      ),
    );
  }
}
