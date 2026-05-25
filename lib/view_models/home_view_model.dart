import 'package:livith/models/concert.dart';
import 'package:livith/providers/service_providers.dart';
import 'package:livith/services/concert_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 홈 화면 상태.
final class HomeState {
  const HomeState({this.recommendedConcertList = const [], this.interestConcertList = const []});

  final List<Concert> recommendedConcertList;
  final List<Concert> interestConcertList;
}

/// 홈 화면 ViewModel. 추천/관심 콘서트를 로드한다.
final class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final service = ref.read(concertServiceProvider);
    final recommended = await service.fetchRecommendedConcerts();
    final interest = await _interestOrEmpty(service);
    return HomeState(
      recommendedConcertList: recommended,
      interestConcertList: interest,
    );
  }

  /// 관심 콘서트는 미인증/실패 시 빈 목록으로 처리한다.
  Future<List<Concert>> _interestOrEmpty(ConcertService service) async {
    try {
      return await service.fetchInterestConcerts();
    } on Object {
      return const [];
    }
  }
}

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);
