import 'package:dom_vmeste/features/repair/bloc/repair_bloc.dart';
import 'package:dom_vmeste/features/repair/bloc/repair_event.dart';
import 'package:dom_vmeste/features/repair/bloc/repair_state.dart';
import 'package:dom_vmeste/features/repair/ui/create_request_screen.dart';
import 'package:dom_vmeste/features/repair/ui/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repair_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RepairScreen extends StatelessWidget {
  const RepairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
       backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(title: const Text('Ремонт', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),  backgroundColor: const Color(0xFFF2F5FA),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Услуги Ремонта',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                RepairCard(
                  icon: FontAwesomeIcons.wrench,
                  title: 'Вызвать Сантехника',
                  description: 'Протечки, краны,\nзамена труб',
                  color: Colors.blue[100]!,
                  iconColor: Colors.blue,
                  isEmergency: false,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CreateRequestScreen(repairType: 'Сантехника'),
                    ),
                  ),
                ),
                RepairCard(
                  icon: FontAwesomeIcons.plug,
                  title: 'Вызвать Электрика',
                  description: 'Розетки, свет,\nподключение техники',
                  color: Colors.yellow[100]!,
                  iconColor: Colors.orange,
                  isEmergency: false,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CreateRequestScreen(repairType: 'Электрика'),
                    ),
                  ),
                ),
                RepairCard(
                  icon: FontAwesomeIcons.building,
                  title: 'Общедомовые нужды',
                  description: 'Свет в подъезде,\nлифт, уборка',
                  color: Colors.green[100]!,
                  iconColor: Colors.green,
                  isEmergency: false,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateRequestScreen(
                        repairType: 'Общедомовые нужды',
                      ),
                    ),
                  ),
                ),
                RepairCard(
                  icon: FontAwesomeIcons.exclamationTriangle,
                  title: 'Аварийная служба',
                  description: 'Срочные аварии,\nзапах газа',
                  color: Colors.red[400]!,
                  iconColor: Colors.white,
                  isEmergency: true,
                  onPressed: () => _showEmergencyDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Мои заявки',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            BlocBuilder<RepairBloc, RepairState>(
              builder: (context, state) {
                if (state is RepairLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RepairErrorState) {
                  return Center(child: Text('Ошибка: ${state.message}'));
                }
                if (state is RepairLoadedState && state.requests.isEmpty) {
                  return const Center(
                    child: Text(
                      'Заявок пока нет',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                if (state is RepairLoadedState) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.requests[index];
                      return RequestCard(
                        request: item,
                        onDelete: () => context.read<RepairBloc>().add(
                          RepairDeleteEvent(id: item.id),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
   
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Номера экстренных служб:',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _EmergencyRow(name: 'Пожарная служба', number: '101'),
            _EmergencyRow(name: 'Полиция', number: '102'),
            _EmergencyRow(name: 'Скорая помощь', number: '103'),
            _EmergencyRow(name: 'Аварийная служба газа', number: '104'),
            _EmergencyRow(name: 'Служба спасения', number: '112'),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'ПОЗВОНИТЬ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyRow extends StatelessWidget {
  final String name;
  final String number;

  const _EmergencyRow({required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Colors.black),
              const SizedBox(width: 8),
              Text(name),
            ],
          ),
          Text(
            number,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
