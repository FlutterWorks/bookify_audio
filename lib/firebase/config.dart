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

//       await _config.setDefaults(
//         const {
//           "fullapps": true,
//         },
//       );

//       await _config.fetchAndActivate();
//       _config.onConfigUpdated.listen(
//         (event) async {
//           await _config.activate();
//           debugPrint('Remote Config updated and activated');
//         },
//       );
//     } catch (e) {
//       debugPrint('Failed to initialize Remote Config: $e');
//     }
//   }

//   static bool get fullapps => _config.getBool('fullapps');
// }
