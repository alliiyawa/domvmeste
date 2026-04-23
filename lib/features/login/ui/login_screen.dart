import 'package:dom_vmeste/core/constants/app_constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/utils/logger.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../features/app/bloc/app_bloc.dart';
import '../../../features/app/bloc/app_state.dart';
import '../../../l10n/generated/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _onSignInPressed() async {
    setState(() => _isLoading = true);

    try {
      await AuthRepository.instance.signInWithGoogle();
    } catch (error) {
      AppLogger.error('Login error', error: error);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).signInError)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          context.go(RouteNames.main);
        }
      },

      child: Scaffold(
        backgroundColor: const Color(0xffF7FAFF),

        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Иконка/иллюстрация дома
                Center(
                      child: Image.asset('assets/svg/logo.png', width: 300),
                    ),
                  

                  const SizedBox(height: 20),

                  Text(
                    'Дом Вместе',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Управляйте домом и будьте\nв курсе всего важного',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 60),

                  /// Google button
                  InkWell(
                    onTap: _isLoading ? null : _onSignInPressed,

                    borderRadius: BorderRadius.circular(18),

                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            color: Colors.black12,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),

                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/google_logo.svg',
                                  width: 28,
                                  height: 28,
                                ),

                                const SizedBox(width: 14),

                                const Text(
                                  'Войти через Google',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    'Вход только через Google аккаунт',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
