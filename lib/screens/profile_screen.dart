import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/medical_record/patient/patient_cubit.dart';
import 'package:urticaria/medical_record/update_patient_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0066CC);

    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Cá nhân', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("0342702597",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              _buildTile(context,
                  icon: Icons.person_outline,
                  label: 'Thông tin cá nhân', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<PatientProfileCubit>(),
                      child: UpdatePatientProfileScreen(),
                    ),
                  ),
                );
              }),
              _buildTile(context,
                  icon: Icons.settings_outlined,
                  label: 'Thiết lập',
                  onTap: () {}),
              _buildTile(context,
                  icon: Icons.lock_outline,
                  label: 'Cài đặt mật khẩu',
                  onTap: () {}),
              _buildTile(context,
                  icon: Icons.qr_code, label: 'Mã QR cá nhân', onTap: () {}),
              _buildTile(context,
                  icon: Icons.phone_outlined, label: 'Hotline', onTap: () {}),
              const SizedBox(height: 16),
              const SizedBox(height: 32),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Đăng xuất',
                    style: TextStyle(color: Colors.redAccent)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon, required String label, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black87),
          title: Text(label),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
