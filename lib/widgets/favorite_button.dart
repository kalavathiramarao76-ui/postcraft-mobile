import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:postcraft_ai/models/post_model.dart';
import 'package:postcraft_ai/services/favorites_service.dart';

class FavoriteButton extends StatefulWidget {
  final PostModel post;
  final double size;

  const FavoriteButton({
    super.key,
    required this.post,
    this.size = 20,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesService>(
      builder: (context, favService, _) {
        final isFav = favService.isFavorite(widget.post.id);
        return ScaleTransition(
          scale: _scaleAnimation,
          child: IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.redAccent : null,
              size: widget.size,
            ),
            onPressed: () {
              _controller.forward(from: 0);
              favService.toggleFavorite(widget.post);
            },
            visualDensity: VisualDensity.compact,
          ),
        );
      },
    );
  }
}
