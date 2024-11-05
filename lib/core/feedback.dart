// import 'dart:io';
// import 'dart:typed_data';
// import 'package:feedback/feedback.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:path_provider/path_provider.dart';

// void feedback(BuildContext context) {
//   BetterFeedback.of(context).show(
//     (feedback) async {
//       final screenShotFilePath = await writeImageToStorage(feedback.screenshot);
//       final Email email = Email(
//         body: feedback.text,
//         subject: 'App FeedBack',
//         recipients: ['appgokeifeedback@gmail.com'],
//         attachmentPaths: [screenShotFilePath],
//         isHTML: false,
//       );
//       await FlutterEmailSender.send(email);
//     },
//   );
// }

// Future<String> writeImageToStorage(Uint8List feedbackScreenShot) async {
//   final Directory output = await getTemporaryDirectory();
//   final String screenShotFilePath = "${output.path}/feedback.png";
//   final File screenShotFile = File(screenShotFilePath);
//   await screenShotFile.writeAsBytes(feedbackScreenShot);
//   return screenShotFilePath;
// }
