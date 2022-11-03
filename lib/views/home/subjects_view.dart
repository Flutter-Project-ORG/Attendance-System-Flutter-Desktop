import 'dart:convert';

import 'package:attendance_system_flutter_desktop/view_model/subjects_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubjectsView extends StatelessWidget {
   SubjectsView({Key? key}) : super(key: key);

  final SubjectsViewModel _viewModel = SubjectsViewModel();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const Text(
        "Subjects",
      ),
      content: FutureBuilder<http.Response>(
        future: _viewModel.getSubjectsByInstructorId(context),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: ProgressRing());
          }
          if(snapshot.hasData){
            final jsonData = jsonDecode(snapshot.data!.body) as Map<String, dynamic>;
            print(jsonData);
            return Container();
          }
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
