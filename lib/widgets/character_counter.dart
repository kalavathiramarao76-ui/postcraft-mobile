import 'package:flutter/material.dart';
import 'package:postcraft_ai/theme/app_theme.dart';

class CharacterCounter extends StatelessWidget {
  final int count;
  final int maxChars;

  const CharacterCounter({
    super.key,
    required this.count,
    this.maxChars = 3000,
  });

  Color _getColor() {
    final ratio = count / maxChars;
    if (ratio < 0.5) return Colors.green;
    if (ratio < 0.75) return Colors.orange;
    if (ratio < 0.9) return Colors.deepOrange;
    return Colors.red;
  }

  String _getLabel() {
    if (count < 200) return 'Short post';
    if (count < 800) return 'Good length';
    if (count <= 1500) return 'Optimal for engagement';
    if (count <= 3000) return 'Long post';
    return 'Over limit';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getColor().withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            count <= maxChars ? Icons.check_circle : Icons.warning,
            size: 16,
            color: _getColor(),
          ),
          const SizedBox(width: 6),
          Text(
            '$count / $maxChars',
            style: TextStyle(
              color: _getColor(),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _getLabel(),
            style: TextStyle(
              color: _getColor().withOpacity(0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
