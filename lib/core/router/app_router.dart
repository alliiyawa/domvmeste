import 'package:dom_vmeste/features/announcements/ui/announcement_detail_screen.dart';
import 'package:dom_vmeste/features/news/ui/news_details_screen.dart';
import 'package:dom_vmeste/features/repair/ui/repair_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/announcements/ui/announcements_screen.dart';
import '../../features/contacts/ui/contacts_screen.dart';
import '../../features/home/ui/home_shell.dart';
import '../../features/home/ui/main_tab.dart';
import '../../features/home/ui/profile_tab.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/news/ui/news_screen.dart';
import '../../features/register/ui/register_screen.dart';
import '../../features/splash/ui/splash_screen.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: RouteNames.splash,

      routes: [
        // ── Splash ───────────────────────────────────────────
        GoRoute(
          name: RouteNames.splashName,
          path: RouteNames.splash,
          builder: (context, state) => const SplashScreen(),
        ),

        // ── Login ────────────────────────────────────────────
        GoRoute(
          name: RouteNames.loginName,
          path: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),

        // ── Register ─────────────────────────────────────────
        GoRoute(
          name: RouteNames.registerName,
          path: RouteNames.register,
          builder: (context, state) => const RegisterScreen(),
        ),

        // ── Home (ShellRoute + BottomNav) ────────────────────
        ShellRoute(
          builder: (context, state, child) => HomeShell(child: child),
          routes: [
            GoRoute(
              name: RouteNames.mainName,
              path: RouteNames.main,
              builder: (context, state) => const MainTab(),
            ),
            GoRoute(
              name: RouteNames.profileName,
              path: RouteNames.profile,
              builder: (context, state) => const ProfileTab(),
            ),
            GoRoute(
              name: RouteNames.newsName,
              path: RouteNames.news,
              builder: (context, state) => const NewsScreen(),
            ),
            GoRoute(
              name: RouteNames.announcementsName,
              path: RouteNames.announcements,
              builder: (context, state) => AnnouncementsScreen(),
            ),
            GoRoute(
              name: RouteNames.announcementDetailName,
              path: RouteNames.announcementDetail,
              builder: (context, state) {
                // extra содержит данные переданные через context.push()
                final extra = state.extra as Map<String, dynamic>;
                return AnnouncementDetailScreen(
                  title: extra['title'] as String,
                  description: extra['description'] as String,
                  date: extra['date'] as String,
                  phone: extra['phone'] as String,
                  price: extra['price'] as String,
                  imageUrl: extra['imageUrl'] as String,
                );
              },
            ),
            GoRoute(
              name: RouteNames.newsDetailsName,
              path: RouteNames.newsDetails,
              builder: (context, state) {
                // extra содержит данные переданные через context.push()
                final extra = state.extra as Map<String, dynamic>;
                return NewsDetailsScreen(
                  title: extra['title'] as String,
                  description: extra['description'] as String,
                  date: extra['date'] as String,
                  imageUrl: extra['imageUrl'] as String,
                );
              },
            ),
            GoRoute(
              name: RouteNames.contactsName,
              path: RouteNames.contacts,
              builder: (context, state) => const ContactsScreen(),
            ),
            GoRoute(
              name: RouteNames.repairName,
              path: RouteNames.repair,
              builder: (context, state) => const RepairScreen(),
            ),
          ],
        ),
      ],

      // ── Страница ошибки (404) ─────────────────────────────
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text(
            'Страница не найдена: ${state.uri}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
