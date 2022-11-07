import 'package:fluent_ui/fluent_ui.dart';

class SubjectDays extends StatelessWidget {
  final List<dynamic> _days;
  SubjectDays(this._days);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        _days.length,
        (index) => Padding(
          padding: const EdgeInsets.only(
            right: 5,
            bottom: 2,
            //top: 5,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Chip(
              text: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  _days[index].toString().substring(0,2).toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
