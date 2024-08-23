import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:test/page/Home/screen/home_page.dart';
import 'package:test/page/person/screen/person_page.dart';
import 'package:test/page/setting/screen/setting_page.dart';

const QuickActions quickActions = QuickActions();

initializeAction(BuildContext context) {
  quickActions.initialize((String shortvutType) {
    switch (shortvutType) {
      case 'HomePage':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => const HomePage()));
        return;
      case 'Writer':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => const PersonPage()));
        return;
      default:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => const SettingPage(),
          ),
        );
        return;
    }
  });
  quickActions.setShortcutItems(
    [
      const ShortcutItem(type: 'HomePage', localizedTitle: 'HomePage'),
      const ShortcutItem(
          type: 'Writer', localizedTitle: 'Writer', icon: 'person'),
      const ShortcutItem(
          type: 'Setting', localizedTitle: 'Setting', icon: 'settings'),
    ],
  );
}
