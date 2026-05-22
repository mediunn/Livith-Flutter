import 'package:livith/providers/network_providers.dart';
import 'package:livith/services/auth_service.dart';
import 'package:livith/services/concert_service.dart';
import 'package:livith/services/preference_service.dart';
import 'package:livith/services/search_service.dart';
import 'package:livith/services/setlist_service.dart';
import 'package:livith/services/song_service.dart';
import 'package:livith/services/social_auth_service.dart';
import 'package:livith/services/user_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 인증/온보딩 Service.
final authServiceProvider = Provider<AuthService>(
  (ref) => DioAuthService(ref.read(dioProvider)),
);

/// 사용자 정보 Service.
final userServiceProvider = Provider<UserService>(
  (ref) => DioUserService(ref.read(dioProvider)),
);

/// 선호 장르/아티스트 Service.
final preferenceServiceProvider = Provider<PreferenceService>(
  (ref) => DioPreferenceService(ref.read(dioProvider)),
);

/// 콘서트 조회 Service.
final concertServiceProvider = Provider<ConcertService>(
  (ref) => DioConcertService(ref.read(dioProvider)),
);

/// 콘서트 검색 Service.
final searchServiceProvider = Provider<SearchService>(
  (ref) => DioSearchService(ref.read(dioProvider)),
);

/// 셋리스트 Service.
final setlistServiceProvider = Provider<SetlistService>(
  (ref) => DioSetlistService(ref.read(dioProvider)),
);

/// 곡 가사 Service.
final songServiceProvider = Provider<SongService>(
  (ref) => DioSongService(ref.read(dioProvider)),
);

/// 소셜 로그인 토큰 획득 Service. 키 확보 전까지 stub을 사용한다.
final socialAuthServiceProvider = Provider<SocialAuthService>(
  (ref) => const StubSocialAuthService(),
);
