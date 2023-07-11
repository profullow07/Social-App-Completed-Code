import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isLiked;
  const LikeButton({
    super.key,
    required this.onPressed,
    required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
  
      ),
    );
  }
}
