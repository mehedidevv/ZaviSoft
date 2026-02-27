
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft/widget/customText.dart';
import '../controllers/auth_controller.dart';

class ProfileScreen extends GetView<AuthController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  CustomText(
            text: 'My Profile',
          fontSize: 20,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text('No user data'));
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFFE53935),
                child: Text(
                  user.firstname.isNotEmpty ? user.firstname[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 36, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                '@${user.username}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            _infoCard([
              _infoRow(Icons.email, 'Email', user.email),
              _infoRow(Icons.phone, 'Phone', user.phone),
              _infoRow(Icons.location_city, 'City', user.city),
              _infoRow(Icons.home, 'Street', user.street),
            ]),
          ],
        );
      }),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: children),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE53935)),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(
        value.isEmpty ? 'N/A' : value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
