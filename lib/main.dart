import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:me_myself_ai/pages/forgot_password.dart';
import 'package:me_myself_ai/pages/login.dart';
import 'package:me_myself_ai/pages/phone_verification.dart';
import 'package:me_myself_ai/pages/signup.dart';
import 'package:me_myself_ai/pages/splash1.dart';
import 'package:me_myself_ai/pages/splash2.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      theme: AppTheme.lightTheme,
      initialRoute: '/splash1', // Set SplashScreen1 as initial route
      routes: {
        '/splash1': (context) => SplashScreen1(),
        '/splash2': (context) => SplashScreen2(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen() ,
        '/phone_verification': (context) => PhoneVerificationScreen(phoneNumber: '',) ,
      },
      debugShowCheckedModeBanner: false,
    );
  }
}