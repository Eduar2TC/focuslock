import 'package:flutter/material.dart';
import 'package:focuslock/shared/theme/app_theme.dart';

class AppEmptyState extends StatelessWidget {
  final String title;

  const AppEmptyState({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.apps, size: 64, color: AppTheme.textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
