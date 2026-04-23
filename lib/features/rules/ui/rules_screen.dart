
import 'package:dom_vmeste/features/rules/ui/rules_card.dart';
import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Красивый AppBar с картинкой ───────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true, // AppBar остаётся видимым при скролле
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              color: Colors.grey,
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true, 
              title: const Text(
                'Правила проживания',
                style: TextStyle(
                  color: Color.fromARGB(255, 42, 41, 41),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              titlePadding: const EdgeInsets.only(bottom: 16),

              // Картинка по центру
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/svg/buildings.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
          ),

          // ── Список правил ─────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                RuleCard(
                  imagePath: 'assets/svg/moon.png',
                  title: 'Тишина и уважение',
                  subtitle: '23:00 - 08:00\nНе шуметь в ночное время',
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                RuleCard(
                  imagePath: 'assets/svg/garbage.png',
                  title: 'Чистота и порядок',
                  subtitle: 'Выбрасывать мусор в отведённые места',
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                RuleCard(
                  imagePath: 'assets/svg/animal.png',
                  title: 'Домашние животные',
                  subtitle: 'Убирать за питомцами',
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                RuleCard(
                  imagePath: 'assets/svg/car.png',
                  title: 'Парковка',
                  subtitle: 'Парковаться только в разрешенных местах',
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                RuleCard(
                  imagePath: 'assets/svg/hammer.png',
                  title: 'Ремонт и работы',
                  subtitle: '09:00 - 18:00 (будни)\nРемонт только в разрешенное время',
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                RuleCard(
                  imagePath: 'assets/svg/fire.png',
                  title: 'Безопасность',
                  subtitle: 'Не блокировать эвакуационные выходы',
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                RuleCard(
                  imagePath: 'assets/svg/people.png',
                  title: 'Гости и аренда',
                  subtitle: 'Ответственность за своих гостей',
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                RuleCard(
                  imagePath: 'assets/svg/green.svg',
                  title: 'Территория ЖК',
                  subtitle: 'Беречь газоны и площадки',
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                 RuleCard(
                  imagePath: 'assets/svg/chat.png',
                  title: 'Общение и конфликты',
                  subtitle: 'Решать вопросы мирно',
                  color: Colors.green,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
