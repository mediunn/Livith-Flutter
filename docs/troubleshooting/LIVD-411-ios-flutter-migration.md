# LIVD-411 iOS 프로젝트 플러터로 이관 - 트러블슈팅

## 기록

### 2026-05-23 13:00 - 실제 staging API 응답과 모델 키 불일치

**상황**
- 테스트 토큰으로 staging API(`/users/me`, `/genres`, `/search/concerts`, `/concerts/{id}`, `.../artist`, `.../comments`)를 호출해 모델 fromJson 키를 대조했다.

**문제**
- 콘서트 포스터 키가 `posterUrl`이 아니라 `poster`였다.
- 아티스트 응답의 이름/소개 키가 `name`/`introduction`이 아니라 `artist`/`detail`이었다.
- `/search/concerts`, `/concerts/{id}/comments`는 `data`가 `{ data: [...], cursor, totalCount }`로 한 단계 더 중첩되어 있었다(추천/셋리스트/장르는 `data` 직접 배열).

**원인**
- iOS DTO의 Swift 프로퍼티명을 서버 JSON 키로 추정했으나 실제 키와 달랐고, 검색/댓글은 페이지네이션 래퍼가 추가로 있었다.

**해결**
- `Concert.fromJson` 포스터 키를 `poster`로, `ConcertArtist.fromJson`을 `artist`/`detail`로 수정.
- `SearchService`/`CommentService`의 응답 파싱을 `data.data` 중첩 구조에 맞게 수정.

**교훈**
- JSON 키는 추정하지 말고 실제 응답으로 대조한다. 목록 응답은 페이지네이션 래퍼 중첩 여부를 먼저 확인한다.


### 2026-05-22 19:03 - LivithChip이 가로 전체 너비로 늘어남

**상황**
- 디자인시스템 미리보기 화면에서 `LivithChip`을 `Wrap` 안에 배치하고 에뮬레이터로 시각 검증했다.

**문제**
- 칩이 콘텐츠 크기로 줄어들지 않고 가로 전체 너비를 차지했다. iOS는 콘텐츠 크기(hug)로 표시된다.

**원인**
- `Container`에 `alignment`(또는 `height`)를 지정하면 부모가 주는 제약을 가능한 한 채우도록 확장된다. `Wrap`이 loose 제약을 주는 상황에서 `alignment: Alignment.center`가 칩을 가로로 늘렸다.

**해결**
- `Container`의 `alignment`와 고정 `height: 30`을 제거하고 `padding`만으로 크기를 결정하도록 변경했다. iOS 스펙의 높이 30은 수평/수직 패딩으로 자연히 충족된다.

**교훈**
- 콘텐츠 크기로 hug되어야 하는 위젯에는 `Container`의 `alignment`/`height`를 지정하지 않는다. 수직 정렬이 필요하면 패딩 또는 `IntrinsicHeight`/`Center`를 자식 쪽에서 다룬다.

---

<!-- 새 항목은 위에 추가한다 (최신순 정렬) -->
