import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/question_card.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  int currentQuestionIndex = 0;
  Map<int, int> answers = {};

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Apakah kamu mengalami rasa sakit atau perih di lambung?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    },
    {
      'question': 'Apakah kamu sering merasa mulas?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    },
    {
      'question': 'Apakah kamu sering buang air besar terus-menerus?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    },
    {
      'question': 'Apakah kamu mengalami feses encer atau lembek?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    },
    {
      'question': 'Apakah kamu sering merasakan kram pada perut?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    },
    {
      'question': 'Apakah kamu merasa perut sering kembung?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    },
    {
      'question': 'Apakah kamu mengalami demam?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    },
    {
      'question': 'Apakah kamu sering merasa pegal-pegal di tubuh?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    },
    {
      'question': 'Apakah kamu mengalami tanda-tanda dehidrasi (seperti haus berlebihan atau bibir kering)?',
      'options': [
        'Sangat yakin mengalami gejala',
        'Yakin',
        'Ragu-ragu',
        'Tidak mengalami gejala'
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '/detection',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              const SizedBox(height: 24.0),
              
              // Progress Indicator
              ProgressIndicatorWidget(
                currentStep: currentQuestionIndex + 1,
                totalSteps: questions.length,
              ),
              
              const SizedBox(height: 24.0),
              
              // Question Card
              Expanded(
                child: QuestionCard(
                  question: questions[currentQuestionIndex]['question'],
                  options: questions[currentQuestionIndex]['options'],
                  selectedOption: answers[currentQuestionIndex],
                  onOptionSelected: (value) {
                    setState(() {
                      answers[currentQuestionIndex] = value;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 24.0),
              
              // Navigation Buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Text(
            'Deteksi GERD',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '${currentQuestionIndex + 1} dari ${questions.length}',
            style: TextStyle(
              fontSize: 16.0,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        // Tombol Sebelumnya
        if (currentQuestionIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  currentQuestionIndex--;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                side: BorderSide(color: AppColors.textTertiary),
                foregroundColor: AppColors.textTertiary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18),
                  const SizedBox(width: 8.0),
                  Text('Sebelumnya'),
                ],
              ),
            ),
          ),
        
        if (currentQuestionIndex > 0) const SizedBox(width: 16.0),
        
        // Tombol Selanjutnya atau Selesai
        Expanded(
          flex: currentQuestionIndex == 0 ? 1 : 1,
          child: ElevatedButton(
            onPressed: answers[currentQuestionIndex] != null
                ? _handleNextButton
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              disabledBackgroundColor: AppColors.buttonDisabled,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentQuestionIndex == questions.length - 1
                      ? 'Selesai'
                      : 'Selanjutnya',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8.0),
                Icon(
                  currentQuestionIndex == questions.length - 1
                      ? Icons.check
                      : Icons.arrow_forward,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleNextButton() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Tampilkan hasil
      _showResult();
    }
  }

  void _showResult() {
    // Convert index to score: index 0 = score 4, index 1 = score 3, index 2 = score 2, index 3 = score 1
    int totalScore = answers.values.fold(0, (sum, index) {
      int score = 4 - index; // Convert index to score
      return sum + score;
    });
    
    // Calculate percentage: (Total Score / 36) × 100
    double percentage = (totalScore / 36) * 100;
    int roundedPercentage = percentage.round();
    
    String resultTitle;
    String resultDescription;
    Color resultColor;

    if (percentage <= 40) {
      resultTitle = 'Tidak menderita GERD';
      resultDescription = 'Pasien tidak menunjukkan tanda GERD, cukup menjaga pola makan.';
      resultColor = AppColors.healthGreen;
    } else if (percentage <= 65) {
      resultTitle = 'Gejala ringan / indikasi awal';
      resultDescription = 'Pasien disarankan memantau kondisi dan mulai menghindari makanan pemicu asam lambung.';
      resultColor = AppColors.warningAmber;
    } else if (percentage <= 85) {
      resultTitle = 'Kemungkinan GERD sedang';
      resultDescription = 'Pasien disarankan berkonsultasi ke dokter untuk pemeriksaan lebih lanjut.';
      resultColor = AppColors.warningAmber;
    } else {
      resultTitle = 'Kemungkinan besar GERD';
      resultDescription = 'Pasien harus segera melakukan pemeriksaan medis untuk penanganan yang tepat.';
      resultColor = AppColors.dangerRed;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                Icons.assessment,
                color: resultColor,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              'Hasil Deteksi',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Text(
                    resultTitle,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Total Skor: $totalScore',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Persentase: $roundedPercentage%',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: resultColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              resultDescription,
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Hasil ini bukan pengganti diagnosis medis profesional.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Kembali ke Beranda',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to doctor consultation page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fitur konsultasi dokter akan segera hadir!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Konsultasi Dokter'),
          ),
        ],
      ),
    );
  }
}
