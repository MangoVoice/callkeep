import 'package:flutter/foundation.dart';

/// Main configuration options for CallKeep
class CallKeepOptions {
  /// Constructor for CallKeep options
  CallKeepOptions({
    required this.ios,
    required this.android,
  });

  /// iOS specific configuration
  final IOSOptions ios;

  /// Android specific configuration
  final AndroidOptions android;

  /// Convert to a Map for passing to the platform channels
  Map<String, dynamic> toMap() {
    return {
      'ios': ios.toMap(),
      'android': android.toMap(),
    };
  }
}

/// iOS specific configuration options
class IOSOptions {
  /// Constructor for iOS options
  IOSOptions({
    required this.appName,
    this.handleType = 'number',
    this.supportsVideo = true,
    this.maximumCallGroups = 3,
    this.maximumCallsPerCallGroup = 1,
    this.imageName,
    this.ringtoneSound,
    this.includesCallsInRecents,
    this.supportsDTMF,
    this.supportsHolding,
    this.supportsGrouping,
    this.supportsUngrouping,
  });

  /// App name displayed in CallKit UI (required)
  final String appName;

  /// Type of handle - 'generic', 'number', or 'email'
  final String handleType;

  /// Whether video calls are supported
  final bool supportsVideo;

  /// Maximum number of call groups
  final int maximumCallGroups;

  /// Maximum number of calls per call group
  final int maximumCallsPerCallGroup;

  /// Image name for CallKit UI
  final String? imageName;

  /// Custom ringtone sound
  final String? ringtoneSound;

  /// Whether to include calls in the recent calls list
  final bool? includesCallsInRecents;

  /// Whether the app supports DTMF (touch tone) codes
  final bool? supportsDTMF;

  /// Whether the app supports holding calls
  final bool? supportsHolding;

  /// Whether the app supports grouping calls
  final bool? supportsGrouping;

  /// Whether the app supports ungrouping calls
  final bool? supportsUngrouping;

  /// Convert to a Map for passing to the platform channels
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'appName': appName,
      'handleType': handleType,
      'supportsVideo': supportsVideo,
      'maximumCallGroups': maximumCallGroups,
      'maximumCallsPerCallGroup': maximumCallsPerCallGroup,
    };

    if (imageName != null) map['imageName'] = imageName;
    if (ringtoneSound != null) map['ringtoneSound'] = ringtoneSound;
    if (includesCallsInRecents != null) {
      map['includesCallsInRecents'] = includesCallsInRecents;
    }
    if (supportsDTMF != null) map['supportsDTMF'] = supportsDTMF;
    if (supportsHolding != null) map['supportsHolding'] = supportsHolding;
    if (supportsGrouping != null) map['supportsGrouping'] = supportsGrouping;
    if (supportsUngrouping != null) {
      map['supportsUngrouping'] = supportsUngrouping;
    }

    return map;
  }
}

/// Android specific configuration options
class AndroidOptions {
  /// Constructor for Android options
  AndroidOptions({
    this.additionalPermissions,
    this.foregroundService,
  });

  /// List of additional permissions to request
  final List<String>? additionalPermissions;

  /// Foreground service configuration
  final ForegroundServiceOptions? foregroundService;

  /// Convert to a Map for passing to the platform channels
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (additionalPermissions != null && additionalPermissions!.isNotEmpty) {
      map['additionalPermissions'] = additionalPermissions;
    }
    if (foregroundService != null) {
      map['foregroundService'] = foregroundService!.toMap();
    }

    return map;
  }
}

/// Foreground service configuration for Android
class ForegroundServiceOptions {
  /// Constructor for foreground service options
  ForegroundServiceOptions({
    required this.channelId,
    required this.channelName,
    required this.notificationTitle,
    this.notificationIcon,
    this.notificationId,
    this.packageName,
    this.singleInstance = true,
    this.noAnimation = true,
  });

  /// Channel ID for the notification
  final String channelId;

  /// Channel name for the notification
  final String channelName;

  /// Title displayed in the notification
  final String notificationTitle;

  /// Icon displayed in the notification
  final String? notificationIcon;

  /// Notification ID
  final int? notificationId;

  /// Package name for the application
  final String? packageName;

  /// Whether to use a single instance when starting the main activity
  final bool singleInstance;

  /// Whether to disable animation when starting the main activity
  final bool noAnimation;

  /// Convert to a Map for passing to the platform channels
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'channelId': channelId,
      'channelName': channelName,
      'notificationTitle': notificationTitle,
      'singleInstance': singleInstance,
      'noAnimation': noAnimation,
    };

    if (notificationIcon != null) map['notificationIcon'] = notificationIcon;
    if (notificationId != null) map['notificationId'] = notificationId;
    if (packageName != null) map['packageName'] = packageName;

    return map;
  }
}

Future<void> setup({
  Future<bool> Function()? showAlertDialog,
  required CallKeepOptions options,
  bool backgroundMode = false,
}) async {
  _showAlertDialog = showAlertDialog;
  if (!isIOS) {
    await _setupAndroid(
      options: options.android,
      backgroundMode: backgroundMode,
    );
    return;
  }
  await _setupIOS(options: options.ios);
}