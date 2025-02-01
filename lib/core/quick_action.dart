import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import '../page/Home/screen/home_page.dart';
import '../page/person/screen/person_page.dart';
import '../page/setting/screen/setting.dart';

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
