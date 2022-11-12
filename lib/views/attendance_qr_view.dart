import 'dart:async';
import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../res/constants.dart';
import '../view_model/attendance_qr_view_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../view_model/lecture_attendance_view_model.dart';

class AttendanceQrView extends StatefulWidget {
  const AttendanceQrView(
      {Key? key, required this.path, required this.lecId, required this.ctx})
      : super(key: key);

  final String path;
  final String lecId;
  final BuildContext ctx;

  @override
  State<AttendanceQrView> createState() => _AttendanceQrViewState();
}

class _AttendanceQrViewState extends State<AttendanceQrView> {
  late encrypt.Encrypter encrypter;
  late encrypt.IV iv;
  late Timer timer;

  late Timer countTimer;
  late Duration countDuration;
  late Size initSize;

  @override
  void initState() {
    final key = encrypt.Key.fromUtf8(Constants.encryptKey);
    iv = encrypt.IV.fromLength(16);
    encrypter = encrypt.Encrypter(encrypt.AES(key));
    countDuration = const Duration(minutes: 5);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      countTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
        const reduceSecondsBy = 1;
        if (mounted) {
          setState(() {
            final seconds = countDuration.inSeconds - reduceSecondsBy;
            if (seconds < 0) {
              endTakingAttendance().then((value){
                Provider.of<LecturesAttendanceViewModel>(context,
                            listen: false)
                        .setFetchLiveAttendance = false;
                Navigator.pop(context);
              });
            } else {
              countDuration = Duration(seconds: seconds);
            }
          });
        }
      });
      await Provider.of<AttendanceQrViewModel>(widget.ctx, listen: false)
          .changeRandomNum(widget.lecId);
      timer = Timer.periodic(
        const Duration(seconds: 10),
        (_) async {
          await Provider.of<AttendanceQrViewModel>(widget.ctx, listen: false)
              .changeRandomNum(widget.lecId);
        },
      );
      initSize = await windowManager.getSize();
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      //await windowManager.setAsFrameless();
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setMinimumSize(const Size(250, 220));
      await windowManager.setPosition(const Offset(0, 0));
      await windowManager.setSize(const Size(250, 220));
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await endTakingAttendance();
      }
    });
    super.dispose();
  }

  Future<void> endTakingAttendance() async {
    Size size = await windowManager.getSize();
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setMinimumSize(Size(540.0, size.height * 0.90));
    await windowManager.setSize(initSize);
    await windowManager.setMinimumSize(Size(540.0, size.height * 0.90));
    timer.cancel();
    countTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = strDigits(countDuration.inMinutes.remainder(60));
    final String seconds = strDigits(countDuration.inSeconds.remainder(60));
    return ScaffoldPage(
      header: Center(
        child: Text('$minutes:$seconds'),
      ),
      content: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Scan To Attend'),
              // const SizedBox(
              //   height: 16.0,
              // ),
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
                    size: 125.0,
                  );
                },
              ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              FilledButton(
                child: const Text('Exit'),
                onPressed: () async {
                  // Provider.of<LecturesAttendanceViewModel>(context,
                  //         listen: false)
                  //     .FetchLiveAttendance = false;
                  Provider.of<LecturesAttendanceViewModel>(context,
                      listen: false)
                      .setFetchLiveAttendance = false;
                  await Provider.of<AttendanceQrViewModel>(widget.ctx,
                          listen: false)
                      .deleteRandomFromDB(widget.lecId);
                  endTakingAttendance().then((value) {
                    Provider.of<LecturesAttendanceViewModel>(context,
                            listen: false)
                        .setFetchLiveAttendance = false;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
