import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

class ActionsButtons extends StatefulWidget {
  final bool isFavorited;
  final bool isCommented;
  final bool isShared;
  final bool isLiked;

  final VoidCallback? onCommentPressed;
  final VoidCallback? isFavoritedPressed;
  final VoidCallback? isCommentedPressed;
  final VoidCallback? isSharedPressed;
  final VoidCallback? isLikedPressed;

  const ActionsButtons({
    super.key,
    required this.isFavorited,
    required this.isShared,
    required this.isLiked,
    required this.isCommented,
    this.onCommentPressed,
    this.isFavoritedPressed,
    this.isCommentedPressed,
    this.isSharedPressed,
    this.isLikedPressed,
  });

  @override
  _ActionsButtonsState createState() => _ActionsButtonsState();
}

class _ActionsButtonsState extends State<ActionsButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: widget.isLikedPressed,
            child: Icon(
              widget.isLiked ? Icons.favorite : Icons.favorite_border_outlined,
              size: AppIconSizes.DefaultIconSize + 5,
              color: widget.isLiked ? AppColors.orangeDefault : Colors.black,
            ),
          ),
          InkWell(
            onTap: widget.onCommentPressed,
            child: Icon(
              widget.isCommented ? Icons.comment : Icons.comment_outlined,
              size: AppIconSizes.DefaultIconSize + 5,
              color: widget.isCommented
                  ? AppColors.orangeDefault
                  : Colors.black,
            ),
          ),
          InkWell(
            onTap: widget.isSharedPressed,
            child: Icon(
              widget.isShared ? Icons.share : Icons.share_outlined,
              size: AppIconSizes.DefaultIconSize + 5,
              color: widget.isShared ? AppColors.orangeDefault : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
