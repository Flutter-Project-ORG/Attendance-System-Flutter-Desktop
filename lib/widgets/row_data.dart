import 'package:fluent_ui/fluent_ui.dart';

class RowData extends StatelessWidget {
  String _data;
  RowData(this._data);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          _data,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}