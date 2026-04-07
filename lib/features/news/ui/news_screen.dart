import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dom_vmeste/features/news/bloc/news_bloc.dart';
import 'package:dom_vmeste/features/news/bloc/news_state.dart';
import 'package:dom_vmeste/features/news/bloc/news_event.dart';
import 'package:dom_vmeste/features/news/ui/news_card.dart';
import 'package:dom_vmeste/core/services/cloudinary_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onAddPressed() async {
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

    context.read<NewsBloc>().add(
      NewsAddEvent(title: title, description: description, imageUrl: imageUrl),
    );
    selectedImage = null;
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
                    'Новая новость',
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
                      'Добавить новость',
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

  Widget _buildBody(NewsState state) {
    if (state is NewsLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is NewsErrorState) {
      return Center(child: Text('Ошибка: ${state.message}'));
    }

    if (state is NewsLoadedState && state.news.isEmpty) {
      return const Center(
        child: Text(
          'Новостей пока нет.\nНажмите + чтобы добавить.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (state is NewsLoadedState) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.news.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = state.news[index];
          return NewsCard(
            id: item.id,
            title: item.title,
            description: item.description,
            imageUrl: item.imageUrl,
            date: DateFormat('dd.MM.yyyy').format(item.createdAt),
            onDelete: () {
              context.read<NewsBloc>().add(NewsDeleteEvent(id: item.id));
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
      appBar: AppBar(
        title: const Text('Новости'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewsSheet,
        backgroundColor: Colors.blue[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }
}
