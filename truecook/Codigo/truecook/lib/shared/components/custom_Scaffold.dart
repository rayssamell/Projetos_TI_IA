import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:truecook/shared/utils/constants.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final int? selectedIndex;
  final Function(int)? onTap;
  final Widget? floatingActionButton;

  const CustomScaffold({
    super.key,
    required this.body,
    this.selectedIndex,
    this.onTap,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: appBar,
      extendBody: true,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: selectedIndex != null ? CircleNavBar(
        activeIcons: const [
          Icon(Icons.home, color: AppColors.allWhite),
          Icon(Icons.receipt, color: AppColors.allWhite),
          Icon(Icons.store, color: AppColors.allWhite),
          Icon(Icons.person, color: AppColors.allWhite),
        ],
        inactiveIcons: const [
          Column(
            children: [
              Icon(Icons.home, color: AppColors.allWhite),
              Text(
                "Home",
                style: TextStyle(
                  color: AppColors.allWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.receipt, color: AppColors.allWhite),
              Text("Receitas", style: TextStyle(color: AppColors.allWhite,
                fontWeight: FontWeight.bold,
              )),
            ]
          ),
          Column(
            children: [
              Icon(Icons.store, color: AppColors.allWhite),
              Text("Comercios", style: TextStyle(color: AppColors.allWhite,
                  fontWeight: FontWeight.bold,
                )),
            ],
          ),
          Column(
            children: [
              Icon(Icons.person, color: AppColors.allWhite),
              Text("Perfil", style: TextStyle(color: AppColors.allWhite,
                  fontWeight: FontWeight.bold,
                )),
            ],
          ),
        ],
        color: AppColors.orangeDefault,
        height: 60,
        circleWidth: 60,
        activeIndex: selectedIndex?? 0,
        onTap: onTap,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: AppColors.orangeQuest,
        elevation: 10,
      ) : null
    );
  }
}
