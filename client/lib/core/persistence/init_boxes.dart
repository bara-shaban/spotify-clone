import 'package:hive_flutter/hive_flutter.dart';

/// Container for initialized Hive boxes used in the application.
class InitBoxes {
  /// Initializes the Hive boxes used in the application.
  const InitBoxes({
    required this.authBox,
  });

  /// The Hive box for authentication data.
  final Box<dynamic> authBox;
}
