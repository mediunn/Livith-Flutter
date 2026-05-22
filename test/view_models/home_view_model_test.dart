import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/concert.dart';
import 'package:livith/providers/service_providers.dart';
import 'package:livith/services/concert_service.dart';
import 'package:livith/view_models/home_view_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FakeConcertService implements ConcertService {
  _FakeConcertService({this.recommended = const [], this.interestThrows = false});

  final List<Concert> recommended;
  final bool interestThrows;

  @override
  Future<List<Concert>> fetchRecommendedConcerts() async => recommended;

  @override
  Future<List<Concert>> fetchInterestConcerts() async {
    if (interestThrows) throw Exception('unauthorized');
    return const [];
  }

  @override
  Future<Concert> fetchConcert(int id) => throw UnimplementedError();
}

Concert _concert(int id) => Concert(
      id: id,
      title: 'C$id',
      artist: 'A',
      status: ConcertStatus.upcoming,
    );

void main() {
  group('HomeViewModel.build는', () {
    test('추천 콘서트를 로드해 상태에 담는다', () async {
      final container = ProviderContainer(
        overrides: [
          concertServiceProvider.overrideWithValue(
            _FakeConcertService(recommended: [_concert(1), _concert(2)]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(homeViewModelProvider.future);

      expect(state.recommendedConcertList.length, 2);
    });

    test('관심 콘서트 조회가 실패해도 빈 목록으로 처리하고 추천은 유지한다', () async {
      final container = ProviderContainer(
        overrides: [
          concertServiceProvider.overrideWithValue(
            _FakeConcertService(recommended: [_concert(1)], interestThrows: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(homeViewModelProvider.future);

      expect(state.recommendedConcertList.length, 1);
      expect(state.interestConcertList, isEmpty);
    });
  });
}
