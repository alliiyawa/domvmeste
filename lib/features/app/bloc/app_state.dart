import 'package:dom_vmeste/data/models/user_models.dart';
import 'package:equatable/equatable.dart';

enum AppStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  final AppStatus status;
  final UserModel user;

  // ← убрали const везде, заменили на обычные конструкторы
  AppState({
    required this.status,
    UserModel? user,
  }) : user = user ?? UserModel.empty;

  // Начальное состояние
  AppState.unknown()
      : status = AppStatus.unknown,
        user = UserModel.empty;

  // Пользователь авторизован
  AppState.authenticated(this.user) : status = AppStatus.authenticated;

  // Пользователь не авторизован
  AppState.unauthenticated()
      : status = AppStatus.unauthenticated,
        user = UserModel.empty;

  @override
  List<Object?> get props => [status, user];
}