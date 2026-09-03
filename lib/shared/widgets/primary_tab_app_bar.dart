import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PrimaryTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryTabAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      centerTitle: false,
      titleSpacing: 22,
      actions: actions,
      title: SizedBox(
        height: 48,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}
