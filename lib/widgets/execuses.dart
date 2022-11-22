import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../view_model/dashboard_view_model.dart';

class Excuses extends StatelessWidget {
  final Map<String, dynamic>? subject;
  final String? subId;
  const Excuses({super.key, this.subject, this.subId});

  @override
  Widget build(BuildContext context) {
    final dashProvider =
        Provider.of<DashboardViewModel>(context, listen: false);
    return ContentDialog(
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      title: Text(
        '${subject!['subjectName']} Excuses',
      ),
      content: SizedBox(
        height: 300,
        child: FutureBuilder(
            future: dashProvider.getExcuses(context, subId!),
            builder: (context, snapshotE) {
              if (snapshotE.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: ProgressRing(),
                );
              }
              if (snapshotE.data!.isEmpty) {
                return const Center(
                  child: Text("There's no excuses"),
                );
              }
              final keys = snapshotE.data!.keys.toList();
              return ListView.separated(
                itemBuilder: (context, index) {
                  Map<String, dynamic> singleExcuse =
                      snapshotE.data![keys[index]];
                  return Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(singleExcuse['image']),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(singleExcuse['studentName']),
                        ],
                      ),
                      // ListTile(
                      // leading: CircleAvatar(
                      //   backgroundImage: NetworkImage(singleExecuse['image']),
                      // ),
                      // title: Text(singleExecuse['studentName']),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: singleExcuse.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemBuilder: (context, i) {
                          String id = singleExcuse.keys.toList()[i];
                          if (id != "image" && id != "studentName") {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 40,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    singleExcuse[id]['excuseText'],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  if (singleExcuse[id]['imageUrl'] != null)
                                    SizedBox(
                                      width: double.infinity,
                                      height: 100,
                                      child: Image.network(
                                        singleExcuse[id]['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Button(
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onPressed: () {
                                          dashProvider.deleteExcuse(context, subId!,keys[index],id);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      const SizedBox(width: 10,),
                                      Button(
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        onPressed: () {
                                          dashProvider.deleteExcuse(context, subId!,keys[index],id);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: keys.length,
              );
            }),
      ),
    );
  }
}
