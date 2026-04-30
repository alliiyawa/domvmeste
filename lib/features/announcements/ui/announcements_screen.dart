import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:dom_vmeste/features/announcements/bloc/announcements_bloc.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_state.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_event.dart';
import 'package:dom_vmeste/features/announcements/ui/announcements_card.dart';
import 'package:dom_vmeste/core/services/cloudinary_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AnnouncementsScreen extends StatefulWidget {
  AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  File? selectedImage;
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1024,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _priceController = TextEditingController();
  final phoneMask = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _onAddPressed() async {
    print('selectedImage: $selectedImage');
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
      return;
    }
    String? imageUrl;
    if (selectedImage != null) {
      imageUrl = await CloudinaryService.uploadImage(selectedImage!);
    }

    context.read<AnnouncementsBloc>().add(
      AnnouncementsAddEvent(
        title: title,
        description: description,
        phone: _phoneController.text.trim(),
        price: _priceController.text.trim(),
        imageUrl: imageUrl,
      ),
    );
    selectedImage = null;
    _phoneController.clear();
    _priceController.clear();
    _titleController.clear();
    _descriptionController.clear();
    Navigator.of(context).pop();
  }

  void _showAddNewsSheet() {
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
                  const Text(
                    'Новое объявление',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
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
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 70, // сжимаем до 70% качества
                        maxWidth: 1024,
                      );
                      if (image != null) {
                        setModalState(() {
                          selectedImage = File(image.path);
                        });
                      }
                    },
                    child: const Text('Выбрать фото'),
                  ),
                  const SizedBox(height: 12),
                  if (selectedImage != null)
                    Image.file(selectedImage!, height: 120),
                  const SizedBox(height: 12),
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
                  TextField(
                    inputFormatters: [phoneMask],
                    controller: _phoneController,
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
                  const SizedBox(height: 12),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Цена',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _onAddPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
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

  Widget _buildBody(AnnouncementsState state) {
    if (state is AnnouncementLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AnnouncementsErrorState) {
      return Center(child: Text('Ошибка: ${state.message}'));
    }

    if (state is AnnouncementLoadedState && state.announcements.isEmpty) {
      return const Center(
        child: Text(
          'Объявлений пока нет.\nНажмите + чтобы добавить.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (state is AnnouncementLoadedState) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.announcements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = state.announcements[index];
          return AnnouncementsCard(
            id: item.id,
            title: item.title,
            description: item.description,
            date: DateFormat('dd.MM.yyyy').format(item.createdAt),
            phone: item.phone,
            price: item.price,
            imageUrl: item.imageUrl,
            onDelete: () {
              context.read<AnnouncementsBloc>().add(
                AnnouncementsDeleteEvent(id: item.id),
              );
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F5FA),
        title: const Text(
          'Объявления',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewsSheet,
        backgroundColor: Colors.blue[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }
}
