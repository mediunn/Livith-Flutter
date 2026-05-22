import 'package:livith/providers/network_providers.dart';
import 'package:livith/services/auth_service.dart';
import 'package:livith/services/user_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 인증/온보딩 Service.
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.read(dioProvider)),
);

/// 사용자 정보 Service.
final userServiceProvider = Provider<UserService>(
  (ref) => UserService(ref.read(dioProvider)),
);
