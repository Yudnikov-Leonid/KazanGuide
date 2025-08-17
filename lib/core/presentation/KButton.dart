import 'package:flutter/material.dart';

import 'package:kazan_guide/core/presentation/colors.dart';

class KButton extends TextButton {
  KButton({required super.onPressed, required super.child, super.key})
    : super(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: Colors.white,
        ),
      );
}
