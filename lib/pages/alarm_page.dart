import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/alarm_card.dart';
import '../widgets/add_alarm_dialog.dart';
import '../widgets/edit_alarm_dialog.dart';
import '../core/services/alarm_service.dart';
import '../core/models/alarm_model.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final AlarmService _alarmService = AlarmService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '/alarm',
        onBackPressed: () => Navigator.pop(context),
        
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _alarmService,
          builder: (context, child) {
            if (_alarmService.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  
                  const SizedBox(height: 24.0),
                  
                  // Quick Add Buttons
                  _buildQuickAddButtons(),
                  
                  const SizedBox(height: 24.0),
                  
                  // Alarm List Section
                  _buildAlarmListSection(),
                  
                  const SizedBox(height: 24.0),
                  
                  // Tips Section
                  _buildTipsSection(),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAlarmDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Text(
            'Pengatur Alarm',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Atur jadwal makan dan minum obat untuk mengelola GERD',
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

  Widget _buildQuickAddButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickAddCard(
            icon: Icons.restaurant,
            title: 'Jadwal Makan',
            subtitle: 'Atur waktu sarapan, makan siang, dan makan malam',
            color: AppColors.healthGreen,
            onTap: () => _showAddMealAlarmDialog(),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: _buildQuickAddCard(
            icon: Icons.medication,
            title: 'Jadwal Obat',
            subtitle: 'Pengingat minum obat PPI dan antasida',
            color: AppColors.primary,
            onTap: () => _showAddMedicineAlarmDialog(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAddCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: color.withOpacity(0.3)),
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
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.0),
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.0,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmListSection() {
    final alarms = _alarmService.alarms;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, color: AppColors.primary, size: 20.0),
            const SizedBox(width: 8.0),
            Text(
              'Daftar Alarm (${alarms.length})',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        if (alarms.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.alarm_off,
                  size: 48.0,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Belum ada alarm',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Tambahkan alarm pertama Anda!',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          )
        else
          ...alarms.map((alarm) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: AlarmCard(
              alarm: alarm,
              onToggle: (bool value) => _toggleAlarm(alarm.id!, value),
              onEdit: () => _editAlarm(alarm),
              onDelete: () => _deleteAlarm(alarm.id!),
            ),
          )).toList(),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.info, size: 20.0),
              const SizedBox(width: 8.0),
              Text(
                'Tips Penggunaan Alarm',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          _buildTipItem('Jadwal Makan GERD'),
          _buildTipDetail('• Sarapan: 07:00 - 08:00'),
          _buildTipDetail('• Makan siang: 12:00 - 13:00'),
          _buildTipDetail('• Makan malam: 18:00 - 19:00'),
          _buildTipDetail('• Hindari makan 3 jam sebelum tidur'),
          const SizedBox(height: 8.0),
          _buildTipItem('Jadwal Obat'),
          _buildTipDetail('• PPI: 30-60 menit sebelum makan'),
          _buildTipDetail('• Antasida: 1-2 jam setelah makan'),
          _buildTipDetail('• H2 blocker: sebelum tidur'),
          _buildTipDetail('• Konsultasi dokter untuk dosis tepat'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTipDetail(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.0,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Future<void> _toggleAlarm(int id, bool value) async {
    final success = await _alarmService.toggleAlarm(id, value);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Alarm diaktifkan' : 'Alarm dinonaktifkan'),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal mengubah status alarm'),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    }
  }

  void _editAlarm(AlarmModel alarm) {
    showDialog(
      context: context,
      builder: (context) => EditAlarmDialog(
        alarm: _convertAlarmModelToMap(alarm),
        onUpdateAlarm: (Map<String, dynamic> updatedMap) => _updateAlarm(alarm, updatedMap),
      ),
    );
  }

  Future<void> _updateAlarm(AlarmModel originalAlarm, Map<String, dynamic> updatedMap) async {
    final updatedAlarm = originalAlarm.copyWith(
      title: updatedMap['title'],
      time: updatedMap['rawTime'],
      description: updatedMap['description'],
      isActive: updatedMap['isActive'],
      updatedAt: DateTime.now(),
    );
    
    final success = await _alarmService.updateAlarm(updatedAlarm);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alarm "${updatedAlarm.title}" berhasil diperbarui!'),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal memperbarui alarm'),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    }
  }

  void _deleteAlarm(int id) {
    final alarm = _alarmService.getAlarmById(id);
    if (alarm == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Alarm'),
        content: Text('Apakah Anda yakin ingin menghapus alarm "${alarm.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await _alarmService.deleteAlarm(id);
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Alarm "${alarm.title}" berhasil dihapus'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Gagal menghapus alarm'),
                    backgroundColor: AppColors.dangerRed,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerRed),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAddAlarmDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAlarmDialog(
        onAddAlarm: _addNewAlarm,
      ),
    );
  }

  void _showAddMealAlarmDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAlarmDialog(
        onAddAlarm: _addNewAlarm,
        initialType: 'meal',
      ),
    );
  }

  void _showAddMedicineAlarmDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAlarmDialog(
        onAddAlarm: _addNewAlarm,
        initialType: 'medicine',
      ),
    );
  }

  Future<void> _addNewAlarm(Map<String, dynamic> newAlarmMap) async {
    final alarm = await _alarmService.addAlarm(
      type: newAlarmMap['type'],
      title: newAlarmMap['title'],
      subtitle: newAlarmMap['subtitle'],
      time: newAlarmMap['rawTime'],
      description: newAlarmMap['description'],
      isActive: newAlarmMap['isActive'],
      icon: newAlarmMap['icon'],
    );
    
    if (alarm != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alarm "${alarm.title}" berhasil ditambahkan!'),
          backgroundColor: AppColors.primary,
          action: SnackBarAction(
            label: 'Test',
            textColor: Colors.white,
            onPressed: () {
              _alarmService.showTestNotification();
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal menambahkan alarm'),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    }
  }

  // Helper method to convert AlarmModel to Map for compatibility with existing widgets
  Map<String, dynamic> _convertAlarmModelToMap(AlarmModel alarm) {
    return {
      'id': alarm.id,
      'type': alarm.type,
      'title': alarm.title,
      'subtitle': alarm.subtitle,
      'time': alarm.timeString,
      'description': alarm.description,
      'isActive': alarm.isActive,
      'days': alarm.days,
      'icon': alarm.getIcon(),
      'rawTime': alarm.time,
    };
  }
}
