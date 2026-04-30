import 'package:flutter/material.dart';
import 'package:dom_vmeste/core/services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  Map<String, bool> _settings = {
    'news': true,
    'announcements': true,
    'repair': true,
    'lost': true,
    'rules': true,
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await NotificationService.instance.getSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _toggleSetting(String key, bool value) async {
    setState(() => _settings[key] = value);
    await NotificationService.instance.saveSetting(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F5FA),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // ── Заголовок с иконкой ───────────────
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.notifications_active_outlined,
                              size: 48,
                              color: Colors.blue[400],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Уведомления',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Выберите, о каких событиях\nвы хотите получать уведомления',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Карточка настроек ─────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _SettingTile(
                          icon: Icons.campaign_outlined,
                          iconColor: Colors.blue,
                          bgColor: Colors.blue[50]!,
                          title: 'Важные объявления',
                          subtitle: 'Новости и важные объявления\nот управляющей компании',
                          value: _settings['news'] ?? true,
                          onChanged: (v) => _toggleSetting('news', v),
                          showDivider: true,
                        ),
                        _SettingTile(
                          icon: Icons.campaign_outlined,
                          iconColor: Colors.orange,
                          bgColor: Colors.orange[50]!,
                          title: 'Объявления',
                          subtitle: 'Новые объявления\nот жителей',
                          value: _settings['announcements'] ?? true,
                          onChanged: (v) => _toggleSetting('announcements', v),
                          showDivider: true,
                        ),
                        _SettingTile(
                          icon: Icons.build_outlined,
                          iconColor: Colors.green,
                          bgColor: Colors.green[50]!,
                          title: 'Заявки и обращения',
                          subtitle: 'Статусы заявок и ответы\nпо обращениям',
                          value: _settings['repair'] ?? true,
                          onChanged: (v) => _toggleSetting('repair', v),
                          showDivider: true,
                        ),
                        _SettingTile(
                          icon: Icons.search_outlined,
                          iconColor: Colors.purple,
                          bgColor: Colors.purple[50]!,
                          title: 'Потеряшки',
                          subtitle: 'Новые объявления о потерях\nи находках',
                          value: _settings['lost'] ?? true,
                          onChanged: (v) => _toggleSetting('lost', v),
                          showDivider: true,
                        ),
                        _SettingTile(
                          icon: Icons.rule_outlined,
                          iconColor: Colors.teal,
                          bgColor: Colors.teal[50]!,
                          title: 'Правила дома',
                          subtitle: 'Обновления правил\nпроживания',
                          value: _settings['rules'] ?? true,
                          onChanged: (v) => _toggleSetting('rules', v),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                 
                       
                  const SizedBox(height: 20),

                
                ],
              ),
            )
                
              );
        
    
  }
}

// ── Строка настройки ──────────────────────────────────────────────

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 25),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.blue[400],
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 70, endIndent: 30),
      ],
    );
  }
}