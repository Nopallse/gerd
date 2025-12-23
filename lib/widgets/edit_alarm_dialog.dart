import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class EditAlarmDialog extends StatefulWidget {
  final Map<String, dynamic> alarm;
  final Function(Map<String, dynamic>) onUpdateAlarm;

  const EditAlarmDialog({
    super.key,
    required this.alarm,
    required this.onUpdateAlarm,
  });

  @override
  State<EditAlarmDialog> createState() => _EditAlarmDialogState();
}

class _EditAlarmDialogState extends State<EditAlarmDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  
  late String _selectedType;
  late TimeOfDay _selectedTime;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    
    // Initialize with current alarm data
    _titleController = TextEditingController(text: widget.alarm['title']);
    _descriptionController = TextEditingController(text: widget.alarm['description']);
    _selectedType = widget.alarm['type'];
    _isActive = widget.alarm['isActive'];
    
    // Parse time from string format
    if (widget.alarm['rawTime'] != null) {
      _selectedTime = widget.alarm['rawTime'];
    } else {
      // Parse time from string format (HH:MM)
      final timeParts = widget.alarm['time'].split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
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
    Color typeColor = _selectedType == 'meal' ? AppColors.healthGreen : AppColors.primary;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(
                        _selectedType == 'meal' ? Icons.restaurant : Icons.medication,
                        color: typeColor,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Alarm',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _selectedType == 'meal' ? 'Jadwal Makan' : 'Jadwal Obat',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: typeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20.0),
                
                // Title Input
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Nama Alarm',
                    hintText: 'Contoh: Sarapan Pagi',
                    prefixIcon: Icon(Icons.label_outline, color: typeColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: typeColor.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: typeColor, width: 2.0),
                    ),
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
                      border: Border.all(color: typeColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: typeColor),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Waktu Alarm',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              _selectedTime.format(context),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: typeColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.edit, color: AppColors.textTertiary, size: 16.0),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16.0),
                
                // Description Input
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Tambahkan catatan untuk alarm ini',
                    prefixIcon: Icon(Icons.description_outlined, color: typeColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: typeColor.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: typeColor, width: 2.0),
                    ),
                  ),
                  maxLines: 2,
                ),
                
                const SizedBox(height: 16.0),
                
                // Active Switch
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isActive ? Icons.notifications_active : Icons.notifications_off,
                        color: typeColor,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status Alarm',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _isActive ? 'Alarm aktif' : 'Alarm tidak aktif',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isActive,
                        onChanged: (bool value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: typeColor,
                      ),
                    ],
                  ),
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
                        onPressed: _updateAlarm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: typeColor,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 14.0,
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

  Future<void> _selectTime(BuildContext context) async {
    Color typeColor = _selectedType == 'meal' ? AppColors.healthGreen : AppColors.primary;
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: typeColor,
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

  void _updateAlarm() {
    if (_formKey.currentState!.validate()) {
      final updatedAlarm = Map<String, dynamic>.from(widget.alarm);
      updatedAlarm.addAll({
        'title': _titleController.text,
        'time': _selectedTime.format(context),
        'description': _descriptionController.text.isEmpty 
            ? 'Alarm ${_selectedType == 'meal' ? 'makan' : 'obat'}'
            : _descriptionController.text,
        'isActive': _isActive,
        'days': 'Setiap hari',
        'rawTime': _selectedTime,
      });
      
      widget.onUpdateAlarm(updatedAlarm);
      Navigator.pop(context);
    }
  }
}
