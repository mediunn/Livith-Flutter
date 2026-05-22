import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/nickname.dart';

void main() {
  group('Nickname.isValid는', () {
    test('영문/숫자/한글 1~10자를 유효한 닉네임으로 판정한다', () {
      expect(Nickname.isValid('라이빗'), isTrue);
      expect(Nickname.isValid('livith12'), isTrue);
      expect(Nickname.isValid('가나다라마바사아자차'), isTrue);
    });

    test('빈 값, 10자 초과, 특수문자를 무효로 판정한다', () {
      expect(Nickname.isValid(''), isFalse);
      expect(Nickname.isValid('가나다라마바사아자차카'), isFalse);
      expect(Nickname.isValid('hello!'), isFalse);
      expect(Nickname.isValid('공백 포함'), isFalse);
    });
  });

  group('Nickname.tryParse는', () {
    test('유효한 값이면 Nickname을, 무효한 값이면 null을 반환한다', () {
      expect(Nickname.tryParse('라이빗')?.value, '라이빗');
      expect(Nickname.tryParse('bad nick!'), isNull);
    });
  });
}
