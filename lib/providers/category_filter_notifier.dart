import 'package:flutter/material.dart';

final ValueNotifier<String> categoryFilterNotifier = ValueNotifier<String>('All');

void resetCategoryFilter() {
  categoryFilterNotifier.value = 'All';
}