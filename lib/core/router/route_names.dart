/// Константы имён и путей маршрутов.
///
/// Используем константы вместо строк в коде, чтобы:
/// 1. Автодополнение IDE подсказывало имена.
/// 2. Опечатка вызовет ошибку компиляции, а не баг в рантайме.
/// 3. Переименование маршрута — в одном месте.
class RouteNames {
  // ── Пути (paths) — используем в context.go() ─────────────────

  /// Сплэш-экран (начальный маршрут).
  static const String splash = '/';

  /// Экран входа.
  static const String login = '/login';

  /// Экран регистрации.
  static const String register = '/register';

  /// Вкладка «Главная».
  static const String main = '/home/main';

  /// Вкладка «Профиль».
  static const String profile = '/home/profile';

  /// Экран новостей.
  static const String news = '/home/news';

  /// Экран объявлений.
  static const String announcements = '/home/announcements';

  /// Экран контактов.
  static const String contacts = '/home/contacts';

  // ── Имена (names) — используем в GoRoute(name: ...) ──────────
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String mainName = 'main';
  static const String profileName = 'profile';
  static const String newsName = 'news';
  static const String announcementsName = 'announcements';
  static const String contactsName = 'contacts';
  static const String announcementDetail = '/home/announcements/detail';
  static const String announcementDetailName = 'announcementDetail';
  static const String newsDetails = '/home/news/details';
  static const String newsDetailsName = 'newsDetails';
  static const String repair = '/home/repair';
  static const String repairName = 'repair';
  static const String lost = '/home/lost';
  static const String lostName = 'lost';
}
