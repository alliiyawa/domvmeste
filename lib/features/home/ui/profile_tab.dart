import 'package:dom_vmeste/features/app/bloc/app_bloc.dart';
import 'package:dom_vmeste/features/app/bloc/app_event.dart';
import 'package:dom_vmeste/features/profile/profile_bloc.dart';
import 'package:dom_vmeste/features/profile/profile_event.dart';
import 'package:dom_vmeste/features/profile/profile_state.dart';
import 'package:dom_vmeste/features/profile/ui/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileLoaded) {
          final user = state.user;
          final authUser = context.read<AppBloc>().state.user;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Профиль'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ── Аватар ────────────────────────────────
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: authUser.photoUrl.isNotEmpty
                        ? NetworkImage(authUser.photoUrl)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: authUser.photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 55, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // ── Имя ───────────────────────────────────
                  Text(
                    user.name.isNotEmpty ? user.name : authUser.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // ── Квартира + Подъезд ────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          label: 'Квартира:',
                          value: user.apartment.isNotEmpty
                              ? '№${user.apartment}'
                              : '—',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          label: 'Подъезд:',
                          value: user.entrance.isNotEmpty
                              ? user.entrance
                              : '—',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Телефон ───────────────────────────────
                  _InfoCard(
                    label: 'Номер телефона:',
                    value: user.phone.isNotEmpty ? user.phone : '—',
                  ),
                  const SizedBox(height: 12),

                  // ── Адрес ─────────────────────────────────
                  _InfoCard(
                    label: 'Дом:',
                    value: user.address.isNotEmpty ? user.address : '—',
                  ),
                  const SizedBox(height: 12),

                  // ── Интересы ──────────────────────────────
                  _InfoCard(
                    label: 'Интересы:',
                    value: user.interests.isNotEmpty
                        ? user.interests.join(', ')
                        : '—',
                  ),
                  const SizedBox(height: 24),

                  // ── Кнопка редактировать ──────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(user: user),
                          ),
                        );
                        if (updatedUser != null) {
                          context
                              .read<ProfileBloc>()
                              .add(UpdateProfile(updatedUser));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Редактировать профиль',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

            // ── Кнопка выйти ──────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Выйти из аккаунта?'),
                      content: const Text(
                        'Вы уверены что хотите выйти из Google аккаунта?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            context.read<AppBloc>().add(
                              const AppSignOutRequested(),
                            );
                          },
                          child: const Text(
                            'Выйти',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Выйти из аккаунта',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
                ],
              ),
            ),
          );
        }

        return const Center(child: Text('Загрузка профиля...'));
      },
    );
  }
}

// ── Карточка информации ───────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}