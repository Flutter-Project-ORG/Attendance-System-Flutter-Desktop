import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../res/constants.dart';
import '../view_model/auth_view_model.dart';

class InviteButton extends StatelessWidget {
  final String? subId, subName;
  const InviteButton({this.subId, this.subName});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        style: ButtonStyle(
          foregroundColor: ButtonState.all<Color>(Colors.white),
        ),
        onPressed: () {
          Map<String, dynamic> data = {
            'subId': subId,
            'subName':subName,
            'insId': Provider.of<AuthViewModel>(context, listen: false)
                .user!
                .instructorId!,
          };

          final key = encrypt.Key.fromUtf8(Constants.encryptKey);
          final iv = encrypt.IV.fromLength(16);
          final encrypter = encrypt.Encrypter(encrypt.AES(key));
          final encrypted = encrypter.encrypt(jsonEncode(data), iv: iv);
          showDialog(
              context: context,
              builder: (ctx) {
                return ContentDialog(
                  title: Text(
                    'Invite students to $subName',
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      child: const Text(
                        'Cancel',
                      ),
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
    );
  }
}
