import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/note.dart';

enum NoteCategory { personal, work, idea, important, todo }

extension NoteCategoryExtension on NoteCategory {
  String get title {
    switch (this) {
      case NoteCategory.personal:
        return 'Personal';
      case NoteCategory.work:
        return 'Work';
      case NoteCategory.idea:
        return 'Idea';
      case NoteCategory.important:
        return 'Important';
      case NoteCategory.todo:
        return 'To-Do';
    }
  }

  Color get color {
    switch (this) {
      case NoteCategory.personal:
        return AppColors.notePersonal;
      case NoteCategory.work:
        return AppColors.noteWork;
      case NoteCategory.idea:
        return AppColors.noteIdea;
      case NoteCategory.important:
        return AppColors.noteImportant;
      case NoteCategory.todo:
        return AppColors.noteDefault;
    }
  }

  IconData get icon {
    switch (this) {
      case NoteCategory.personal:
        return Icons.person_outline;
      case NoteCategory.work:
        return Icons.work_outline;
      case NoteCategory.idea:
        return Icons.lightbulb_outline;
      case NoteCategory.important:
        return Icons.priority_high;
      case NoteCategory.todo:
        return Icons.check_circle_outline;
    }
  }
}

class EnhancedNoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final NoteCategory category;

  const EnhancedNoteCard({
    Key? key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.category = NoteCategory.personal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppElevation.md,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and actions row
                Row(
                  children: [
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category.icon,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            category.title,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          icon: Icons.edit_outlined,
                          onPressed: onEdit,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _buildActionButton(
                          icon: Icons.delete_outline,
                          onPressed: onDelete,
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Note content
                Text(
                  note.text,
                  style: AppTextStyles.noteTitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Date and time
                Text(
                  _formatDate(note.createdAt),
                  style: AppTextStyles.noteSubtitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE HH:mm').format(date);
    } else {
      return DateFormat('MMM d, HH:mm').format(date);
    }
  }
}
