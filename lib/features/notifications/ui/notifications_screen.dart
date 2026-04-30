import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:dom_vmeste/core/router/route_names.dart';
import 'package:dom_vmeste/features/notifications/bloc/notifications_bloc.dart';
import 'package:dom_vmeste/features/notifications/bloc/notifications_event.dart';
import 'package:dom_vmeste/features/notifications/bloc/notifications_state.dart';
import 'notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedTab = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F5FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Заголовок ─────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Уведомления',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Табы ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  _TabButton(
                    label: 'Все',
                    isSelected: _selectedTab == 'all',
                    onTap: () => setState(() => _selectedTab = 'all'),
                  ),
                  _TabButton(
                    label: 'Непрочитанные',
                    isSelected: _selectedTab == 'unread',
                    onTap: () => setState(() => _selectedTab = 'unread'),
                  ),
                  _TabButton(
                    label: 'Важные',
                    isSelected: _selectedTab == 'important',
                    onTap: () => setState(() => _selectedTab = 'important'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Список уведомлений ─────────────────────────
          Expanded(
            child: BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is NotificationsErrorState) {
                  return Center(child: Text('Ошибка: ${state.message}'));
                }

                if (state is NotificationsLoadedState) {
                  final notifications = switch (_selectedTab) {
                    'unread' => state.unread,
                    'important' => state.important,
                    _ => state.notifications,
                  };

                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/svg/google_logo.svg',
                            height: 80,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.notifications_none,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Здесь будут появляться\nновые уведомления',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationCard(
                        notification: notification,
                        onTap: () {
                          if (!notification.isRead) {
                            context.read<NotificationsBloc>().add(
                              NotificationsMarkAsReadEvent(
                                notificationId: notification.id,
                              ),
                            );
                          }
                        },
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[400] : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}