// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// class GitHubStarPrompt {
//   static const String _lastShownDateKey = 'lastShownDate';
//   static const int _intervalDays = 5;

//   static Future<void> checkAndShowDialog(BuildContext context) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? lastShownDateStr = prefs.getString(_lastShownDateKey);

//     if (lastShownDateStr != null) {
//       final DateTime lastShownDate = DateTime.parse(lastShownDateStr);
//       final DateTime nextShowDate =
//           lastShownDate.add(const Duration(days: _intervalDays));

//       if (DateTime.now().isBefore(nextShowDate)) {
//         return;
//       }
//     }

//     // ignore: use_build_context_synchronously
//     _showGitHubStarDialog(context);
//     await prefs.setString(_lastShownDateKey, DateTime.now().toIso8601String());
//   }

//   static void _showGitHubStarDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Support our Project'),
//           content: const Text('Please star our GitHub project!'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Star on GitHub'),
//               onPressed: () async {
//                 // final Uri url =
//                 // Uri.parse('https://github.com/apon06/bookify_audio');
//                 final Uri webUrl =
//                     Uri.parse('https://github.com/apon06/bookify_audio');
//                 // ignore: deprecated_member_use
//                 if (await canLaunch(webUrl.toString())) {
//                   // ignore: deprecated_member_use
//                   await launch(webUrl.toString());
//                 } else {
//                   // ignore: deprecated_member_use
//                   await launch(webUrl.toString());
//                 }
//               },
//             ),
//             TextButton(
//               child: const Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GitHubStarPrompt.checkAndShowDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Welcome to the app!'),
      ),
    );
  }
}

class GitHubStarPrompt {
  static const String _lastShownDateKey = 'lastShownDate';
  static const String _hasStarredKey = 'hasStarred';
  static const int _initialDelayDays = 21;

  static Future<void> checkAndShowDialog(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? lastShownDateStr = prefs.getString(_lastShownDateKey);
    final bool hasStarred = prefs.getBool(_hasStarredKey) ?? false;

    if (hasStarred) {
      return; // Don't show the dialog if the user has already starred
    }

    if (lastShownDateStr == null) {
      // First time app install
      final DateTime installDate = DateTime.now();
      final DateTime showDate = installDate.add(const Duration(days: _initialDelayDays));
      await prefs.setString(_lastShownDateKey, installDate.toIso8601String());
      
      if (DateTime.now().isBefore(showDate)) {
        return; // Don't show the dialog yet
      }
    }

    // ignore: use_build_context_synchronously
    _showGitHubStarDialog(context);
  }

  static void _showGitHubStarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Support our Project'),
          content: const Text('Please star our GitHub project!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Star on GitHub'),
              onPressed: () async {
                final Uri webUrl = Uri.parse('https://github.com/apon06/bookify_audio');
                // ignore: deprecated_member_use
                if (await canLaunch(webUrl.toString())) {
                  // ignore: deprecated_member_use
                  await launch(webUrl.toString());
                  // Mark as starred
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool(_hasStarredKey, true);
                } else {
                  // Handle error
                  // print('Could not launch $webUrl');
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}