import 'package:ashil_school/data/repositories/authentication_repository.dart';
import 'package:ashil_school/models/user_model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;

    return Obx(() {
      final User? user = authRepo.currentUser.value;
      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // قسم الرأس مع خلفية ملونة
              _buildProfileHeader(context, user),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    // قسم معلومات الحساب
                    _buildSectionTitle(context, "معلومات الحساب"),
                    const SizedBox(height: 10),
                    _buildInfoCard(context, user),

                    const SizedBox(height: 30),

                    // زر تسجيل الخروج
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            user.fullName ?? "غير متوفر",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            user.role?.name ?? "غير متوفر",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, User user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            _buildListTile(
              context,
              icon: Icons.person_outline,
              title: "اسم المستخدم",
              subtitle: user.fullName ?? "غير متوفر",
            ),
            _buildListTile(
              context,
              icon: Icons.phone_outlined,
              title: "رقم الهاتف",
              subtitle: user.phone ?? "غير متوفر",
            ),
            _buildListTile(
              context,
              icon: Icons.date_range_outlined,
              title: "تاريخ الإنشاء",
              subtitle: user.createdAt?.toLocal().toString().split(' ')[0] ??
                  "غير متوفر",
            ),
            // يمكنك إضافة حقول أخرى هنا
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        AuthenticationRepository.instance.signOut();
      },
      icon: const Icon(Icons.logout),
      label: const Text("تسجيل الخروج"),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
