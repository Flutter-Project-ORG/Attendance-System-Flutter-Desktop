import 'package:attendance_system_flutter_desktop/view_model/subjects_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

class SubjectsView extends StatelessWidget {
   SubjectsView({Key? key}) : super(key: key);

  final SubjectsViewModel _viewModel = SubjectsViewModel();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const Text(
        "Subjects",
      ),
      content: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container();
        },
      ),
      bottomBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                _viewModel.addSubject(context);
              },
              icon: const Icon(FluentIcons.add),
              label: const Text('Add Subject'),
            ),
          ),
        ],
      ),
    );
  }
}
