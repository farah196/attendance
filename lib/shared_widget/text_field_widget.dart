import 'package:flutter/material.dart';

class SharedEditText extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final Icon icon;
  final double? fontSize;
  final bool? isObscureText;
  final Function? onChange;
  final Function? onSubmit;

  const SharedEditText({
    super.key,
    required this.textEditingController,
    required this.label,
    required this.icon,
    this.fontSize,
    this.isObscureText,
    this.onChange,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.only(left: 25, right: 20),
      child: TextField(
        controller: textEditingController,
        textAlign: TextAlign.right,
        cursorColor: theme.hintColor,
        obscureText: isObscureText ?? false,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          icon: icon,
          iconColor: theme.primaryColor,
          hintStyle: theme.textTheme.bodyMedium,
        ),
        onChanged: (value) {
          if (onChange != null) {
            onChange!(value);
          }
        },
        onSubmitted: (value) {
          if (onSubmit != null) {
            onSubmit!(value);
          }
        },
      ),
    );

    //   TextField(
    //   controller: textEditingController,
    //   obscureText: isObscureText ?? false,
    //   style: TextStyle(fontSize: fontSize ?? 16.0),
    //   decoration: InputDecoration(
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(50),
    //       borderSide: BorderSide(
    //         width: 0,
    //         style: BorderStyle.none,
    //       ),
    //     ),
    //     filled: true,
    //     fillColor: Colors.white10,
    //     labelText: label,
    //     focusedBorder: const OutlineInputBorder(
    //
    //       borderSide: BorderSide(color: MyColors.accentColor),
    //     ),
    //     enabledBorder: const OutlineInputBorder(
    //
    //       borderSide: BorderSide(color: Colors.grey),
    //     ),
    //   ),
    //   onChanged: (value) {
    //     if (onChange != null) {
    //       onChange!(value);
    //     }
    //   },
    //   onSubmitted: (value) {
    //     if (onSubmit != null) {
    //       onSubmit!(value);
    //     }
    //   },
    // );
  }
}
