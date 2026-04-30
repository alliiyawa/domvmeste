import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dom_vmeste/core/services/cloudinary_service.dart';
import 'package:dom_vmeste/features/lost/bloc/lost_bloc.dart';
import 'package:dom_vmeste/features/lost/bloc/lost_event.dart';
import 'package:dom_vmeste/features/lost/bloc/lost_state.dart';
import 'package:dom_vmeste/features/app/bloc/app_bloc.dart';
import 'lost_card.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LostScreen extends StatefulWidget {
  const LostScreen({super.key});

  @override
  State<LostScreen> createState() => _LostScreenState();
}

class _LostScreenState extends State<LostScreen> {
  // Текущий выбранный таб: 'lost', 'found', 'entrance'
  String _selectedCategory = 'lost';

  // Контроллеры формы
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
 final phoneMask = MaskTextInputFormatter(
  mask: '+7 (###) ###-##-##',
  filter: { "#": RegExp(r'[0-9]') },
);
final _phoneController = TextEditingController();

  File? _selectedImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
   _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(StateSetter setModalState) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1024,
    );
    if (image != null) {
      setModalState(() => _selectedImage = File(image.path));
    }
  }

  Future<void> _onAddPressed(String category) async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final phone = _phoneController.text.trim();
    final authorName = context.read<AppBloc>().state.user.name;

    if (title.isEmpty || description.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
      return;
    }

    setState(() => _isUploading = true);

    String imageUrl = '';
    if (_selectedImage != null) {
      imageUrl = await CloudinaryService.uploadImage(_selectedImage!) ?? '';
    }

    setState(() => _isUploading = false);

    if (!mounted) return;

    context.read<LostBloc>().add(
      LostAddEvent(
        title: title,
        description: description,
        authorName: authorName,
        phone: phone,
        imageUrl: imageUrl,
        category: category,
      ),
    );

    _titleController.clear();
    _descriptionController.clear();
    _phoneController.clear();
    _selectedImage = null;
    phoneMask.clear();

    Navigator.of(context).pop();
  }

  void _showAddSheet() {
    final category = _selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    category == 'lost'
                        ? 'Потеряно'
                        : category == 'found'
                        ? 'Найдено'
                        : 'Подъезд',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Заголовок
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Заголовок',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Описание
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Описание',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Телефон
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      inputFormatters: [phoneMask],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+7 (___) ___-__-__',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),



                  // Кнопка фото
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(setModalState),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Выбрать фото'),
                  ),

                  if (_selectedImage != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Кнопка добавить
                  ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () => _onAddPressed(category),
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
                            'Добавить объявление',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(backgroundColor: const Color(0xFFF2F5FA),
        title: const Text('Потеряшки', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Табы ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _TabButton(
                  label: 'Потеряно',
                  isSelected: _selectedCategory == 'lost',
                  onTap: () => setState(() => _selectedCategory = 'lost'),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  label: 'Найдено',
                  isSelected: _selectedCategory == 'found',
                  onTap: () => setState(() => _selectedCategory = 'found'),
                ),
               
              ],
            ),
          ),

          // ── Кнопка добавить ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddSheet,
                icon: const Icon(Icons.add),
                label: const Text('Добавить объявление'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Список ────────────────────────────────────
          Expanded(
            child: BlocBuilder<LostBloc, LostState>(
              builder: (context, state) {
                if (state is LostLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is LostErrorState) {
                  return Center(child: Text('Ошибка: ${state.message}'));
                }

                if (state is LostLoadedState) {
                  // Фильтруем по выбранному табу
                  final filtered = state.items
                      .where((i) => i.category == _selectedCategory)
                      .toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        'Объявлений пока нет',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return LostCard(
                        item: filtered[index],
                        onDelete: () => context.read<LostBloc>().add(
                          LostDeleteEvent(id: filtered[index].id),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Кнопка таба ──────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[300] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue[300],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
