import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Singleton class for accessing API of native platform Start.io (StartApp) SDK.
class StartAppSdk {
  static final StartAppSdk _instance = StartAppSdk._();

  final MethodChannel _channel = const MethodChannel('com.startapp.flutter');

  final Map<int, VoidCallback> onAdDisplayedCallbacks = Map();
  final Map<int, VoidCallback> onAdNotDisplayedCallbacks = Map();
  final Map<int, VoidCallback> onAdClickedCallbacks = Map();
  final Map<int, VoidCallback> onAdHiddenCallbacks = Map();
  final Map<int, VoidCallback> onAdImpressionCallbacks = Map();
  final Map<int, VoidCallback> onVideoCompletedCallbacks = Map();

  /// It's safe to call this constructor several time, it returns singleton instance.
  factory StartAppSdk() {
    return _instance;
  }

  StartAppSdk._() {
    Map<String, Map<int, VoidCallback>> adEventCallbacks = {
      'adDisplayed': onAdDisplayedCallbacks,
      'adNotDisplayed': onAdNotDisplayedCallbacks,
      'adClicked': onAdClickedCallbacks,
      'adHidden': onAdHiddenCallbacks,
      'adImpression': onAdImpressionCallbacks,
      'videoCompleted': onVideoCompletedCallbacks,
    };

    _channel.setMethodCallHandler((call) {
      if (call.method == 'onAdEvent') {
        dynamic args = call.arguments;
        if (args is Map) {
          dynamic id = args['id'];
          dynamic event = args['event'];

          if (id is int && event is String) {
            var map = adEventCallbacks[event];
            if (map != null) {
              var callback = map[id];
              if (callback != null) {
                callback();
              }
            }
          }
        }
      }

      return Future.value(null);
    });
  }

  void _removeCallbacks(int id) {
    onAdDisplayedCallbacks.remove(id);
    onAdNotDisplayedCallbacks.remove(id);
    onAdClickedCallbacks.remove(id);
    onAdHiddenCallbacks.remove(id);
    onAdImpressionCallbacks.remove(id);
    onVideoCompletedCallbacks.remove(id);
  }

  /// Returns the version of underlying native platform SDK.
  Future getSdkVersion() {
    return _channel.invokeMethod('getSdkVersion');
  }

  /// Enables test ads.
  Future setTestAdsEnabled(bool value) {
    return _channel.invokeMethod('setTestAdsEnabled', value);
  }

  /// Loads banner ad, creates an underlying native platform view.
  ///
  /// Once loaded the banner must be shown immediately with [StartAppBanner].
  /// Banner will be refreshed automatically.
  Future<StartAppBannerAd> loadBannerAd(
    StartAppBannerType type, {
    StartAppAdPreferences prefs = const StartAppAdPreferences(),
    VoidCallback? onAdImpression,
    VoidCallback? onAdClicked,
  }) {
    return _channel.invokeMethod('loadBannerAd', prefs._toMap({'type': type.index})).then((value) {
      if (value is Map) {
        dynamic id = value['id'];

        if (id is int && id > 0) {
          if (onAdImpression != null) {
            onAdImpressionCallbacks[id] = onAdImpression;
          }

          if (onAdClicked != null) {
            onAdClickedCallbacks[id] = onAdClicked;
          }

          return StartAppBannerAd._(id, value.cast());
        }
      }

      throw StartAppException(message: value);
    });
  }

  /// Loads interstitial ad, does not create an underlying native platform view.
  ///
  /// This type of ad can be displayed later during natural UI transition in your app.
  /// Each instance of [StartAppInterstitialAd] can be displayed only once.
  /// You have to load new instance in order to shown an interstitial ad another time.
  /// You must assign [null] to the corresponding field after the ad was shown.
  Future<StartAppInterstitialAd> loadInterstitialAd({
    StartAppInterstitialAdMode mode = StartAppInterstitialAdMode.automatic,
    StartAppAdPreferences prefs = const StartAppAdPreferences(),
    VoidCallback? onAdDisplayed,
    VoidCallback? onAdNotDisplayed,
    VoidCallback? onAdClicked,
    VoidCallback? onAdHidden,
    VoidCallback? onAdImpression,
  }) {
    return _loadFullscreenAd(
      'loadInterstitialAd',
      prefs._toMap({'mode': mode.index}),
      (id, channel) => StartAppInterstitialAd._(id, channel),
      onAdDisplayed: onAdDisplayed,
      onAdNotDisplayed: onAdNotDisplayed,
      onAdClicked: onAdClicked,
      onAdHidden: onAdHidden,
      onAdImpression: onAdImpression,
    );
  }

