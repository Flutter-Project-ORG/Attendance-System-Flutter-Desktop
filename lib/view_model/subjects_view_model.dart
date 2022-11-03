import 'package:attendance_system_flutter_desktop/models/subject_model.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SubjectsViewModel{



  Future<void> addSubject(BuildContext context)async{
    // await SubjectModel().addSubject(subjectName, instructorId);

    showDialog(context: context, builder: (context){
      return ContentDialog(
        title: const Text('Add New Subject'),
      );
    },);

  }


}