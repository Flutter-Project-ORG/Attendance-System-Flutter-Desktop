import 'dart:convert';
import 'package:attendance_system_flutter_desktop/widgets/invite_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../view_model/auth_view_model.dart';
import '../view_model/subjects_view_model.dart';
import '../res/constants.dart';
import '../widgets/subject_days.dart';
import 'lectures_view.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
        builder: (BuildContext context, SubjectsViewModel subjectProvider, _) {
          if (subjectProvider.isLoading) {
            return const Center(child: ProgressRing());
          }
          if (subjectProvider.subjects.isEmpty) {
            return const Center(
              child: Text('You don\'t have any subjects yet.'),
            );
          }
          List<String> keyList = subjectProvider.subjects.keys.toList();
          return AnimationLimiter(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: subjectProvider.subjects.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemBuilder: (ctx, index) {
                Map<String, dynamic> singleSubject =
                    subjectProvider.subjects[keyList[index]];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: (index / subjectProvider.subjects.length).floor(),
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LecturesView.routeName,
                              arguments: {
                                "subName": singleSubject['subjectName'],
                                "subId": keyList[index],
                              });
                        },
                        child: Card(
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            singleSubject['subjectName'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.grey,
                                            ),
                                            child: Text(
                                              "Ends in : ${singleSubject['endDate'].toString().substring(0, 10)}",
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                          style: const TextStyle(
                                            fontSize: 10,
                                            //color: Colors.grey.withOpacity(0.5),
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
                                            style: const TextStyle(
                                              fontSize: 10,
                                              // color:
                                              //     Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        InviteButton(
                                          subId: keyList[index],
                                          subName: singleSubject['subjectName'],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: FilledButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  ButtonState.all<Color>(
                                                      Colors.black),
                                              foregroundColor:
                                                  ButtonState.all<Color>(
                                                      Colors.white),
                                            ),
                                            onPressed: () async {
                                              await subjectProvider
                                                  .printSubjectAttendance(
                                                      context,
                                                      keyList[index],
                                                      singleSubject);
                                            },
                                            child: const Text('Print'),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await subjectProvider.changeSubjectName(
                                              context,
                                              keyList[index],
                                              singleSubject['subjectName'],
                                            );
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.penToSquare,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await subjectProvider.deleteSubject(
                                                context,
                                                keyList[index],
                                                singleSubject['subjectName'],);
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.trash,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
