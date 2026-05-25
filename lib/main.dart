import 'package:flutter/material.dart';

import 'package:livith/app.dart';
import 'package:livith/providers/network_providers.dart';
import 'package:livith/services/token_store.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// 개발 검증용 토큰. `--dart-define=LIVITH_DEV_TOKEN=...`로 주입하면
/// 로그인 없이 인증 상태로 시작한다. 미주입 시 빈 값으로 일반 흐름을 따른다.
const String _devToken = String.fromEnvironment('LIVITH_DEV_TOKEN');

/// 카카오 네이티브 앱키. `--dart-define=KAKAO_NATIVE_APP_KEY=...`로 주입한다.
const String _kakaoNativeAppKey = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (_kakaoNativeAppKey.isNotEmpty) {
    KakaoSdk.init(nativeAppKey: _kakaoNativeAppKey);
  }

  runApp(
    ProviderScope(
      overrides: [
        if (_devToken.isNotEmpty)
          tokenStoreProvider.overrideWithValue(
            InMemoryTokenStore(accessToken: _devToken, refreshToken: _devToken),
          ),
      ],
      child: const App(),
    ),
  );
}
