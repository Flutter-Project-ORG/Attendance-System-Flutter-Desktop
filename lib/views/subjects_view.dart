import 'dart:convert';
import 'package:attendance_system_flutter_desktop/res/contants.dart';
import 'package:flutter/material.dart' as material;

import 'package:attendance_system_flutter_desktop/view_model/subjects_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'lectures_view.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LecturesView.routeName, arguments: {
                      "subName" : singleSubject['subjectName'],
                      "subId" : keyList[index],
                    });
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(singleSubject['subjectName']),
                        const Spacer(),
                        Row(
                          children: [
                            FilledButton(
                              style: ButtonStyle(
                                backgroundColor: ButtonState.all<Color>(Colors.red),
                                foregroundColor: ButtonState.all<Color>(Colors.white),
                              ),
                              onPressed: () {
                                provider.deleteSubject(context, keyList[index], singleSubject['subjectName']);
                              },
                              child:const Text('Delete'),
                            ),
                            const SizedBox(width: 32.0,),
                            FilledButton(
                              style: ButtonStyle(
                                foregroundColor: ButtonState.all<Color>(Colors.white),
                              ),
                              onPressed: () {
                                final subId = keyList[index];
                                final key = encrypt.Key.fromUtf8(Constants.encryptKey);
                                final iv = encrypt.IV.fromLength(16);
                                final encrypter = encrypt.Encrypter(encrypt.AES(key));
                                final encrypted = encrypter.encrypt(subId, iv: iv);
                                showDialog(context: context, builder: (ctx){
                                  return ContentDialog(
                                    title:  Text('Invite students to ${singleSubject['subjectName']}'),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        QrImage(
                                          data: encrypted.base64,
                                          version: QrVersions.auto,
                                          size: 200.0,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(child: const Text('Cancel'), onPressed: (){
                                        Navigator.pop(context);
                                      },),
                                    ],
                                  );
                                });

                              },
                              child:const Text('Invite'),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
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
