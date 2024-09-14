// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/material.dart';

// class Config {
//   static final _config = FirebaseRemoteConfig.instance;

//   static Future<void> initConfig() async {
//     try {
//       await _config.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(minutes: 1),
//           minimumFetchInterval: const Duration(minutes: 30),
//         ),
//       );

//       // Uncomment and define default values if needed
//       // await _config.setDefaults(
//       //   const {
//       //     "show_ads": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer1": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer2": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer3": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer4": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer5": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer6": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer7": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer8": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer9": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer10": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer11": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer12": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer13": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer14": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "writer15": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story1": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story2": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story3": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story4": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story5": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story6": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story7": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story8": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story9": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story10": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story11": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story12": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story13": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story14": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story15": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story16": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story17": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story18": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story19": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story20": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story21": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story22": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story23": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story24": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story25": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story26": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story27": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story28": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story29": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story30": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story31": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story32": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story33": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story34": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //     "story35": "https://apon06.github.io/bookify_api/dummy_api.json",
//       //   },
//       // );

//       await _config.fetchAndActivate();
//       _config.onConfigUpdated.listen(
//         (event) async {
//           await _config.activate();
//           // Optionally, add logging or other actions here
//           debugPrint('Remote Config updated and activated');
//         },
//       );
//     } catch (e) {
//       debugPrint('Failed to initialize Remote Config: $e');
//     }
//   }

//   static String get writer1 => _config.getString('writer1');
//   static String get writer2 => _config.getString('writer2');
//   static String get writer3 => _config.getString('writer3');
//   static String get writer4 => _config.getString('writer4');
//   static String get writer5 => _config.getString('writer5');
//   static String get writer6 => _config.getString('writer6');
//   static String get writer7 => _config.getString('writer7');
//   static String get writer8 => _config.getString('writer8');
//   static String get writer9 => _config.getString('writer9');
//   static String get writer10 => _config.getString('writer10');
//   static String get writer11 => _config.getString('writer11');
//   static String get writer12 => _config.getString('writer12');
//   static String get writer13 => _config.getString('writer13');
//   static String get writer14 => _config.getString('writer14');
//   static String get writer15 => _config.getString('writer15');
//   static String get story1 => _config.getString('story1');
//   static String get story2 => _config.getString('story2');
//   static String get story3 => _config.getString('story3');
//   static String get story4 => _config.getString('story4');
//   static String get story5 => _config.getString('story5');
//   static String get story6 => _config.getString('story6');
//   static String get story7 => _config.getString('story7');
//   static String get story8 => _config.getString('story8');
//   static String get story9 => _config.getString('story9');
//   static String get story10 => _config.getString('story10');
//   static String get story11 => _config.getString('story11');
//   static String get story12 => _config.getString('story12');
//   static String get story13 => _config.getString('story13');
//   static String get story14 => _config.getString('story14');
//   static String get story15 => _config.getString('story15');
//   static String get story16 => _config.getString('story16');
//   static String get story17 => _config.getString('story17');
//   static String get story18 => _config.getString('story18');
//   static String get story19 => _config.getString('story19');
//   static String get story20 => _config.getString('story20');
//   static String get story21 => _config.getString('story21');
//   static String get story22 => _config.getString('story22');
//   static String get story23 => _config.getString('story23');
//   static String get story24 => _config.getString('story24');
//   static String get story25 => _config.getString('story25');
//   static String get story26 => _config.getString('story26');
//   static String get story27 => _config.getString('story27');
//   static String get story28 => _config.getString('story28');
//   static String get story29 => _config.getString('story29');
//   static String get story30 => _config.getString('story30');
//   static String get story31 => _config.getString('story31');
//   static String get story32 => _config.getString('story32');
//   static String get story33 => _config.getString('story33');
//   static String get story34 => _config.getString('story34');
//   static String get story35 => _config.getString('story35');
// }