  /// Loads rewarded video ad, does not create an underlying native platform view.
  Future<StartAppRewardedVideoAd> loadRewardedVideoAd({
    StartAppAdPreferences prefs = const StartAppAdPreferences(),
    VoidCallback? onAdDisplayed,
    VoidCallback? onAdNotDisplayed,
    VoidCallback? onAdClicked,
    VoidCallback? onAdHidden,
    VoidCallback? onAdImpression,
    VoidCallback? onVideoCompleted,
  }) {
    return _loadFullscreenAd(
      'loadRewardedVideoAd',
      prefs._toMap(),
      (id, channel) => StartAppRewardedVideoAd._(id, channel),
      onAdDisplayed: onAdDisplayed,
      onAdNotDisplayed: onAdNotDisplayed,
      onAdClicked: onAdClicked,
      onAdHidden: onAdHidden,
      onAdImpression: onAdImpression,
      onVideoCompleted: onVideoCompleted,
    );
  }

  Future<T> _loadFullscreenAd<T extends _StartAppFullScreenAd>(
    String methodName,
    Map<String, dynamic> methodArgs,
    T factory(int id, MethodChannel channel), {
    VoidCallback? onAdDisplayed,
    VoidCallback? onAdNotDisplayed,
    VoidCallback? onAdClicked,
    VoidCallback? onAdHidden,
    VoidCallback? onAdImpression,
    VoidCallback? onVideoCompleted,
  }) {
    return _channel.invokeMethod(methodName, methodArgs).then((value) {
      if (value is Map) {
        dynamic id = value['id'];

        if (id is int && id > 0) {
          if (onAdDisplayed != null) {
            onAdDisplayedCallbacks[id] = onAdDisplayed;
          }

          if (onAdNotDisplayed != null) {
            onAdNotDisplayedCallbacks[id] = onAdNotDisplayed;
          }

          if (onAdClicked != null) {
            onAdClickedCallbacks[id] = onAdClicked;
          }

          if (onAdHidden != null) {
            onAdHiddenCallbacks[id] = onAdHidden;
          }

          if (onAdImpression != null) {
            onAdImpressionCallbacks[id] = onAdImpression;
          }

          if (onVideoCompleted != null) {
            onVideoCompletedCallbacks[id] = onVideoCompleted;
          }

          return factory(id, _channel);
        }
      }

      throw StartAppException(message: value);
    });
  }

  /// Loads native ad, does not create an underlying native platform view.
  ///
  /// Once loaded the native ad must be shown with [StartAppNative].
  /// In opposite to banners, native ad can't be refreshed automatically.
  /// You must take care about interval of reloading native ads.
  /// Default interval for reloading banners is 45 seconds, which can be good for native ads as well.
  /// Make sure you don't load native ad too frequently, cause this may negatively impact your revenue.
  ///
  /// IMPORTANT: You must not handle touch/click events from widgets of your native ad. Clicks are handled
  /// by underlying view, so make sure your buttons or other widgets doesn't intercept touch/click events.
  Future<StartAppNativeAd> loadNativeAd({
    StartAppAdPreferences prefs = const StartAppAdPreferences(),
    VoidCallback? onAdImpression,
    VoidCallback? onAdClicked,
  }) {
    return _channel.invokeMethod('loadNativeAd', prefs._toMap()).then((value) {
      if (value is Map) {
        dynamic id = value['id'];

        if (id is int && id > 0) {
          if (onAdImpression != null) {
            onAdImpressionCallbacks[id] = onAdImpression;
          }

          if (onAdClicked != null) {
            onAdClickedCallbacks[id] = onAdClicked;
          }
          return StartAppNativeAd._(id, value.cast());
        }
      }

      throw StartAppException(message: value);
    });
  }
}

/// Class with parameters to be passed into methods [StartAppSdk.loadBannerAd()],
/// [StartAppSdk.loadInterstitialAd()], [StartAppSdk.loadNativeAd()].
class StartAppAdPreferences {
  /// Ad tag is used to distinguish different placements within your app.
  /// Also know as 'ad unit', 'placement id', etc.
  final String? adTag;

  /// Specify keywords of the content within certain placement within your app.
  final String? keywords;

  /// Pass gender of your user if you know it.
  final String? gender;

  /// Pass age of your user if you know it.
  final int? age;

