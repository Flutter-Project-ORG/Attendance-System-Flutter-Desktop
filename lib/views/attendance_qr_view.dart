import 'dart:async';
import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../res/contants.dart';
import '../view_model/attendance_qr_view_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class AttendanceQrView extends StatefulWidget {
  const AttendanceQrView({Key? key, required this.path, required this.lecId, required this.ctx}) : super(key: key);

  final String path;
  final String lecId;
  final BuildContext ctx;

  @override
  State<AttendanceQrView> createState() => _AttendanceQrViewState();
}

class _AttendanceQrViewState extends State<AttendanceQrView> {
  late encrypt.Encrypter encrypter;
  late encrypt.IV iv;
  late Timer timer ;
  @override
  void initState() {
    final key = encrypt.Key.fromUtf8(Constants.encryptKey);
    iv = encrypt.IV.fromLength(16);
    encrypter = encrypt.Encrypter(encrypt.AES(key));
    WidgetsBinding.instance.addPostFrameCallback((_) async{

      await Provider.of<AttendanceQrViewModel>(widget.ctx, listen: false).changeRandomNum(widget.lecId);
      timer = Timer.periodic(
        const Duration(seconds: 10),
            (_) async {
          await Provider.of<AttendanceQrViewModel>(widget.ctx, listen: false).changeRandomNum(widget.lecId);
        },
      );
      await windowManager.setMinimumSize(const Size(400, 400));
      await windowManager.setPosition(const Offset(0, 0));
      await windowManager.setSize(const Size(400, 400));
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      Size size = await windowManager.getSize();
      await windowManager.setMinimumSize(Size(540.0, size.height * 0.90));
    });
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Column(
          children: [
            const Text('Scan To Attend'),
            Consumer<AttendanceQrViewModel>(
              builder: (ctx, qrProvider, _) {
                Map<String, String> data = {
                  "path": widget.path,
                  "randomNum": qrProvider.randomNum.toString(),
                  "lecId": widget.lecId,
                };
                final encrypted = encrypter.encrypt(jsonEncode(data), iv: iv);
                return QrImage(
                  backgroundColor: Colors.white,
                  data: encrypted.base64,
                  version: QrVersions.auto,
                  size: 200.0,
                );
              },
            ),
            FilledButton(child: const Text('Exit'), onPressed: () async {
              await Provider.of<AttendanceQrViewModel>(widget.ctx, listen: false).deleteRandomFromDB(widget.lecId);
              Navigator.pop(context);
            },),
          ],
        ),
      ),
    );
  }
}
