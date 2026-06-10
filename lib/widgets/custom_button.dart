import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;
  final Color? color;
  final double? width;

  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isOutlined = false,
    this.isLoading = false,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? AppColors.accentGold;
    return SizedBox(
      width: width,
      height: 48,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onTap,
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : (icon != null ? Icon(icon, size: 18) : const SizedBox.shrink()),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: bgColor,
                side: BorderSide(color: bgColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: isLoading ? null : onTap,
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : (icon != null ? Icon(icon, size: 18, color: Colors.black) : const SizedBox.shrink()),
              label: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
    );
  }
}
