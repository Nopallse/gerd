import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/info_tab_content.dart';

class GerdInformationPage extends StatefulWidget {
  const GerdInformationPage({super.key});

  @override
  State<GerdInformationPage> createState() => _GerdInformationPageState();
}

class _GerdInformationPageState extends State<GerdInformationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
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
        title: '/gerd-information',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            _buildTabBar(),
            
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  InfoTabContent.overview(),
                  InfoTabContent.symptoms(),
                  InfoTabContent.causes(),
                  InfoTabContent.complications(),
                  InfoTabContent.treatment(),
                  InfoTabContent.prevention(),
                  InfoTabContent.mealSchedule(),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

 


  Widget _buildStatCard(String number, String description) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
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
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 11.0,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      height: 45.0,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.book_outlined, size: 16.0),
                const SizedBox(width: 4.0),
                Text('Pengenalan'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_outlined, size: 16.0),
                const SizedBox(width: 4.0),
                Text('Gejala'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 16.0),
                const SizedBox(width: 4.0),
                Text('Penyebab'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 16.0),
                const SizedBox(width: 4.0),
                Text('Komplikasi'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.medical_services_outlined, size: 16.0),
                const SizedBox(width: 4.0),
                Text('Pengobatan'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined, size: 16.0),
                const SizedBox(width: 4.0),
                Text('Pencegahan'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, size: 16.0),
                const SizedBox(width: 4.0),
                Text('Jadwal Makan'),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
