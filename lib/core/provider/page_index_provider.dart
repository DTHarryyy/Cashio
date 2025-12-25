import 'package:flutter_riverpod/legacy.dart';

class PageIndexProvider extends StateNotifier<int> {
  PageIndexProvider() : super(0);

  void changePage(int value) {
    state = value;
  }
}

final pageValueProvider = StateNotifierProvider<PageIndexProvider, int>(
  (ref) => PageIndexProvider(),
);
