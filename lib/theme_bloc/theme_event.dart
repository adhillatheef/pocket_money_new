part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}


class InitialThemeSetEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

class ThemeSwitchEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}
