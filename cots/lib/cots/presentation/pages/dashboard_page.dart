import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/app_spacing.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';
import 'task_list_page.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TaskController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tugas Besar'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TaskListPage(),
                ),
              );
            },
            child: Text(
              'Daftar Tugas',
              style: AppTextStyle.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      body: FutureBuilder<List<Task>>(
        future: controller.fetchAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!;
          final selesai =
              tasks.where((e) => e.status == 'SELESAI').length;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// SUMMARY
                Row(
                  children: [
                    _summaryCard('Total Tugas', tasks.length.toString()),
                    const SizedBox(width: AppSpacing.md),
                    _summaryCard('Selesai', selesai.toString()),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                Text('Tugas Terdekat', style: AppTextStyle.subtitle),
                const SizedBox(height: AppSpacing.md),

                /// LIST TERDEKAT
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, i) {
                      final task = tasks[i];
                      return _taskCard(context, task);
                    },
                  ),
                ),

                /// BUTTON TAMBAH
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddTaskPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Tambah Tugas',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            Text(title, style: AppTextStyle.caption),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyle.title),
          ],
        ),
      ),
    );
  }

  Widget _taskCard(BuildContext context, Task task) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailPage(task: task),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: AppTextStyle.subtitle),
                  const SizedBox(height: 4),
                  Text(task.course, style: AppTextStyle.caption),
                ],
              ),
            ),
            _statusBadge(task.status),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isDone = status == 'SELESAI';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.success.withOpacity(0.15)
            : AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyle.caption.copyWith(
          color: isDone ? AppColors.success : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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
