import 'package:client/core/config/env.dart';
import 'package:client/core/providers/env_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Provider that exposes the Hive auth box.
/// The box name is determined by the current flavor.
///
/// Example:
///   - dev => 'auth_box_dev'
///   - staging => 'auth_box_staging'
///   - prod => 'auth_box_prod'
///
/// Consumers just call:
///   ref.watch(authBoxProvider);
///
/// They atomatically get AsyncValue with the correct flavor applied.
final authBoxProvider = FutureProvider.autoDispose.family<Box<dynamic>, String>(
  (ref, flavor) async {
    final env = ref.watch(envProvider);
    final boxName = getAuthBoxNameForFlavor(env.flavor);

    await Hive.initFlutter();

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<dynamic>(boxName);
    }
    final box = await Hive.openBox<dynamic>(boxName);
    return box;
  },
);
