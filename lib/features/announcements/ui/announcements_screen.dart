import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:dom_vmeste/features/announcements/bloc/announcements_bloc.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_state.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_event.dart';
import 'package:dom_vmeste/features/announcements/ui/announcements_card.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});
  
  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();


}

class _AnnouncementsScreenState extends State<AnnouncementsScreen>{
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onAddPressed() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    context.read<AnnouncementsBloc>().add(
      AnnouncementsAddEvent(title: title, description: description),
    );

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
                  'Добавить объявление',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
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
            title: item.title,
            description: item.description,
            date: DateFormat('dd.MM.yyyy').format(item.createdAt),
            onDelete: () {
              context.read<AnnouncementsBloc>().add(AnnouncementsDeleteEvent(id: item.id));
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
        title: const Text('Объявления'),
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
      body: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }
}

  