  /// Pass [true] if you prefer to mute video ad.
  final bool? videoMuted;

  /// Pass [true] if you prefer to use hardware acceleration.
  final bool? hardwareAccelerated;

  /// Pass categories of the ad you want to load.
  final List<String>? categories;

  /// Pass categories of the ad you do not want to load.
  final List<String>? categoriesExclude;

  /// Desired width of an ad. Only applicable for [StartAppBannerAd].
  final int? desiredWidth;

  /// Desired height of an ad. Only applicable for [StartAppBannerAd].
  final int? desiredHeight;

  /// Minimal cost per impression for loaded ads.
  final double? minCPM;

  const StartAppAdPreferences({
    this.adTag,
    this.keywords,
    this.gender,
    this.age,
    this.videoMuted,
    this.hardwareAccelerated,
    this.categories,
    this.categoriesExclude,
    this.desiredWidth,
    this.desiredHeight,
    this.minCPM,
  });

  Map<String, dynamic> _toMap([Map<String, dynamic>? map]) {
    if (map == null) {
      map = {};
    }

    map.addAll({
      'adTag': adTag,
      'keywords': keywords,
      'gender': gender,
      'age': age,
      'videoMuted': videoMuted,
      'hardwareAccelerated': hardwareAccelerated,
      'categories': categories,
      'categoriesExclude': categoriesExclude,
      'desiredWidth': desiredWidth,
      'desiredHeight': desiredHeight,
      'minCPM': minCPM,
    });

    return map;
  }
}

/// Type of the banner.
enum StartAppBannerType {
  /// 320x50
  BANNER,

  /// 300x250
  MREC,

  /// 1200x628
  COVER,
}

class _StartAppAd {
  final int _id;

  _StartAppAd(this._id);

  void dispose() {
    StartAppSdk._instance._removeCallbacks(_id);
  }
}

abstract class _StartAppStatefulWidget<Ad extends _StartAppAd> extends StatefulWidget {
  final Ad _ad;

  _StartAppStatefulWidget(this._ad);

  void dispose() {
    _ad.dispose();
  }
}

/// Proxy object which holds an underlying native platform view.
class StartAppBannerAd extends _StartAppAd {
  final Map<String, dynamic> _data;

  StartAppBannerAd._(id, this._data) : super(id);

  /// Returns a width of the widget.
  double? get width {
    dynamic value = _data['width'];
    return value is num ? value.toDouble() : null;
  }

  /// Returns a height of the widget.
  double? get height {
    dynamic value = _data['height'];
    return value is num ? value.toDouble() : null;
  }
}

/// Widget to display [StartAppBannerAd].
class StartAppBanner extends _StartAppStatefulWidget<StartAppBannerAd> {
  StartAppBanner(super.ad);

  @override
  State createState() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _StartAppAndroidViewState(
          'com.startapp.flutter.Banner',
          creationParams: {
            'adId': _ad._id,
          },
          width: _ad.width,
          height: _ad.height,
        );
      case TargetPlatform.iOS:
        return _StartAppiOSViewState(
          'com.startapp.flutter.Banner',
          creationParams: {
            'adId': _ad._id,
          },
          width: _ad.width,
          height: _ad.height,
        );
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}

enum StartAppInterstitialAdMode {
  automatic,
  video,
}

/// Base class for different types of fullscreen ads. Proxy object which holds a fullscreen ad ready to be shown.
class _StartAppFullScreenAd extends _StartAppAd {
  final MethodChannel _channel;

  _StartAppFullScreenAd._(id, this._channel) : super(id);
}

/// Proxy object which holds an interstitial ad ready to be shown.
class StartAppInterstitialAd extends _StartAppFullScreenAd {
  StartAppInterstitialAd._(int id, MethodChannel channel) : super._(id, channel);

  /// Show an ad.
  Future<bool> show() {
    return _channel.invokeMethod('showInterstitialAd', {
      'id': _id,
    }).then((value) {
      return value is bool && value;
    });
  }
}

/// Proxy object which holds an interstitial ad ready to be shown.
class StartAppRewardedVideoAd extends _StartAppFullScreenAd {
  StartAppRewardedVideoAd._(int id, MethodChannel channel) : super._(id, channel);

  /// Show an ad.
  Future<bool> show() {
    return _channel.invokeMethod('showRewardedVideoAd', {
      'id': _id,
    }).then((value) {
      return value is bool && value;
    });
  }
}

/// Proxy object which holds a native ad ready to be shown.
class StartAppNativeAd extends _StartAppAd {
  final Map<String, dynamic> _data;

  StartAppNativeAd._(id, this._data) : super(id);

  /// The main line of an ad, which must stands out well
  String? get title {
    return _safeValue<String>('title');
  }

  /// The secondary text of an ad, which must have less visual accent comparing to the [title].
  String? get description {
    return _safeValue<String>('description');
  }

  /// Rating of an app or website which is advertised.
  double? get rating {
    return _safeValue<num>('rating')?.toDouble();
  }

  /// Number of app installs.
  String? get installs {
    return _safeValue<String>('installs');

  }

  /// Category of app or website.
  String? get category {
    return _safeValue<String>('category');
  }

  /// Type of campaign.
  String? get campaign {
    return _safeValue<String>('campaign');

  }

  /// Title which must be displayed within the main button of an ad.
  String? get callToAction {
    return _safeValue<String>('callToAction');

  }

  /// URL of the main image of an ad.
  String? get imageUrl {
    return _safeValue<String>('imageUrl');
  }

  /// URL of the secondary image of an ad.
  String? get secondaryImageUrl {
    return _safeValue<String>('secondaryImageUrl');
  }

  T? _safeValue<T>(key) {
    dynamic value = _data[key];
    return value is T ? value : null;
  }
}

typedef StartAppNativeWidgetBuilder = Widget Function(BuildContext context, StateSetter setState, StartAppNativeAd nativeAd);

/// Parent widget to display [StartAppNativeAd], your main layout will be requested via [StartAppNativeWidgetBuilder].
class StartAppNative extends _StartAppStatefulWidget<StartAppNativeAd> {
  final StartAppNativeWidgetBuilder _builder;
  final double? width;
  final double? height;
  final bool ignorePointer;

  StartAppNative(
    StartAppNativeAd ad,
    this._builder, {
    this.width,
    this.height,
    this.ignorePointer = true,
  }) : super(ad);

  @override
  State<StatefulWidget> createState() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _StartAppAndroidViewState(
          'com.startapp.flutter.Native',
          creationParams: {
            'adId': _ad._id,
            'width': width,
            'height': height,
          },
          width: width,
          height: height,
          overlayBuilder: (context, setState) {
            return IgnorePointer(
              ignoring: ignorePointer,
              child: _builder(context, setState, _ad),
            );
          },
        );
      case TargetPlatform.iOS:
        return _StartAppiOSViewState(
          'com.startapp.flutter.Native',
          creationParams: {
            'adId': _ad._id,
            'width': width,
            'height': height,
          },
          width: width,
          height: height,
          overlayBuilder: (context, setState) {
            return IgnorePointer(
              ignoring: ignorePointer,
              child: _builder(context, setState, _ad),
            );
          },
        );
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}

abstract class _StartAppNativeViewState extends State<_StartAppStatefulWidget> {
  final String viewType;
  final Map<String, dynamic> creationParams;
  final double? width;
  final double? height;
  final StatefulWidgetBuilder? overlayBuilder;

  _StartAppNativeViewState(
    this.viewType, {
    this.creationParams = const {},
    this.width,
    this.height,
    this.overlayBuilder,
  });

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  Widget buildNativeWidget(BuildContext context);

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          overlayBuilder != null ? StatefulBuilder(builder: overlayBuilder!) : Container(),
          buildNativeWidget(context),
        ],
      ),
    );
  }
}

class _StartAppAndroidViewState extends _StartAppNativeViewState {
  _StartAppAndroidViewState(
    String viewType, {
    Map<String, dynamic> creationParams = const {},
    double? width,
    double? height,
    StatefulWidgetBuilder? overlayBuilder,
  }) : super(
          viewType,
          creationParams: creationParams,
          width: width,
          height: height,
          overlayBuilder: overlayBuilder,
        );

  Widget buildNativeWidget(BuildContext context) {
    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}

class _StartAppiOSViewState extends _StartAppNativeViewState {
  _StartAppiOSViewState(
    String viewType, {
    Map<String, dynamic> creationParams = const {},
    double? width,
    double? height,
    StatefulWidgetBuilder? overlayBuilder,
  }) : super(
          viewType,
          creationParams: creationParams,
          width: width,
          height: height,
          overlayBuilder: overlayBuilder,
        );

  Widget buildNativeWidget(BuildContext context) {
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

class StartAppException implements Exception {
  final dynamic message;

  StartAppException({this.message});
}
