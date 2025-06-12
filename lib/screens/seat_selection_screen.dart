// screens/seat_selection_screen.dart
import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  final int scheduleId;

  const SeatSelectionScreen({super.key, required this.scheduleId});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final int totalSeats = 20;
  Set<int> selectedSeats = {};

  // Giả định danh sách ghế đã đặt – sau này thay bằng API thực tế
  final Set<int> bookedSeats = {3, 7, 13};

  void toggleSeat(int seatNumber) {
    setState(() {
      if (selectedSeats.contains(seatNumber)) {
        selectedSeats.remove(seatNumber);
      } else {
        selectedSeats.add(seatNumber);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn ghế")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: totalSeats,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 ghế mỗi hàng
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final seatNumber = index + 1;
                final isBooked = bookedSeats.contains(seatNumber);
                final isSelected = selectedSeats.contains(seatNumber);

                return GestureDetector(
                  onTap: isBooked ? null : () => toggleSeat(seatNumber),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isBooked
                          ? Colors.grey
                          : isSelected
                              ? Colors.green
                              : Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$seatNumber",
                      style: TextStyle(
                        color: isBooked ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: selectedSeats.isEmpty
                  ? null
                  : () {
                      // TODO: Gửi API đặt vé
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Đã đặt ${selectedSeats.length} ghế: ${selectedSeats.join(", ")}"),
                        ),
                      );
                    },
              child: const Text("Xác nhận đặt vé"),
			  TextEditingController nameController = TextEditingController();
              TextEditingController phoneController = TextEditingController();
            ),
          )
        ],
      ),
    );
  }
}