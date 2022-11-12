import 'package:fluent_ui/fluent_ui.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ProjectNameAnimation extends StatelessWidget {

  ProjectNameAnimation({super.key,required this.textStyle});
  final colorizeColors = [
    Colors.white,
    Colors.black,
  ];
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'Student Attendance',
              textStyle: textStyle,
              colors: colorizeColors,
            ),
          ],
          //isRepeatingAnimation: true,
          repeatForever: false,
          isRepeatingAnimation: false,
          totalRepeatCount: 1,
          // onTap: () {
          //   print("Tap Event");
          // },
        ),
        const SizedBox(
          height: 10,
        ),
        DefaultTextStyle(
          style: const TextStyle(
            fontSize: 20.0,
            // fontFamily: 'Agne',
          ),
          child: AnimatedTextKit(
            totalRepeatCount: 2,
            //repeatForever: true,
            animatedTexts: [
              TypewriterAnimatedText(
                speed: const Duration(milliseconds: 80),
                'No more wasting time taking attendance and absence.',
              ),
            ],
            // onTap: () {
            //   print("Tap Event");
            // },
          ),
        ),
      ],
    );
  }
}
