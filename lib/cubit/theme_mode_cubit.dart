import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// A [HydratedCubit] that manages the theme mode of the application.
class ThemeModeCubit extends HydratedCubit<ThemeMode> {
  /// Initializes the cubit with the light theme mode.
  ThemeModeCubit() : super(ThemeMode.light);

  /// Toggles the brightness between light and dark.
  void toggleBrightness() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  /// Converts the theme mode from JSON.
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['brightness'] as int];
  }

  /// Converts the theme mode to JSON.
  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return <String, int>{'brightness' : state.index};
  }
}