import 'package:cashio/features/auth/model/app_user.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentUserProfileProvider = StateProvider<AppUser?>((ref) => null);
