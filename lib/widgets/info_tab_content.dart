import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class InfoTabContent {
    static Widget mealSchedule() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              title: 'Aturan Waktu Makan Pengidap GERD',
              titleIcon: Icons.schedule,
              titleColor: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengidap penyakit asam lambung sebaiknya sarapan sebelum pukul 9 pagi, makan berat pukul 12 atau 1 siang dan ditutup pukul 6 hingga 7 untuk makan malam. Jadwal tersebut disesuaikan dengan waktu pengosongan lambung sekitar 3 sampai 4 jam.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Setelah sarapan atau jam makan siang, pengidap juga bisa mengonsumsi camilan sehat dengan tinggi kandungan serat, seperti pepaya atau melon. Jenis asupan ini bisa membuat rasa kenyang bertahan lama.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  static Widget overview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // What is GERD Card
          _buildCard(
            title: 'Apa itu GERD?',
            titleIcon: Icons.book,
            titleColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GERD (Gastroesophageal Reflux Disease) adalah kondisi kronis di mana asam lambung naik kembali ke esofagus (kerongkongan), menyebabkan iritasi dan peradangan. Kondisi ini terjadi ketika otot sfingter esofagus bagian bawah (LES) tidak berfungsi dengan baik.',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Berbeda dengan refluks asam sesekali yang normal, GERD adalah kondisi yang terjadi secara teratur dan dapat mengganggu kualitas hidup serta menyebabkan komplikasi serius jika tidak ditangani.',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Anatomy and Mechanism Card
          _buildCard(
            title: 'Anatomi dan Mekanisme GERD',
            titleIcon: Icons.medical_services,
            titleColor: AppColors.primary,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Organ yang Terlibat',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          _buildBulletPoint('Esofagus: Saluran yang menghubungkan mulut ke lambung'),
                          _buildBulletPoint('LES: Otot cincin di ujung bawah esofagus'),
                          _buildBulletPoint('Lambung: Organ yang memproduksi asam pencernaan'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Proses Normal vs GERD',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.healthGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.healthGreen, size: 16.0),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Normal: LES menutup rapat setelah makanan masuk ke lambung',
                          style: TextStyle(fontSize: 12.0, color: AppColors.healthGreen),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: AppColors.dangerRed, size: 16.0),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'GERD: LES melemah atau rileks tidak normal, asam naik ke esofagus',
                          style: TextStyle(fontSize: 12.0, color: AppColors.dangerRed),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget symptoms() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Main Symptoms Card
          _buildCard(
            title: 'Gejala Utama GERD',
            titleIcon: Icons.warning_amber,
            titleColor: AppColors.warningAmber,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gejala Umum',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          _buildSymptomItem(Icons.local_fire_department, 'Heartburn', 'Rasa terbakar di dada, terutama setelah makan'),
                          _buildSymptomItem(Icons.keyboard_arrow_up, 'Regurgitasi', 'Asam atau makanan naik ke mulut'),
                          _buildSymptomItem(Icons.restaurant_menu, 'Disfagia', 'Kesulitan menelan makanan atau minuman'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Gejala Tambahan',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildSymptomItem(Icons.sick, 'Batuk Kronis', 'Terutama di malam hari'),
                _buildSymptomItem(Icons.record_voice_over, 'Suara Serak', 'Akibat iritasi pita suara'),
                _buildSymptomItem(Icons.favorite_border, 'Nyeri Dada', 'Dapat menyerupai nyeri jantung'),
              ],
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // When to See Doctor Card
          _buildCard(
            title: 'Kapan Harus ke Dokter?',
            titleIcon: Icons.schedule,
            titleColor: AppColors.dangerRed,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.dangerRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Segera konsultasi ke dokter jika mengalami:',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dangerRed,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  _buildWarningPoint('Gejala terjadi lebih dari 2 kali seminggu'),
                  _buildWarningPoint('Kesulitan menelan yang memburuk'),
                  _buildWarningPoint('Penurunan berat badan tanpa sebab jelas'),
                  _buildWarningPoint('Muntah darah atau tinja berwarna hitam'),
                  _buildWarningPoint('Nyeri dada hebat yang tidak kunjung hilang'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget causes() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Causes Card
          _buildCard(
            title: 'Penyebab GERD',
            titleIcon: Icons.info,
            titleColor: AppColors.primary,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Faktor Anatomi',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          _buildBulletPoint('Kelemahan otot LES (Lower Esophageal Sphincter)'),
                          _buildBulletPoint('Hernia hiatus (lambung naik ke rongga dada)'),
                          _buildBulletPoint('Pengosongan lambung yang lambat'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Faktor Gaya Hidup',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildBulletPoint('Makan berlebihan atau terlalu cepat'),
                _buildBulletPoint('Berbaring setelah makan'),
                _buildBulletPoint('Konsumsi makanan pemicu (pedas, asam, berlemak)'),
              ],
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Risk Factors Card
          _buildCard(
            title: 'Faktor Risiko',
            titleIcon: Icons.warning,
            titleColor: AppColors.warningAmber,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildRiskFactorCategory(
                        'Usia & Jenis Kelamin',
                        ['Usia > 40 tahun', 'Pria lebih berisiko', 'Wanita hamil'],
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: _buildRiskFactorCategory(
                        'Kondisi Medis',
                        ['Obesitas', 'Diabetes', 'Asma', 'Scleroderma'],
                        AppColors.warningAmber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                _buildRiskFactorCategory(
                  'Obat-obatan',
                  ['Aspirin', 'NSAID', 'Calcium channel blockers', 'Antidepresan'],
                  AppColors.dangerRed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget complications() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: 'Komplikasi GERD',
            titleIcon: Icons.favorite,
            titleColor: AppColors.dangerRed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GERD yang tidak ditangani dengan baik dapat menyebabkan komplikasi serius:',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildComplicationItem(
                  'Esofagitis',
                  'Peradangan dan iritasi pada dinding esofagus akibat paparan asam berulang',
                  AppColors.dangerRed,
                ),
                const SizedBox(height: 12.0),
                _buildComplicationItem(
                  'Striktur Esofagus',
                  'Penyempitan esofagus akibat jaringan parut, menyebabkan kesulitan menelan',
                  AppColors.dangerRed,
                ),
                const SizedBox(height: 12.0),
                _buildComplicationItem(
                  'Barrett\'s Esophagus',
                  'Perubahan sel-sel esofagus yang dapat meningkatkan risiko kanker',
                  AppColors.dangerRed,
                ),
                const SizedBox(height: 12.0),
                _buildComplicationItem(
                  'Masalah Pernapasan',
                  'Asma, pneumonia aspirasi, dan masalah paru-paru lainnya',
                  AppColors.dangerRed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget treatment() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: 'Pilihan Pengobatan GERD',
            titleIcon: Icons.medical_services,
            titleColor: AppColors.healthGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lifestyle Changes
                Text(
                  '1. Perubahan Gaya Hidup',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.healthGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildTreatmentPoint('Makan porsi kecil tapi sering')),
                          Expanded(child: _buildTreatmentPoint('Hindari makanan pemicu')),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Expanded(child: _buildTreatmentPoint('Tidak berbaring setelah makan')),
                          Expanded(child: _buildTreatmentPoint('Tinggikan kepala saat tidur')),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Expanded(child: _buildTreatmentPoint('Turunkan berat badan jika berlebih')),
                          Expanded(child: _buildTreatmentPoint('Berhenti merokok dan alkohol')),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16.0),
                
                // Medications
                Text(
                  '2. Obat-obatan',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildMedicationCard('Antasida', 'Menetralkan asam lambung untuk relief cepat', AppColors.primary),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: _buildMedicationCard('H2 Blockers', 'Mengurangi produksi asam lambung', AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                _buildMedicationCard('PPI', 'Proton Pump Inhibitor, menghambat produksi asam', AppColors.primary),
                
                const SizedBox(height: 16.0),
                
                // Surgery
                Text(
                  '3. Tindakan Bedah',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fundoplication: Dipertimbangkan jika obat tidak efektif atau ada komplikasi serius',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warningAmber,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Konsultasi dengan dokter spesialis gastroenterologi untuk evaluasi lebih lanjut',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget prevention() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: 'Pencegahan GERD',
            titleIcon: Icons.shield,
            titleColor: AppColors.healthGreen,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.healthGreen, size: 16.0),
                              const SizedBox(width: 8.0),
                              Text(
                                'Yang Harus Dilakukan',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          _buildPreventionItem(true, 'Makan 3-4 jam sebelum tidur'),
                          _buildPreventionItem(true, 'Kunyah makanan perlahan dan sampai halus'),
                          _buildPreventionItem(true, 'Pertahankan berat badan ideal'),
                          _buildPreventionItem(true, 'Tidur dengan kepala lebih tinggi'),
                          _buildPreventionItem(true, 'Olahraga teratur (tidak setelah makan)'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.cancel, color: AppColors.dangerRed, size: 16.0),
                              const SizedBox(width: 8.0),
                              Text(
                                'Yang Harus Dihindari',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          _buildPreventionItem(false, 'Makan berlebihan dalam satu waktu'),
                          _buildPreventionItem(false, 'Berbaring atau tidur setelah makan'),
                          _buildPreventionItem(false, 'Merokok dan konsumsi alkohol'),
                          _buildPreventionItem(false, 'Pakaian ketat di area perut'),
                          _buildPreventionItem(false, 'Stres berlebihan tanpa manajemen'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Healthy Living Tips
          _buildCard(
            title: 'Tips Hidup Sehat dengan GERD',
            titleIcon: Icons.favorite,
            titleColor: AppColors.primary,
            child: Row(
              children: [
                Expanded(
                  child: _buildHealthyTipCard(Icons.restaurant_menu, 'Pola Makan', 'Atur jadwal makan teratur dengan porsi kecil'),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildHealthyTipCard(Icons.favorite, 'Aktivitas Fisik', 'Olahraga ringan dan manajemen stres'),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildHealthyTipCard(Icons.medical_services, 'Kontrol Rutin', 'Konsultasi berkala dengan dokter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  static Widget _buildCard({
    required String title,
    required IconData titleIcon,
    required Color titleColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [titleColor, titleColor.withOpacity(0.8)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Row(
              children: [
                Icon(titleIcon, color: Colors.white, size: 20.0),
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ],
      ),
    );
  }

  static Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4.0,
            height: 4.0,
            margin: const EdgeInsets.only(top: 6.0, right: 8.0),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.0,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSymptomItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.warningAmber, size: 16.0),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildWarningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.0,
                color: AppColors.dangerRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRiskFactorCategory(String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 6.0),
          ...items.map((item) => Text(
            '• $item',
            style: TextStyle(
              fontSize: 11.0,
              color: color,
            ),
          )).toList(),
        ],
      ),
    );
  }

  static Widget _buildComplicationItem(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 4.0)),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.0,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTreatmentPoint(String text) {
    return Text(
      '• $text',
      style: TextStyle(
        fontSize: 11.0,
        color: AppColors.healthGreen,
      ),
    );
  }

  static Widget _buildMedicationCard(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 10.0,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildPreventionItem(bool isPositive, String text) {
    Color color = isPositive ? AppColors.healthGreen : AppColors.dangerRed;
    IconData icon = isPositive ? Icons.check : Icons.close;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 12.0),
          const SizedBox(width: 6.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.0,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildHealthyTipCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 16.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 10.0,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
