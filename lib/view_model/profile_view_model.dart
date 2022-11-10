import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ProfileViewModel with ChangeNotifier {
  Future<void> changeProfileImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'webp'],
      dialogTitle: 'Please select an image:',
    );
    if (result == null) return;
    File file = File(result.files.single.path!);
    print(file);
  }
}
