import 'package:dom_vmeste/data/models/user_models.dart';
import 'package:dom_vmeste/features/app/bloc/app_bloc.dart';
import 'package:dom_vmeste/features/app/bloc/app_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController apartmentController;
  late TextEditingController entranceController;
  late TextEditingController addressController;
  late TextEditingController interestsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    phoneController = TextEditingController(text: widget.user.phone);
    apartmentController = TextEditingController(text: widget.user.apartment);
    entranceController = TextEditingController(text: widget.user.entrance);
    addressController = TextEditingController(text: widget.user.address);
    interestsController = TextEditingController(
      text: widget.user.interests.join(', '),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    apartmentController.dispose();
    entranceController.dispose();
    addressController.dispose();
    interestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.read<AppBloc>().state.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        title: const Text(
          'Редактирование профиля',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF2F5FA),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Аватар ────────────────────────────────────
            Stack(
              alignment: Alignment.bottomRight,
              children: [
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
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Сменить фото', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // ── Имя ───────────────────────────────────────
            _buildField('Имя', nameController, Icons.edit_outlined),
            const SizedBox(height: 12),

            // ── Квартира + Подъезд ────────────────────────
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    'Квартира',
                    apartmentController,
                    null,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    'Подъезд',
                    entranceController,
                    null,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildField(
              'Телефон',
              phoneController,
              null,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            // ── Адрес ─────────────────────────────────────
            _buildField('Адрес', addressController, Icons.edit_outlined),
            const SizedBox(height: 12),

            // ── Интересы ──────────────────────────────────
            TextField(
              controller: interestsController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Мои интересы',
                hintText: 'Опишите ваши увлечения, хобби...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Кнопка сохранить ──────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final updatedUser = UserModel(
                    id: widget.user.id,
                    email: widget.user.email,
                    photoUrl: widget.user.photoUrl,
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    apartment: apartmentController.text.trim(),
                    entrance: entranceController.text.trim(),
                    address: addressController.text.trim(),
                    interests: interestsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                  );
                  Navigator.pop(context, updatedUser);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Сохранить', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),

            // ── Кнопка отмена ─────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Отмена'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData? suffixIcon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
