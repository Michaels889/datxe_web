// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';
import '../models/schedule_model.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://localhost:8000"; // Thay bằng IP VPS nếu cần

class ApiService {
  static Future<List<RouteModel>> fetchRoutes() async {
    final response = await http.get(Uri.parse('$baseUrl/booking/routes'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((r) => RouteModel.fromJson(r)).toList();
    } else {
      throw Exception('Failed to load routes');
    }
  }

  static Future<List<ScheduleModel>> fetchSchedules(int routeId) async {
    final response = await http.get(Uri.parse('$baseUrl/booking/schedules?route_id=$routeId'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((s) => ScheduleModel.fromJson(s)).toList();
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  static Future<bool> bookSeat({
    required int scheduleId,
    required int seatNumber,
    required String name,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/booking/book'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "schedule_id": scheduleId,
        "seat_number": seatNumber,
        "customer_name": name,
        "customer_phone": phone,
      }),
    );
    return response.statusCode == 200 && !response.body.contains("error");
  }

  static Future<List<BookingModel>> fetchBookings(String phone) async {
    final response = await http.get(Uri.parse('$baseUrl/booking/history?phone=$phone'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((b) => BookingModel.fromJson(b)).toList();
    } else {
      return [];
    }
  }
  static Future<bool> createRoute({
    required String name,
    required String origin,
    required String destination,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/booking/routes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "origin": origin,
        "destination": destination,
      }),
    );
    return response.statusCode == 200;
  }
  static Future<bool> createSchedule({
    required int routeId,
    required String departureTime,
    required int availableSeats,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/booking/schedules'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "route_id": routeId,
        "departure_time": departureTime,
        "available_seats": availableSeats,
      }),
    );
    return response.statusCode == 200;
  }
  static Future<List<ScheduleModel>> fetchDriverSchedules(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/driver/schedules?username=$username'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((s) => ScheduleModel.fromJson(s)).toList();
    } else {
      return [];
    }
  }
}  