// screens/booking_history_screen.dart
import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final TextEditingController phoneController = TextEditingController();
  List<BookingModel> bookings = [];

  void fetchHistory() async {
    final result = await ApiService.fetchBookings(phoneController.text.trim());
    setState(() {
      bookings = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lịch sử đặt vé")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Nhập SĐT"),
              keyboardType: TextInputType.phone,
            ),
            ElevatedButton(onPressed: fetchHistory, child: const Text("Tra cứu")),
            const SizedBox(height: 20),
            Expanded(
              child: bookings.isEmpty
                  ? const Text("Không có vé")
                  : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final b = bookings[index];
                        return ListTile(
                          title: Text("Ghế: ${b.seatNumber}"),
                          subtitle: Text("Lịch chạy ID: ${b.scheduleId}"),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}