import 'package:flutter/material.dart';

class DualActionButtons extends StatelessWidget {
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final String primaryLabel;
  final String secondaryLabel;
  final IconData primaryIcon;
  final IconData secondaryIcon;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isPrimaryElevated;
  final bool isSecondaryOutlined;
  final double verticalPadding;

  const DualActionButtons({
    super.key,
    required this.onPrimary,
    required this.onSecondary,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.primaryIcon,
    required this.secondaryIcon,
    this.primaryColor = Colors.white,
    this.secondaryColor = Colors.red,
    this.isPrimaryElevated = true,
    this.isSecondaryOutlined = true,
    this.verticalPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    final buttonPadding =
        EdgeInsets.symmetric(horizontal: 10, vertical: verticalPadding);

    return Row(
      children: [
        Expanded(
          child: isPrimaryElevated
              ? ElevatedButton(
                  onPressed: onPrimary,
                  style: ElevatedButton.styleFrom(padding: buttonPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(primaryIcon, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        primaryLabel,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : OutlinedButton(
                  onPressed: onPrimary,
                  style: OutlinedButton.styleFrom(padding: buttonPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(primaryIcon, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        primaryLabel,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: isSecondaryOutlined
              ? OutlinedButton(
                  onPressed: onSecondary,
                  style: OutlinedButton.styleFrom(padding: buttonPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(secondaryIcon, color: secondaryColor),
                      const SizedBox(width: 8),
                      Text(
                        secondaryLabel,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ElevatedButton(
                  onPressed: onSecondary,
                  style: ElevatedButton.styleFrom(padding: buttonPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(secondaryIcon, color: secondaryColor),
                      const SizedBox(width: 8),
                      Text(
                        secondaryLabel,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
