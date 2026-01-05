import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/app_spacing.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TaskController _controller = TaskController();
  late TextEditingController _noteController;
  late bool _isDone;
  late String _status;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.task.note);
    _isDone = widget.task.isDone;
    _status = widget.task.status;
  }

  Future<void> _saveNote() async {
    await _controller.updateTask(widget.task.id, {
      'note': _noteController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan disimpan')),
    );
  }

  Future<void> _toggleDone(bool value) async {
    setState(() {
      _isDone = value;
      _status = value ? 'SELESAI' : 'BERJALAN';
    });

    await _controller.updateTask(widget.task.id, {
      'is_done': _isDone,
      'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            /// CARD DETAIL TUGAS
            _buildDetailCard(),

            const SizedBox(height: AppSpacing.lg),

            /// PENYELESAIAN
            _buildCompletionCard(),

            const SizedBox(height: AppSpacing.lg),

            /// CATATAN
            _buildNoteCard(),

            const SizedBox(height: AppSpacing.lg),

            /// BUTTON SIMPAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= CARD DETAIL =================
  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Judul Tugas', style: AppTextStyle.caption),
          const SizedBox(height: 4),
          Text(widget.task.title, style: AppTextStyle.subtitle),

          const SizedBox(height: AppSpacing.md),

          Text('Mata Kuliah', style: AppTextStyle.caption),
          const SizedBox(height: 4),
          Text(widget.task.course, style: AppTextStyle.body),

          const SizedBox(height: AppSpacing.md),

          Text('Deadline', style: AppTextStyle.caption),
          const SizedBox(height: 4),
          Text(widget.task.deadline, style: AppTextStyle.body),

          const SizedBox(height: AppSpacing.md),

          Text('Status', style: AppTextStyle.caption),
          const SizedBox(height: 6),

          _buildStatusBadge(),
        ],
      ),
    );
  }

  /// ================= STATUS BADGE =================
  Widget _buildStatusBadge() {
    final isDone = _status == 'SELESAI';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.success.withOpacity(0.15)
            : AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _status,
        style: AppTextStyle.caption.copyWith(
          color: isDone ? AppColors.success : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ================= PENYELESAIAN =================
  Widget _buildCompletionCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(),
      child: CheckboxListTile(
        value: _isDone,
        onChanged: (value) {
          if (value != null) _toggleDone(value);
        },
        title: const Text(
          'Tugas sudah selesai',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: const Text(
          'Centang jika tugas sudah final.',
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  /// ================= CATATAN =================
  Widget _buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Catatan', style: AppTextStyle.subtitle),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Catatan tambahan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CARD DECORATION =================
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
