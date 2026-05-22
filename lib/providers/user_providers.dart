import 'package:livith/models/user.dart';
import 'package:livith/providers/service_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 현재 로그인한 사용자 프로필.
final userProfileProvider = FutureProvider.autoDispose<User>(
  (ref) => ref.read(userServiceProvider).fetchMe(),
);
