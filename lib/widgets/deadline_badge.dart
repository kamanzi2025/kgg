import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DeadlineBadge extends StatelessWidget {
  final int daysLeft;

  const DeadlineBadge({super.key, required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    if (daysLeft < 0) return const SizedBox.shrink();

    Color bgColor;
    String label;

    if (daysLeft == 0) {
      bgColor = AppColors.errorRed;
      label = 'Closes Today';
    } else if (daysLeft <= 2) {
      bgColor = AppColors.warningOrange;
      label = '$daysLeft day${daysLeft == 1 ? '' : 's'} left';
    } else if (daysLeft <= 7) {
      bgColor = AppColors.accentGold;
      label = '$daysLeft days left';
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(26),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: bgColor.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 11, color: bgColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: bgColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
