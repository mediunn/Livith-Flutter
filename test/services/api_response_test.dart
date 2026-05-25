import 'package:flutter_test/flutter_test.dart';

import 'package:livith/services/api_response.dart';

void main() {
  group('ApiResponse.fromJson은', () {
    test('statusCode/message/data를 파싱하고 dataParser로 data를 변환한다', () {
      // Arrange
      final json = <String, dynamic>{
        'statusCode': 200,
        'error': null,
        'message': 'Success',
        'data': {'available': true},
      };

      // Act
      final response = ApiResponse<bool>.fromJson(
        json,
        (data) => (data as Map<String, dynamic>)['available'] as bool,
      );

      // Assert
      expect(response.statusCode, 200);
      expect(response.message, 'Success');
      expect(response.data, isTrue);
    });

    test('data가 null이면 dataParser를 호출하지 않고 data를 null로 둔다', () {
      // Arrange
      final json = <String, dynamic>{
        'statusCode': 200,
        'message': 'ok',
        'data': null,
      };

      // Act
      final response = ApiResponse<String>.fromJson(
        json,
        (_) => throw StateError('호출되면 안 됨'),
      );

      // Assert
      expect(response.data, isNull);
    });
  });
}
