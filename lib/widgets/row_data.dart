import 'package:attendance_system_flutter_desktop/res/custom_text_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';

class RowData extends StatelessWidget {
  const RowData(this._data, {super.key});
  final String _data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        _data,
        style: CustomTextTheme.body3,
      ),
    );
  }
}