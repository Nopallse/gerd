import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/food_card.dart';

class FoodRecommendationPage extends StatefulWidget {
  const FoodRecommendationPage({super.key});

  @override
  State<FoodRecommendationPage> createState() => _FoodRecommendationPageState();
}

class _FoodRecommendationPageState extends State<FoodRecommendationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';

  final List<Map<String, dynamic>> recommendedFoods = [
    {
      'name': 'Bubur tanpa ayam',
      'category': 'Makanan Pokok',
      'description': 'Mudah dicerna, lembut untuk lambung, menenangkan sistem pencernaan',
      'tips': 'Bubur hangat lebih baik, hindari tambahan bumbu pedas atau asam',
      'benefits': ['Mudah dicerna', 'Menenangkan lambung', 'Mencegah iritasi'],
      'icon': Icons.rice_bowl,
      'image': 'assets/images/foods/bubur.jpg', // Placeholder, bisa diganti jika ada gambar bubur
    },
    {
      'name': 'Ubi/Kentang kukus',
      'category': 'Karbohidrat',
      'description': 'Alkaline, mudah dicerna, kaya serat dan nutrisi',
      'tips': 'Kukus tanpa kulit untuk hasil terbaik, hindari digoreng',
      'benefits': ['Alkaline alami', 'Sumber karbohidrat baik', 'Mudah dicerna'],
      'icon': Icons.grass,
      'image': 'assets/images/foods/kentang.jpg',
    },
    {
      'name': 'Nasi Sayur Sop (nasi merah)',
      'category': 'Makanan Utama',
      'description': 'Kombinasi nutrisi lengkap, serat tinggi, menenangkan lambung',
      'tips': 'Disarankan nasi merah, sayur sop tanpa tomat dan kubis',
      'benefits': ['Serat tinggi', 'Nutrisi lengkap', 'Menyerap asam lambung'],
      'icon': Icons.soup_kitchen,
      'image': 'assets/images/foods/nasi_sayur_sop.jpg', // Placeholder, bisa diganti jika ada gambar sop
    },
    {
      'name': 'Yoghurt',
      'category': 'Produk Susu',
      'description': 'Probiotik tinggi, menyeimbangkan bakteri baik di pencernaan',
      'tips': 'Pilih yoghurt tanpa pemanis berlebihan, konsumsi dalam suhu normal',
      'benefits': ['Probiotik', 'Menyeimbangkan pencernaan', 'Protein berkualitas'],
      'icon': Icons.breakfast_dining,
      'image': 'assets/images/foods/yogurt.jpeg', // Placeholder, bisa diganti jika ada gambar yoghurt
    },
    {
      'name': 'Susu Almond',
      'category': 'Minuman',
      'description': 'Alkaline, rendah lemak, tidak mengiritasi lambung',
      'tips': 'Pilih yang tanpa pemanis tambahan, bisa dikonsumsi hangat',
      'benefits': ['Alkaline', 'Rendah lemak', 'Kaya vitamin E'],
      'icon': Icons.local_drink,
      'image': 'assets/images/foods/susu_almond.jpg', // Placeholder, bisa diganti jika ada gambar susu almond
    },
    {
      'name': 'Sereal',
      'category': 'Sarapan',
      'description': 'Serat tinggi, mudah dicerna, sumber energi pagi',
      'tips': 'Pilih sereal rendah gula, tambahkan susu almond atau susu rendah lemak',
      'benefits': ['Serat tinggi', 'Energi', 'Mudah dicerna'],
      'icon': Icons.breakfast_dining,
      'image': 'assets/images/foods/sereal.jpg', // Placeholder, bisa diganti jika ada gambar sereal
    },
    {
      'name': 'Sandwich tanpa kubis dan tomat',
      'category': 'Makanan Ringan',
      'description': 'Praktis, bergizi, tanpa bahan pemicu asam lambung',
      'tips': 'Gunakan roti gandum, isi dengan daging tanpa lemak atau telur',
      'benefits': ['Praktis', 'Bergizi', 'Aman untuk GERD'],
      'icon': Icons.lunch_dining,
      'image': 'assets/images/foods/sandwich.jpg', // Placeholder, bisa diganti jika ada gambar sandwich
    },
    {
      'name': 'Oatmeal',
      'category': 'Sarapan',
      'description': 'Serat tinggi, mudah dicerna, menyerap asam lambung',
      'tips': 'Tambahkan buah-buahan non-asam seperti pisang matang',
      'benefits': ['Menyerap asam lambung', 'Sumber serat', 'Mudah dicerna'],
      'icon': Icons.grain,
      'image': 'assets/images/foods/oatmeal.jpg',
    },
    {
      'name': 'Salad tanpa kubis dan tomat',
      'category': 'Makanan Ringan',
      'description': 'Sayuran segar, serat tinggi, tanpa bahan pemicu GERD',
      'tips': 'Gunakan sayuran hijau segar, hindari dressing asam',
      'benefits': ['Serat tinggi', 'Vitamin dan mineral', 'Rendah kalori'],
      'icon': Icons.eco,
      'image': 'assets/images/foods/salad.jpg', // Placeholder, bisa diganti jika ada gambar salad
    },
  ];

  final List<Map<String, dynamic>> avoidFoods = [
    {
      'name': 'Coklat',
      'category': 'Dessert',
      'description': 'Mengandung kafein dan theobromine yang mengendurkan sfingter esofagus',
      'reason': 'Dapat mengendurkan sphincter esofagus dan memperparah gejala GERD',
      'alternatives': ['Buah segar non-asam', 'Yogurt', 'Pudding rendah lemak'],
      'icon': Icons.cake,
      'severity': 'high',
      'image': 'assets/images/foods/coklat.jpg',
    },
    {
      'name': 'Minuman Beralkohol dan Bersoda',
      'category': 'Minuman',
      'description': 'Merangsang produksi asam lambung dan mengiritasi dinding lambung',
      'reason': 'Alkohol dan soda dapat meningkatkan asam lambung dan memperlambat pengosongan lambung',
      'alternatives': ['Air putih', 'Susu almond', 'Teh herbal tanpa kafein'],
      'icon': Icons.local_bar,
      'severity': 'high',
      'image': 'assets/images/foods/minuman_bersoda.jpg',
    },
    {
      'name': 'Bawang-bawangan',
      'category': 'Bumbu',
      'description': 'Dapat meningkatkan produksi asam lambung dan menyebabkan iritasi',
      'reason': 'Bawang merah, bawang putih, dan bawang bombay dapat memperparah gejala GERD',
      'alternatives': ['Bumbu ringan', 'Herbal segar', 'Jahe (dalam jumlah kecil)'],
      'icon': Icons.restaurant,
      'severity': 'medium',
      'image': 'assets/images/foods/bawang.jpg', // Placeholder, bisa diganti jika ada gambar bawang
    },
    {
      'name': 'Pedas',
      'category': 'Bumbu',
      'description': 'Meningkatkan produksi asam lambung secara signifikan',
      'reason': 'Cabai dan rempah pedas dapat memperparah gejala GERD dan mengiritasi lambung',
      'alternatives': ['Bumbu ringan', 'Herbal segar', 'Rempah non-pedas'],
      'icon': Icons.whatshot,
      'severity': 'high',
      'image': 'assets/images/foods/pedas.jpeg',
    },
    {
      'name': 'Asam',
      'category': 'Makanan & Minuman',
      'description': 'Meningkatkan keasaman lambung dan mengiritasi dinding lambung',
      'reason': 'Makanan dan minuman asam dapat memperparah gejala GERD',
      'alternatives': ['Buah non-asam', 'Minuman alkaline', 'Makanan netral pH'],
      'icon': Icons.local_dining,
      'severity': 'high',
      'image': 'assets/images/foods/asam.jpg', // Placeholder, bisa diganti jika ada gambar makanan asam
    },
    {
      'name': 'Kopi',
      'category': 'Minuman',
      'description': 'Mengandung kafein tinggi yang meningkatkan produksi asam lambung',
      'reason': 'Kafein dapat mengendurkan sfingter esofagus dan memperparah GERD',
      'alternatives': ['Teh herbal', 'Susu almond', 'Air putih hangat'],
      'icon': Icons.local_cafe,
      'severity': 'high',
      'image': 'assets/images/foods/kopi.jpg', // Placeholder, bisa diganti jika ada gambar kopi
    },
    {
      'name': 'Tomat dan Kubis',
      'category': 'Sayuran',
      'description': 'Tinggi asam dan dapat menyebabkan gas berlebih',
      'reason': 'Tomat sangat asam sementara kubis dapat menyebabkan kembung dan gas',
      'alternatives': ['Sayuran hijau non-asam', 'Wortel', 'Kacang panjang'],
      'icon': Icons.eco,
      'severity': 'medium',
      'image': 'assets/images/foods/tomat_kubis.jpg', // Placeholder, bisa diganti jika ada gambar tomat/kubis
    },
    {
      'name': 'Tinggi Lemak',
      'category': 'Makanan',
      'description': 'Makanan tinggi lemak memperlambat pengosongan lambung dan meningkatkan risiko refluks',
      'reason': 'Makanan berlemak tinggi dapat memperlambat pengosongan lambung dan meningkatkan tekanan pada sfingter esofagus',
      'alternatives': ['Makanan rendah lemak', 'Protein tanpa lemak', 'Makanan yang dikukus atau direbus'],
      'icon': Icons.fastfood,
      'severity': 'high',
      'image': 'assets/images/foods/lemak.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '/food-recommendations',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Tab Bar
            _buildTabBar(),
            
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRecommendedTab(),
                  _buildAvoidTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Text(
            'Rekomendasi Makanan & Minuman',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Panduan lengkap makanan dan minuman yang aman dikonsumsi serta yang harus dihindari untuk penderita GERD',
            style: TextStyle(
              fontSize: 14.0,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari makanan atau minuman...',
          prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 16.0),
                const SizedBox(width: 8.0),
                Text('Direkomendasikan'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block, size: 16.0),
                const SizedBox(width: 8.0),
                Text('Hindari'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedTab() {
    final filteredFoods = recommendedFoods.where((food) {
      return searchQuery.isEmpty ||
          food['name'].toLowerCase().contains(searchQuery) ||
          food['category'].toLowerCase().contains(searchQuery);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.healthGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.healthGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.healthGreen, size: 24.0),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Makanan yang Direkomendasikan',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.healthGreen,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Makanan-makanan berikut aman dikonsumsi dan dapat membantu mengurangi gejala GERD',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          ...filteredFoods.map((food) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: FoodCard(
              food: food,
              isRecommended: true,
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAvoidTab() {
    final filteredFoods = avoidFoods.where((food) {
      return searchQuery.isEmpty ||
          food['name'].toLowerCase().contains(searchQuery) ||
          food['category'].toLowerCase().contains(searchQuery);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.dangerRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.dangerRed.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.block, color: AppColors.dangerRed, size: 24.0),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hindari Makanan',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dangerRed,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Makanan-makanan berikut dapat memperparah gejala GERD dan sebaiknya dihindari',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          ...filteredFoods.map((food) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: FoodCard(
              food: food,
              isRecommended: false,
            ),
          )).toList(),
        ],
      ),
    );
  }
}
