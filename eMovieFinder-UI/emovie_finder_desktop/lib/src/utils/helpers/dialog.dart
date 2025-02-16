import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:emovie_finder_desktop/src/utils/helpers/theme.dart';

class MyDialogUtils {
  static Future<void> showLoadingDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyTheme.blackOne,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: MyTheme.gold,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: false,
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showCustomDialog({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color iconColor,
    String? posActionTitle,
    VoidCallback? posAction,
    String? negActionTitle,
    VoidCallback? negAction,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyTheme.blackOne,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (negActionTitle != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.blackOne,
                      side: const BorderSide(color: MyTheme.gold, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (negAction != null) negAction();
                    },
                    child: Text(
                      negActionTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: MyTheme.gold),
                    ),
                  ),
                if (posActionTitle != null)
                  const SizedBox(width: 12),
                if (posActionTitle != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (posAction != null) posAction();
                    },
                    child: Text(
                      posActionTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: false,
    );
  }

  static void showSuccessDialog({
    required BuildContext context,
    required String message,
    String? posActionTitle = "OK",
    VoidCallback? posAction,
  }) {
    showCustomDialog(
      context: context,
      message: message,
      icon: EvaIcons.checkmarkCircle,
      iconColor: Colors.green,
      posActionTitle: posActionTitle,
      posAction: posAction,
    );
  }

  static void showErrorDialog({
    required BuildContext context,
    required String message,
    String? posActionTitle,
    VoidCallback? posAction,
  }) {
    showCustomDialog(
      context: context,
      message: message,
      icon: Icons.error_outline,
      iconColor: Colors.red,
      posActionTitle: posActionTitle,
      posAction: posAction,
    );
  }

  static void showQuestionDialog({
    required BuildContext context,
    required String message,
    String? posActionTitle = "Yes",
    VoidCallback? posAction,
    String? negActionTitle = "No",
    VoidCallback? negAction,
  }) {
    showCustomDialog(
      context: context,
      message: message,
      icon: EvaIcons.questionMark,
      iconColor: MyTheme.gold,
      posActionTitle: posActionTitle,
      posAction: posAction,
      negActionTitle: negActionTitle,
      negAction: negAction,
    );
  }
}
