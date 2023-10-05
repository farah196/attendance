
import 'package:attendance/shared_widget/snackbar.dart';
import 'package:flutter/material.dart';

class SharedButton extends StatelessWidget {
  final String buttonLabel;
  final Function onClick;
  final Color color;
  final bool canClick;
  final String msgCantClick;

  const SharedButton({
    super.key,
    required this.buttonLabel,
    required this.onClick,
    required this.color,
    required this.canClick,
    required this.msgCantClick,
  });

  @override
  Widget build(BuildContext context) {
    SnackbarShare.init(context);
    final ThemeData theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        if (canClick) {
          onClick();
        } else {
          SnackbarShare.showMessage(msgCantClick);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Adjust the value as needed
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
        elevation: 3,
        primary: color, // Background color of the button
      ),
      child: Text(
        buttonLabel,
        style: const TextStyle(
          fontSize: 15.0,
          fontFamily: "Tajawal",
          color: Colors.white,
        ),
      ),
    );
  }
}
