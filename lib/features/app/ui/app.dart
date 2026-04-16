import 'package:dom_vmeste/features/lost/bloc/lost_bloc.dart';
import 'package:dom_vmeste/features/lost/bloc/lost_event.dart';
import 'package:dom_vmeste/features/repair/bloc/repair_bloc.dart';
import 'package:dom_vmeste/features/repair/bloc/repair_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../features/news/bloc/news_bloc.dart';
import '../../../features/news/bloc/news_event.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/app_bloc.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_event.dart';
import 'package:dom_vmeste/features/announcements/bloc/announcements_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.create();

    return MultiBlocProvider(
      // MultiBlocProvider — когда нужно несколько BLoC на верхнем уровне.
      // Все экраны ниже имеют доступ к AppBloc и NewsBloc.
      providers: [
        BlocProvider(
          create: (_) => AppBloc(authRepository: AuthRepository.instance),
        ),
        BlocProvider(
          // Создаём NewsBloc и сразу загружаем новости.
          // cascade (..) — вызываем add() на том же объекте что создаём.
          create: (_) => NewsBloc()..add(NewsLoadEvent()),
        ),
        BlocProvider(
          create: (_) => AnnouncementsBloc()..add(AnnouncementLoadEvent()),
        ),
        BlocProvider(create: (_) => LostBloc()..add(LostLoadEvent())),
        BlocProvider(create: (_) => RepairBloc()..add(RepairLoadEvent())),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      ),
    );
  }
}
