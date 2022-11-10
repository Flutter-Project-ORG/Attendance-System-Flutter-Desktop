import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../view_model/auth_view_model.dart';
import '../view_model/subjects_view_model.dart';
import '../res/constants.dart';
import '../widgets/subject_days.dart';
import 'lectures_view.dart';

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
      await Provider.of<SubjectsViewModel>(context, listen: false)
          .getSubjectsByInstructorId(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
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
                maxCrossAxisExtent: 300.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> singleSubject =
                    provider.subjects[keyList[index]];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LecturesView.routeName,
                        arguments: {
                          "subName": singleSubject['subjectName'],
                          "subId": keyList[index],
                        });
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(singleSubject['subjectName']),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey,
                                    ),
                                    child: Text(
                                      "Ends in : ${singleSubject['endDate'].toString().substring(0, 10)}",
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SubjectDays(
                                singleSubject['times']['time1']['days'],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Time"),
                                  Text(
                                    "${singleSubject['times']['time1']['start'].toString().substring(11, 16)} - ${singleSubject['times']['time1']['end'].toString().substring(11, 16)}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                              if (singleSubject['times']['time2'] != null)
                                const SizedBox(
                                  height: 15,
                                  child: Center(
                                    child: Divider(),
                                  ),
                                ),
                              if (singleSubject['times']['time2'] != null)
                                SubjectDays(
                                  singleSubject['times']['time2']['days'],
                                ),
                              if (singleSubject['times']['time2'] != null)
                                const SizedBox(
                                  height: 5,
                                ),
                              if (singleSubject['times']['time2'] != null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Time"),
                                    Text(
                                      "${singleSubject['times']['time2']['start'].toString().substring(11, 16)} - ${singleSubject['times']['time1']['end'].toString().substring(11, 16)}",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        //const Spacer(),
                        Wrap(
                          children: [
                            FilledButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    ButtonState.all<Color>(Colors.red),
                                foregroundColor:
                                    ButtonState.all<Color>(Colors.white),
                              ),
                              onPressed: () {
                                provider.deleteSubject(context, keyList[index],
                                    singleSubject['subjectName']);
                              },
                              child: const Text('Delete'),
                            ),
                            FilledButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    ButtonState.all<Color>(Colors.white),
                              ),
                              onPressed: () {
                                Map<String, dynamic> data = {
                                  'subId': keyList[index],
                                  'insId': Provider.of<AuthViewModel>(context,
                                          listen: false)
                                      .user!
                                      .instructorId!,
                                };

                                final key =
                                    encrypt.Key.fromUtf8(Constants.encryptKey);
                                final iv = encrypt.IV.fromLength(16);
                                final encrypter =
                                    encrypt.Encrypter(encrypt.AES(key));
                                final encrypted =
                                    encrypter.encrypt(jsonEncode(data), iv: iv);
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ContentDialog(
                                        title: Text(
                                            'Invite students to ${singleSubject['subjectName']}'),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            QrImage(
                                              backgroundColor: Colors.white,
                                              data: encrypted.base64,
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text('Invite'),
                            ),
                            FilledButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    ButtonState.all<Color>(Colors.black),
                                foregroundColor:
                                    ButtonState.all<Color>(Colors.white),
                              ),
                              onPressed: () async {
                                await provider.printSubjectAttendance(
                                    context, keyList[index], singleSubject);
                              },
                              child: const Text('Print'),
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
