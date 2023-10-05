import 'package:flutter/material.dart';

import 'app_theme.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 5,
      width: isActive ? 19 : 5,
      decoration: BoxDecoration(
        color: isActive ?  Colors.white : AppTheme.hintColor,
        border: isActive ? null : Border.all(color:  AppTheme.primaryColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }}