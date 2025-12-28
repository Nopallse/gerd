import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import '../themes/app_colors.dart';
import 'detection_page.dart';
import 'alarm_page.dart';
import 'doctor_profile_page.dart';
import 'food_recommendation_page.dart';
import 'gerd_information_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan logo dan nama aplikasi
              _buildHeader(),
              
              const SizedBox(height: 24.0),

              // Judul utama
              Text(
                'Selamat Datang di GERD Care',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 12.0),

              // Deskripsi aplikasi
              Text(
                'Aplikasi kesehatan untuk membantu Anda mengelola dan memahami GERD (Gastroesophageal Reflux Disease) dengan lebih baik',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 32.0),

              // Menu Items
              _buildMenuItems(context),

              const SizedBox(height: 32.0),

              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LOGO
        Image.asset(
          'assets/images/foods/logo-gerd.png',
          height: 150,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),

        // TITLE
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              color: AppColors.primary,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              'GERD Care',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6.0),

        // SUBTITLE
        Text(
          'Klinik Unimuda',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        // Menu Deteksi GERD
        MenuCard(
          icon: Icons.medical_services,
          title: 'Deteksi GERD',
          description:
              'Lakukan tes sederhana untuk mengetahui apakah Anda memiliki gejala GERD',
          subtitle:
              'Jawab beberapa pertanyaan sederhana untuk mendapatkan evaluasi awal mengenai kemungkinan Anda mengalami GERD.',
          buttonText: 'Mulai Deteksi GERD',
          buttonColor: AppColors.primary,
          onTap: () => _navigateToDetection(context),
        ),

        const SizedBox(height: 16.0),

        // Menu Profil Dokter
        MenuCard(
          icon: Icons.person_outline,
          title: 'Profil Dokter',
          description: 'Konsultasi dengan dokter ahli gastroenterologi',
          buttonText: 'Lihat Profil',
          buttonColor: Colors.white,
          textColor: AppColors.primary,
          borderColor: AppColors.primary,
          onTap: () => _navigateToDoctorProfile(context),
        ),

        const SizedBox(height: 16.0),

        // Menu Pengatur Alarm
        MenuCard(
          icon: Icons.access_time,
          title: 'Pengatur Alarm',
          description: 'Atur jadwal makan dan minum obat dengan alarm',
          buttonText: 'Atur Alarm',
          buttonColor: Colors.white,
          textColor: AppColors.primary,
          borderColor: AppColors.primary,
          onTap: () => _navigateToAlarm(context),
        ),

        const SizedBox(height: 16.0),

        // Menu Rekomendasi Makanan
        MenuCard(
          icon: Icons.restaurant_menu,
          title: 'Rekomendasi Makanan',
          description: 'Panduan makanan yang aman dan harus dihindari',
          buttonText: 'Lihat Rekomendasi',
          buttonColor: Colors.white,
          textColor: AppColors.primary,
          borderColor: AppColors.primary,
          onTap: () => _navigateToFoodRecommendation(context),
        ),

        const SizedBox(height: 16.0),

        // Menu Informasi GERD
        MenuCard(
          icon: Icons.info_outline,
          title: 'Informasi GERD',
          description:
              'Pelajari lebih lanjut tentang GERD, gejala, penyebab, dan cara penanganannya',
          buttonText: 'Baca Informasi',
          buttonColor: Colors.white,
          textColor: AppColors.primary,
          borderColor: AppColors.primary,
          onTap: () => _navigateToInformation(context),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 20.0),
              const SizedBox(width: 8.0),
              const Text(
                'GERD Care',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Aplikasi kesehatan untuk pengelolaan GERD yang lebih baik',
            style: TextStyle(fontSize: 12.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Navigation Methods
  void _navigateToDetection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetectionPage()),
    );
  }

  void _navigateToDoctorProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DoctorProfilePage()),
    );
  }

  void _navigateToAlarm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AlarmPage()),
    );
  }

  void _navigateToFoodRecommendation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FoodRecommendationPage()),
    );
  }

  void _navigateToInformation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GerdInformationPage()),
    );
  }
}
