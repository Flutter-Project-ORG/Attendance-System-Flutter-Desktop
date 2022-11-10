import 'package:attendance_system_flutter_desktop/res/custom_text_theme.dart';
import 'package:fluent_ui/fluent_ui.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' as material;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import '../models/instructor_model.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    InstructorModel? instructorModel = Provider.of<AuthViewModel>(context).user;
    return ScaffoldPage(
      content: Center(
        child: Container(
          width: 520.0,
          height: 320.0,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(4, 4),
                blurRadius: 15.0,
                spreadRadius: -1,
                inset: true,
              ),
              BoxShadow(
                color: Colors.black,
                offset: Offset(-4, -4),
                blurRadius: 15.0,
                spreadRadius: -1,
                inset: true,
              ),
            ],
          ),
          child: Row(
            children: [
              Badge(
                badgeColor: Colors.blue,
                elevation: 0,
                position: BadgePosition.bottomEnd(bottom: 4.0,end: 4.0),
                badgeContent: IconButton(
                  onPressed: () {
                    ProfileViewModel().changeProfileImage(context);
                  },
                  icon: const Icon(FluentIcons.edit),
                ),
                child: CircleAvatar(
                  backgroundImage: instructorModel!.imageUrl != null
                      ? NetworkImage(instructorModel.imageUrl!)
                      : const AssetImage('assets/images/profile.png')
                          as ImageProvider,
                  backgroundColor: Colors.white,
                  radius: 75.0,
                ),
              ),
              const material.VerticalDivider(
                color: Colors.white,
                width: 32.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${instructorModel.username}',style: CustomTextTheme.body1,),
                  const SizedBox(height: 16.0,),
                  Text('Email: ${instructorModel.email}',style: CustomTextTheme.body2,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
