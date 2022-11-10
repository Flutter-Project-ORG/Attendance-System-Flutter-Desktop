import 'package:fluent_ui/fluent_ui.dart';

class Components {
  static void showErrorSnackBar(BuildContext context, {required String text}) {
    showSnackbar(
      context,
      Snackbar(content: Text(text)),
    );
  }
}
