import 'dart:io';

import 'package:dom_vmeste/features/repair/bloc/repair_bloc.dart';
import 'package:dom_vmeste/features/repair/bloc/repair_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dom_vmeste/core/services/cloudinary_service.dart';

class CreateRequestScreen extends StatefulWidget {
  final String repairType;

  const CreateRequestScreen({super.key, required this.repairType});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTimeFrom;
  TimeOfDay? _selectedTimeTo;

  // Список выбранных фото (макс 3)
  final List<File> _selectedImages = [];
  bool _isUploading = false;

  final List<String> _repairTypes = [
    'Сантехника',
    'Электрика',
    'Общедомовые нужды',
    
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.repairType.isNotEmpty
        ? widget.repairType
        : _repairTypes.first;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Выбор фото из галереи
  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Максимум 3 фото')));
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1024,
    );

    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _selectedTimeFrom = picked;
        } else {
          _selectedTimeTo = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Выберите дату';
    return '${date.day} ${_monthName(date.month)}, ';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _onSubmit() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Опишите проблему')));
      return;
    }

    setState(() => _isUploading = true);

    // Загружаем все фото на Cloudinary
    final List<String> imageUrls = [];
    for (final image in _selectedImages) {
      final url = await CloudinaryService.uploadImage(image);
      if (url != null) imageUrls.add(url);
    }

    setState(() => _isUploading = false);

    print('Загруженные фото: $imageUrls');

    // Логика сохранения в Firestore будет добавлена позже
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заявка отправлена!')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ремонт')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Создать заявку',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ── Тип ремонта ───────────────────────────────
            const Text(
              'Тип ремонта',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  isExpanded: true,
                  items: _repairTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedType = value),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Описание ──────────────────────────────────
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Опишите проблему',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
// ── ДАТА ─────────────────────────────────────
const Text(
  'Дата',
  style: TextStyle(fontWeight: FontWeight.w600),
),
const SizedBox(height: 8),
GestureDetector(
  onTap: _pickDate,
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          _formatDate(_selectedDate),
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 20),

// ── ВРЕМЯ ─────────────────────────────────────
const Text(
  'Время',
  style: TextStyle(fontWeight: FontWeight.w600),
),
const SizedBox(height: 8),

Row(
  children: [
    // Время С
    Expanded(
      child: GestureDetector(
        onTap: () => _pickTime(true),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                _selectedTimeFrom == null
                    ? 'С --:--'
                    : 'С ${_formatTime(_selectedTimeFrom)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ),
    

    const SizedBox(width: 10),

    // Время ДО
    Expanded(
      child: GestureDetector(
        onTap: () => _pickTime(false),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                _selectedTimeTo == null
                    ? 'До --:--'
                    : 'До ${_formatTime(_selectedTimeTo)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),
            const SizedBox(height: 20),

            // ── Фото / Видео ──────────────────────────────
            const Text(
              'Фото / Видео',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Кнопка выбора фото
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Icon(Icons.videocam_outlined, color: Colors.grey),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Прикрепить файл', style: TextStyle(fontSize: 17)),
                        Text(
                          '(макс. 3 фото)',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Превью выбранных фото
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Кнопка удалить фото
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedImages.removeAt(index));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),

            // ── Адрес ─────────────────────────────────────
            const Text('Адрес', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Ваш адрес',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: const Icon(Icons.edit_outlined, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Кнопка отправить ──────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onAddPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Отправить заявку',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAddPressed() async {
    if (_selectedDate == null ||
    _selectedTimeFrom == null ||
    _selectedTimeTo == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Выберите дату и время')),
  );
  return;
}
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Опишите проблему')));
      return;
    }

    setState(() => _isUploading = true);

    // 1. Загружаем фото
    final List<String> imageUrls = [];
    for (final image in _selectedImages) {
      final url = await CloudinaryService.uploadImage(image);
      if (url != null) imageUrls.add(url);
    }

    setState(() => _isUploading = false);

    // 2. Отправляем в BLoC
    context.read<RepairBloc>().add(
      RepairAddEvent(
        repairType: _selectedType ?? '',
        description: _descriptionController.text.trim(),
        date: _selectedDate?.toIso8601String() ?? '',
        timeFrom: _formatTime(_selectedTimeFrom),
        timeTo: _formatTime(_selectedTimeTo),
        address: _addressController.text.trim(),
        imageUrls: imageUrls,
      ),
    );

    
  }
}
