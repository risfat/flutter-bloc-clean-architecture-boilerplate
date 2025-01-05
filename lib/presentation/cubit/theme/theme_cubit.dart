import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/config/boxs.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeLight()) {
    _loadTheme();
  }

  static const String _themeBoxName = HiveBox.themeBox;
  static const String _themeKey = HiveBox.themeKey;

  Future<void> _loadTheme() async {
    final Box<bool> box = await Hive.openBox<bool>(_themeBoxName);
    final isDark = box.get(_themeKey, defaultValue: false)!;
    emit(isDark ? ThemeDark() : ThemeLight());
  }

  Future<void> changeTheme() async {
    final newState = state is ThemeLight ? ThemeDark() : ThemeLight();
    emit(newState);

    final box = await Hive.openBox<bool>(_themeBoxName);
    await box.put(_themeKey, newState is ThemeDark);
  }
}
