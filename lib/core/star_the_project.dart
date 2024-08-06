import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubStarPrompt {
  static const String _lastShownDateKey = 'lastShownDate';
  static const int _intervalDays = 5;

  static Future<void> checkAndShowDialog(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? lastShownDateStr = prefs.getString(_lastShownDateKey);

    if (lastShownDateStr != null) {
      final DateTime lastShownDate = DateTime.parse(lastShownDateStr);
      final DateTime nextShowDate =
          lastShownDate.add(const Duration(days: _intervalDays));

      if (DateTime.now().isBefore(nextShowDate)) {
        return;
      }
    }

    // ignore: use_build_context_synchronously
    _showGitHubStarDialog(context);
    await prefs.setString(_lastShownDateKey, DateTime.now().toIso8601String());
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
                // final Uri url =
                // Uri.parse('https://github.com/apon10510/bookify_audio');
                final Uri webUrl =
                    Uri.parse('https://github.com/apon10510/bookify_audio');
                if (await canLaunch(webUrl.toString())) {
                  // ignore: deprecated_member_use
                  await launch(webUrl.toString());
                } else {
                  // ignore: deprecated_member_use
                  await launch(webUrl.toString());
                }
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