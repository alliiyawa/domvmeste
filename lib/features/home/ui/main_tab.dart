import 'package:dom_vmeste/core/router/route_names.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_bloc.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_state.dart';
import 'package:dom_vmeste/features/news/bloc/news_bloc.dart';
import 'package:dom_vmeste/features/news/bloc/news_state.dart';
import 'package:dom_vmeste/features/news/ui/news_card.dart';
import 'package:dom_vmeste/features/notifications/bloc/notifications_bloc.dart';
import 'package:dom_vmeste/features/notifications/bloc/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
  child: Container(
    color:const Color(0xFFF2F5FA),
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + 12,
      left: 20,
      right: 20,
      bottom: 16,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40),
        const Text(
          'Дом Вместе',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            final unreadCount = state is NotificationsLoadedState
                ? state.unreadCount
                : 0;
            return IconButton(
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text('$unreadCount'),
                child: const Icon(Icons.notifications_outlined),
              ),
              onPressed: () => context.push(RouteNames.notifications),
            );
          },
        ),
      ],
    ),
  ),
),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Кнопки быстрого доступа ───────────────
                Row(
                  children: [
                    Expanded(
                      child: _QuickButton(
                        icon: FontAwesomeIcons.wrench,
                        label: 'Ремонт',
                        color: Colors.blue[50]!,
                        iconColor: Colors.blue,
                        onTap: () => context.push(RouteNames.repair),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickButton(
                        icon: Icons.search_outlined,
                        label: 'Потеряшки',
                        color: Colors.blue[50]!,
                        iconColor: Colors.green,
                        onTap: () => context.push(RouteNames.lost),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickButton(
                        icon: FontAwesomeIcons.triangleExclamation,
                        label: 'Правила',
                        color: Colors.blue[50]!,
                        iconColor: Colors.orange,
                        onTap: () => context.push(RouteNames.rules),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Объявления ────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Объявления',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push(RouteNames.announcements),
                      label: const Icon(Icons.arrow_forward, size: 18),
                      icon: const SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

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
                      final items = state.announcements.take(3).toList();
                      return Column(
                        children: items
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _AnnouncementCard(
                                  title: item.title,
                                  description: item.description,
                                  imageUrl: item.imageUrl,
                                  createdAt: item.createdAt,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 8),

                // ── Новости ───────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Новости',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push(RouteNames.news),
                      label: const Icon(Icons.arrow_forward, size: 18),
                      icon: const SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoadingState ||
                        state is NewsInitialState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is NewsLoadedState && state.news.isEmpty) {
                      return const Text(
                        'Новостей пока нет',
                        style: TextStyle(color: Colors.grey),
                      );
                    }
                    if (state is NewsLoadedState) {
                      return Column(
                        children: state.news
                            .take(3)
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: NewsCard(
                                  id: item.id,
                                  title: item.title,
                                  description: item.description,
                                  imageUrl: item.imageUrl,
                                  date: DateFormat(
                                    'dd.MM.yyyy',
                                  ).format(item.createdAt),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Кнопка быстрого доступа ───────────────────────────────────────

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Карточка объявления ───────────────────────────────────────────

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;

  const _AnnouncementCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
    if (diff.inHours < 24) return '${diff.inHours} ч назад';
    return '${diff.inDays} дн назад';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Фото
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null && imageUrl!.startsWith('http')
                ? Image.network(
                    imageUrl!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_outlined, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Бейдж "Новое"
                
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 13, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      _timeAgo(createdAt),
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
