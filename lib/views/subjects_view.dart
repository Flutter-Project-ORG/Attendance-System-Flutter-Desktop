import 'dart:convert';

import 'package:attendance_system_flutter_desktop/view_model/subjects_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SubjectsView extends StatefulWidget {
  const SubjectsView({Key? key}) : super(key: key);

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  final SubjectsViewModel _viewModel = SubjectsViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SubjectsViewModel>(context, listen: false).getSubjectsByInstructorId(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const Text(
        "Subjects",
      ),
      content: Consumer<SubjectsViewModel>(
        builder: (BuildContext context, SubjectsViewModel provider, _) {
          if (provider.isLoading) {
            return const Center(child: ProgressRing());
          }
          if (provider.subjects.isEmpty) {
            return const Center(
              child: Text('You don\'t have any subjects yet.'),
            );
          }
          List<String> keyList = provider.subjects.keys.toList();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: provider.subjects.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> singleSubject = provider.subjects[keyList[index]];
                return Card(child: Text(singleSubject['subjectName']));
              },
            ),
          );
        },
      ),
      bottomBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: material.FloatingActionButton.extended(
              onPressed: () async {
                await _viewModel.addSubject(context);
                // await Provider.of<SubjectsViewModel>(context,listen: false).getSubjectsByInstructorId(context);
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
