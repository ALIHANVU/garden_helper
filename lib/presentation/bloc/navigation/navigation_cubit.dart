import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// NavigationState
class NavigationState extends Equatable {
  final int selectedIndex;

  const NavigationState({this.selectedIndex = 0});

  NavigationState copyWith({int? selectedIndex}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object> get props => [selectedIndex];
}

// NavigationCubit
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}