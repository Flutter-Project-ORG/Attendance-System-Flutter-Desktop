import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../view_model/lecture_attendance_view_model.dart';
import '../widgets/row_data.dart';
import '../widgets/is_attend_drop.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart' as path_provider;

class LectureAttendanceView extends StatelessWidget {
  const LectureAttendanceView({super.key});

  static const String routeName = '/lecture_attendance';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> lectureData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final attendanceProvider = Provider.of<LecturesAttendanceViewModel>(context, listen: false);
    return NavigationView(
      appBar: NavigationAppBar(
        title: Text(lectureData['lecId']!),
        actions: FilledButton(
          child: const Text('Print attendance'),
          onPressed: () async {
            final pdf = pw.Document();

            final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
            final ttf = pw.Font.ttf(font);

            pdf.addPage(pw.Page(
                pageFormat: PdfPageFormat.a4,
                build: (pw.Context context) {
                  return pw.Center(
                    child: pw.Text("Hello World", style: pw.TextStyle(font: ttf)),
                  ); // Center
                }));
            Directory? output = await path_provider.getDownloadsDirectory();
            output ??= await path_provider.getTemporaryDirectory();
            final file = File("${output.path}/${lectureData['lecId']}.pdf");
            await file.writeAsBytes(await pdf.save()).then((value) {
              showSnackbar(
                context,
                Snackbar(
                  content: Text('File download to ${value.path}'),
                  extended: true,
                ),
              );
            });
          },
        ),
      ),
      content: FutureBuilder(
        future: attendanceProvider.getAttendanceByLectureIdAndSubjectId(
          lectureData['subId']!,
          lectureData['lecId']!,
          context,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ProgressRing());
          }
          if (attendanceProvider.attendance.isEmpty) {
            return Center(
              child: Text(
                "There's no attendance for ${lectureData['lecId']!} lecture.",
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBox(
                header: 'Search for a student:',
                placeholder: 'Name or Student id',
                expands: false,
                onChanged: (value) {
                  attendanceProvider.filterBySearch(value);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Student Name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Attend",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Consumer<LecturesAttendanceViewModel>(
                builder: (context, att, _) {
                  List<String> keyList = att.filterSearch.keys.toList();
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        Map<String, dynamic> singleAtt = att.filterSearch[keyList[index]];
                        return Row(
                          children: [
                            //RowData(keyList[index]),
                            RowData(singleAtt['studentName']),
                            IsAttendDrop(
                              singleAtt['isAttend'],
                              {
                                "studentId": keyList[index],
                                "subId": lectureData['subId']!,
                                "lecId": lectureData['lecId']!,
                              },
                            ),
                            //RowData(singleAtt['isAttend'].toString()),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: att.filterSearch.length,
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
