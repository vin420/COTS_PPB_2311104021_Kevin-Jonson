import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/app_spacing.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final controller = TaskController();

  final titleCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  String? selectedCourse;
  DateTime? selectedDate;
  bool isDone = false;

  final courses = [
    'PPB',
    'PPW',
    'Manpro',
    'UX',
    'SQA',
    'DesThink',
    'KWU',
    'WGTIK',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tambah Tugas'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            /// FORM CARD
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Judul Tugas', style: AppTextStyle.caption),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan judul tugas',
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text('Mata Kuliah', style: AppTextStyle.caption),
                  DropdownButtonFormField<String>(
                    value: selectedCourse,
                    hint: const Text('Pilih mata kuliah'),
                    items: courses
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCourse = value;
                      });
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text('Deadline', style: AppTextStyle.caption),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: selectedDate == null
                          ? 'Pilih tanggal'
                          : selectedDate!
                              .toIso8601String()
                              .substring(0, 10),
                      suffixIcon:
                          const Icon(Icons.calendar_today),
                    ),
                    onTap: _pickDate,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  CheckboxListTile(
                    value: isDone,
                    onChanged: (v) {
                      setState(() {
                        isDone = v ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tugas sudah selesai'),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text('Catatan', style: AppTextStyle.caption),
                  TextField(
                    controller: noteCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Catatan tambahan (opsional)',
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// BUTTON
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _submit() async {
    await controller.add({
      'title': titleCtrl.text,
      'course': selectedCourse ?? '',
      'deadline': selectedDate
          ?.toIso8601String()
          .substring(0, 10),
      'status': isDone ? 'SELESAI' : 'BERJALAN',
      'note': noteCtrl.text,
      'is_done': isDone,
    });

    Navigator.pop(context);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
