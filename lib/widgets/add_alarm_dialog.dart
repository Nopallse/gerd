import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class AddAlarmDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddAlarm;
  final String? initialType; // 'meal' or 'medicine'

  const AddAlarmDialog({
    super.key,
    required this.onAddAlarm,
    this.initialType,
  });

  @override
  State<AddAlarmDialog> createState() => _AddAlarmDialogState();
}

class _AddAlarmDialogState extends State<AddAlarmDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedType = 'meal';
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isActive = true;

  final List<Map<String, dynamic>> _mealPresets = [
    {
      'title': 'Sarapan',
      'time': TimeOfDay(hour: 7, minute: 0),
      'description': 'Waktu sarapan sehat untuk penderita GERD',
    },
    {
      'title': 'Makan Siang',
      'time': TimeOfDay(hour: 12, minute: 0),
      'description': 'Waktu makan siang dengan porsi sedang',
    },
    {
      'title': 'Makan Malam',
      'time': TimeOfDay(hour: 18, minute: 0),
      'description': 'Makan malam ringan 3 jam sebelum tidur',
    },
    {
      'title': 'Snack Sehat',
      'time': TimeOfDay(hour: 15, minute: 0),
      'description': 'Camilan sehat untuk penderita GERD',
    },
  ];

  final List<Map<String, dynamic>> _medicinePresets = [
    {
      'title': 'Minum Obat PPI',
      'time': TimeOfDay(hour: 6, minute: 30),
      'description': 'Proton Pump Inhibitor sebelum sarapan',
    },
    {
      'title': 'Antasida',
      'time': TimeOfDay(hour: 14, minute: 0),
      'description': 'Antasida 1-2 jam setelah makan siang',
    },
    {
      'title': 'H2 Blocker',
      'time': TimeOfDay(hour: 21, minute: 0),
      'description': 'H2 Receptor Blocker sebelum tidur',
    },
    {
      'title': 'Obat Custom',
      'time': TimeOfDay(hour: 8, minute: 0),
      'description': 'Sesuai anjuran dokter',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.add_alarm,
                      color: AppColors.primary,
                      size: 24.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        'Tambah Alarm Baru',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20.0),
                
                // Type Selection
                Text(
                  'Jenis Alarm',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeCard(
                        type: 'meal',
                        icon: Icons.restaurant,
                        title: 'Jadwal Makan',
                        color: AppColors.healthGreen,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: _buildTypeCard(
                        type: 'medicine',
                        icon: Icons.medication,
                        title: 'Jadwal Obat',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20.0),
                
                // Preset Selection
                Text(
                  'Template ${_selectedType == 'meal' ? 'Makan' : 'Obat'}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildPresetSelection(),
                
                const SizedBox(height: 20.0),
                
                // Custom Input
                Text(
                  'Detail Alarm',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12.0),
                
                // Title Input
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Nama Alarm',
                    hintText: 'Contoh: Sarapan Pagi',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama alarm tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16.0),
                
                // Time Selection
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: AppColors.textSecondary),
                        const SizedBox(width: 12.0),
                        Text(
                          'Waktu: ${_selectedTime.format(context)}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary, size: 16.0),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16.0),
                
                // Description Input
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi (Opsional)',
                    hintText: 'Tambahkan catatan untuk alarm ini',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 2,
                ),
                
                const SizedBox(height: 16.0),
                
                // Active Switch
                Row(
                  children: [
                    Icon(Icons.notifications_active, color: AppColors.textSecondary),
                    const SizedBox(width: 12.0),
                    Text(
                      'Aktifkan alarm',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _isActive,
                      onChanged: (bool value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24.0),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.textTertiary),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveAlarm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text(
                          'Simpan Alarm',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required String type,
    required IconData icon,
    required String title,
    required Color color,
  }) {
    bool isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          // Clear form when switching types
          _titleController.clear();
          _descriptionController.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.greyLight,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.textSecondary,
              size: 24.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetSelection() {
    List<Map<String, dynamic>> presets = 
        _selectedType == 'meal' ? _mealPresets : _medicinePresets;
    
    return SizedBox(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: presets.length,
        itemBuilder: (context, index) {
          final preset = presets[index];
          return Container(
            width: 120.0,
            margin: EdgeInsets.only(right: index < presets.length - 1 ? 8.0 : 0),
            child: GestureDetector(
              onTap: () => _applyPreset(preset),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset['title'],
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      preset['time'].format(context),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      preset['description'],
                      style: TextStyle(
                        fontSize: 10.0,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _applyPreset(Map<String, dynamic> preset) {
    setState(() {
      _titleController.text = preset['title'];
      _selectedTime = preset['time'];
      _descriptionController.text = preset['description'];
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveAlarm() {
    if (_formKey.currentState!.validate()) {
      final newAlarm = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'type': _selectedType,
        'title': _titleController.text,
        'subtitle': _selectedType == 'meal' ? 'Waktu Makan' : 'Minum Obat',
        'time': _selectedTime.format(context),
        'description': _descriptionController.text.isEmpty 
            ? 'Alarm ${_selectedType == 'meal' ? 'makan' : 'obat'}'
            : _descriptionController.text,
        'isActive': _isActive,
        'days': 'Setiap hari',
        'icon': _selectedType == 'meal' ? Icons.restaurant : Icons.medication,
        'rawTime': _selectedTime,
      };
      
      widget.onAddAlarm(newAlarm);
      Navigator.pop(context);
    }
  }
}
