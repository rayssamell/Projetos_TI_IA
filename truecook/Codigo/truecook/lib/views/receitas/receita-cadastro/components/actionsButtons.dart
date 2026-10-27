import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

class ActionsButtons extends StatefulWidget {
  const ActionsButtons({super.key});

  @override
  _ActionsButtonsState createState() => _ActionsButtonsState();
}

class _ActionsButtonsState extends State<ActionsButtons> {
  final bool _isFavorited = false;
  bool _isCommented = false;
  bool _isShared = false;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            child: Icon(
              _isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
              size: AppIconSizes.DefaultIconSize + 5,
              color: _isLiked ? AppColors.orangeDefault : Colors.black,
            ),
            onTap: () => {
              setState(() {
                _isLiked = !_isLiked;
              }),
            },
          ),
          InkWell(
            child: Icon(
              _isCommented ? Icons.comment : Icons.comment_outlined,
              size: AppIconSizes.DefaultIconSize + 5,
              color: _isCommented ? AppColors.orangeDefault : Colors.black,
            ),
            onTap: () => {
              setState(() {
                _isCommented = !_isCommented;
              }),
            },
          ),
          InkWell(
            child: Icon(
              _isShared ? Icons.share : Icons.share_outlined,
              size: AppIconSizes.DefaultIconSize + 5,
              color: _isShared ? AppColors.orangeDefault : Colors.black,
            ),
            onTap: () => {
              setState(() {
                _isShared = !_isShared;
              }),
            },
          ),
        ],
      ),
    );
  }
}
