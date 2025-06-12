import 'package:flutter/material.dart';
import '../../models/route_model.dart';
import '../../services/api_service.dart';

class RouteAdminScreen extends StatefulWidget {
  const RouteAdminScreen({super.key});

  @override
  State<RouteAdminScreen> createState() => _RouteAdminScreenState();
}

class _RouteAdminScreenState extends State<RouteAdminScreen> {
  List<RouteModel> routes = [];

  final _nameCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _destinationCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  void _loadRoutes() async {
    routes = await ApiService.fetchRoutes();
    setState(() {});
  }

  void _addRoute() async {
    await ApiService.createRoute(
      name: _nameCtrl.text.trim(),
      origin: _originCtrl.text.trim(),
      destination: _destinationCtrl.text.trim(),
    );
    _nameCtrl.clear();
    _originCtrl.clear();
    _destinationCtrl.clear();
    _loadRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý tuyến xe")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("➕ Thêm tuyến mới", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Tên tuyến")),
            TextField(controller: _originCtrl, decoration: const InputDecoration(labelText: "Điểm đi")),
            TextField(controller: _destinationCtrl, decoration: const InputDecoration(labelText: "Điểm đến")),
            ElevatedButton(onPressed: _addRoute, child: const Text("Thêm")),
            const Divider(),
            const Text("📋 Danh sách tuyến", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  final r = routes[index];
                  return ListTile(
                    title: Text("${r.origin} → ${r.destination}"),
                    subtitle: Text(r.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}