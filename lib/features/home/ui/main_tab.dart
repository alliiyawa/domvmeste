import 'package:dom_vmeste/core/router/route_names.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_bloc.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_state.dart';
import 'package:dom_vmeste/features/news/bloc/news_bloc.dart';
import 'package:dom_vmeste/features/news/bloc/news_event.dart';
import 'package:dom_vmeste/features/news/bloc/news_state.dart';
import 'package:dom_vmeste/features/news/ui/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../features/app/bloc/app_bloc.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../widgets/user_avatar.dart';

/// Вкладка «Главная» — приветствие с именем и аватаром пользователя.
///
/// Читает данные из [AppBloc] через `context.watch`.
class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем объект локализации — содержит геттеры и методы для строк.
    // Для строк без параметров — геттеры (loc.tabMain).
    // Для строк с параметрами — методы (loc.greeting(name)).
    final loc = AppLocalizations.of(context);
    final appState = context.watch<AppBloc>().state;
    final user = appState.user;

    // Получаем текстовые стили из темы — это правильный подход.
    // Стили определены в AppTheme.light → textTheme, а виджеты
    // обращаются к ним через Theme.of(context).textTheme.
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('ЖК Delta'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _QuickButton(
                  icon: Icons.build_outlined,
                  label: 'Ремонт',
                  onTap: () {},
                ),
                _QuickButton(
                  icon: Icons.search_outlined,
                  label: 'Потеряшки',
                  onTap: () {},
                ),
                _QuickButton(
                  icon: Icons.phone_outlined,
                  label: 'Контакты',
                  onTap: () => context.push(RouteNames.contacts),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.largePadding),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Объявления', style: textTheme.titleLarge),
                TextButton.icon(
                  onPressed: () => context.push(RouteNames.announcements),
                  label: const Icon(Icons.arrow_forward),
                  icon: const SizedBox.shrink(),
                ),
              ],
            ),
            BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
              builder: (context, state) {
                if (state is AnnouncementLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AnnouncementLoadedState &&
                    state.announcements.isEmpty) {
                  return const Text(
                    'Объявлений пока нет',
                    style: TextStyle(color: Colors.grey),
                  );
                }

                if (state is AnnouncementLoadedState) {
                  // Показываем максимум 5 объявлений на главном экране
                  final items = state.announcements.take(5).toList();
                  return SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return _AnnouncementCard(title: items[index].title);
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: AppConstants.largePadding),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Новости', style: textTheme.titleLarge),
                TextButton.icon(
                  onPressed: () => context.push(RouteNames.news),
                  label: const Icon(Icons.arrow_forward),
                  icon: const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoadingState || state is NewsInitialState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is NewsLoadedState && state.news.isEmpty) {
                  return const Text(
                    'Новостей пока нет',
                    style: TextStyle(color: Colors.grey),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  itemCount: (state as NewsLoadedState).news.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = state.news[index];
                    return NewsCard(
                      title: item.title,
                      description: item.description,
                      date: DateFormat('dd.MM.yyyy').format(item.createdAt),
                      onDelete: () {
                        context.read<NewsBloc>().add(
                          NewsDeleteEvent(id: item.id),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title;

  const _AnnouncementCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фото заглушка сверху
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 17),
            maxLines: 1,
          
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final String date;

  const _NewsCard({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Описание текста\nв 2 строки',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
