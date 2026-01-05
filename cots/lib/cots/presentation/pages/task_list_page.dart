import 'package:flutter/material.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/app_spacing.dart';
import 'task_detail_page.dart';
import 'add_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TaskController controller = TaskController();

  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'Semua';
  String searchQuery = '';

  final List<String> filters = [
    'Semua',
    'Berjalan',
    'Selesai',
    'Terlambat'
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskPage()),
              );
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah'),
          )
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: controller.fetchAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Task> tasks = snapshot.data!;

          /// FILTER STATUS
          if (selectedFilter != 'Semua') {
            tasks = tasks.where((t) =>
              t.status.toUpperCase() ==
              selectedFilter.toUpperCase()
            ).toList();
          }

          /// FILTER SEARCH
          if (searchQuery.isNotEmpty) {
            final query = searchQuery.toLowerCase();
            tasks = tasks.where((t) =>
              t.title.toLowerCase().contains(query) ||
              t.course.toLowerCase().contains(query)
            ).toList();
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                /// SEARCH BAR
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari tugas atau mata kuliah...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                /// FILTER CHIP
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final filter = filters[i];
                      final isActive = selectedFilter == filter;

                      return ChoiceChip(
                        label: Text(filter),
                        selected: isActive,
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        selectedColor:
                            AppColors.primary.withOpacity(0.2),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                /// LIST TUGAS
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: Text(
                            'Tugas tidak ditemukan',
                            style: AppTextStyle.caption,
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, i) {
                            final task = tasks[i];

                            return Container(
                              margin: const EdgeInsets.only(
                                  bottom: AppSpacing.sm),
                              padding:
                                  const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: task.status == 'SELESAI'
                                      ? AppColors.success
                                      : AppColors.primary,
                                ),
                                title: Text(
                                  task.title,
                                  style: AppTextStyle.subtitle,
                                ),
                                subtitle: Text(
                                  task.course,
                                  style: AppTextStyle.caption,
                                ),
                                trailing: Text(
                                  task.deadline,
                                  style: AppTextStyle.caption,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TaskDetailPage(task: task),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
