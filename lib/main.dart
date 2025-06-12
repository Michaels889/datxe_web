import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/admin/route_admin_screen.dart';
import 'screens/driver_schedule_screen.dart';

void main() {
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(
        onLoginSuccess: (role, username) {
          if (role == 'admin') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RouteAdminScreen()),
            );
          } else if (role == 'driver') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DriverScheduleScreen(username: username)),
            );
          }
        },
      ),
    );
  }
}