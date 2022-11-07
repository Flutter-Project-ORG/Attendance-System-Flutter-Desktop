import 'package:attendance_system_flutter_desktop/view_model/auth_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../view_model/lecture_attendance_view_model.dart';

class IsAttendDrop extends StatefulWidget {
  bool _isAttend;
  final Map<String,dynamic> _data;
  IsAttendDrop(this._isAttend,this._data);

  @override
  State<IsAttendDrop> createState() => _IsAttendDropState();
}

class _IsAttendDropState extends State<IsAttendDrop> {
  Future _changeState(bool value) async {
    setState(() {
      widget._isAttend = value;
    });
    await Provider.of<LecturesAttendanceViewModel>(context, listen: false)
        .changeStudentAttendanceState(
      widget._isAttend,
      widget._data,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropDownButton(
        title: Text(widget._isAttend ? "Attend" : "Absent"),
        items: [
          MenuFlyoutItem(
            text: const Text('Attend'),
            onPressed: () => _changeState(true),
          ),
          MenuFlyoutItem(
            text: const Text('Absent'),
            onPressed: () => _changeState(false),
          ),
        ],
      ),
    );
  }
}
