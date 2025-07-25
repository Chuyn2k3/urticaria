import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/bottom_nav/bottom_nav_page.dart';
import 'package:urticaria/booking/cubit/booking_cubit.dart';
import 'package:urticaria/chatbot/cubit/chatbot_cubit.dart';
import 'package:urticaria/emergency/cubit/emergency_cubit.dart';
import 'package:urticaria/medical_record/patient/patient_cubit.dart';
import 'package:urticaria/screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PatientProfileCubit()),
        BlocProvider(create: (context) => BookingCubit()),
        BlocProvider(create: (context) => ChatbotCubit()),
        BlocProvider(create: (context) => EmergencyCubit()),
      ],
      child: MaterialApp(
        title: 'Urticaria Care',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF0066CC),
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
