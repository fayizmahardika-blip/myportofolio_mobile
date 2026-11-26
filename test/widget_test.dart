import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const _example = {
  'id': 'project-1',
  'title': 'Proyek Flutter',
  'description': 'Deskripsi proyek',
  'tech_stack': 'Flutter',
  'project_url': 'https://example.com/project',
  'project_image_url': '',
};

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openDrawer(WidgetTester tester) =>
    _tap(tester, find.byTooltip('Open navigation menu'));

Future<void> _login(WidgetTester tester) async {
  expect(find.byType(LoginScreen), findsOneWidget);
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'owner');
  await tester.enterText(fields.at(1), 'password');
  await _tap(tester, find.widgetWithText(FilledButton, 'Login'));
}

MyApp _app(Future<http.Response> Function(http.Request) handler) =>
    MyApp(apiClient: ApiClient(client: MockClient(handler)));

void main() {
  testWidgets('Public project list opens project detail without login', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/projects/');
        expect(request.headers['authorization'], isNull);
        return http.Response(jsonEncode([_example]), 200);
      }),
    );
    await _tap(tester, find.text('Lihat Proyek'));
    expect(find.byType(LoginScreen), findsNothing);
    await _tap(tester, find.text('Proyek Flutter'));
    expect(find.text('https://example.com/project'), findsOneWidget);
  });

  testWidgets('Drawer guards creation, validates URL and sends token', (
    tester,
  ) async {
    var creates = 0;
    await tester.pumpWidget(
      _app((request) async {
        switch (request.url.path) {
          case '/api/v1/auth/token/':
            expect(jsonDecode(request.body), {
              'username': 'owner',
              'password': 'password',
            });
            return http.Response('{"token":"example"}', 200);
          case '/api/v1/projects/':
            creates++;
            expect(request.method, 'POST');
            expect(request.headers['authorization'], 'Token example');
            expect(jsonDecode(request.body), Map.of(_example)..remove('id'));
            return http.Response(jsonEncode(_example), 201);
          case '/api/v1/auth/logout/':
            expect(request.headers['authorization'], 'Token example');
            return http.Response('', 204);
        }
        throw StateError('Unexpected request ${request.url.path}');
      }),
    );
    await _openDrawer(tester);
    await _tap(tester, find.text('Add Project'));
    await _login(tester);
    expect(find.byType(ProjectFormPage), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Proyek Flutter');
    await tester.enterText(fields.at(1), 'Deskripsi proyek');
    await tester.enterText(fields.at(2), 'Flutter');
    await tester.enterText(fields.at(3), 'bukan-url');
    await _tap(tester, find.text('Simpan'));
    expect(creates, 0);
    expect(
      find.text('Masukkan URL http:// atau https:// yang valid.'),
      findsOneWidget,
    );
    await tester.enterText(fields.at(3), 'https://example.com/project');
    await _tap(tester, find.text('Simpan'));
    expect(creates, 1);
    expect(find.text('Proyek berhasil disimpan'), findsOneWidget);
    await _tap(tester, find.text('OK'));

    await _openDrawer(tester);
    await _tap(tester, find.text('Logout'));
    await _openDrawer(tester);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Project card opens login and cancellation keeps Home', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app((_) async => throw StateError('Unexpected call')),
    );
    await _tap(tester, find.text('Tambah Proyek'));
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('Education creation from Home asks for login', (tester) async {
    await tester.pumpWidget(
      _app((_) async => throw StateError('Unexpected call')),
    );
    await _tap(tester, find.text('Tambah Edukasi'));
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(EducationFormPage), findsNothing);
  });

  const education = {
    'id': 7,
    'institution': 'Universitas Contoh',
    'level': 'undergraduate',
    'field_of_study': 'Ilmu Komputer',
    'start_year': 2025,
    'end_year': null,
  };

  testWidgets('Public education loads from Drawer, retries and opens detail', (
    tester,
  ) async {
    var requests = 0;
    await tester.pumpWidget(
      _app((request) async {
        expect(request.method, 'GET');
        expect(request.headers['authorization'], isNull);
        switch (request.url.path) {
          case '/api/v1/education/':
            if (++requests == 1) return http.Response('', 503);
            return http.Response(jsonEncode([education]), 200);
          case '/api/v1/education/7/':
            return http.Response.bytes(
              utf8.encode(
                jsonEncode({...education, 'description': 'Kelas 日本語'}),
              ),
              200,
            );
        }
        throw StateError('Unexpected request');
      }),
    );
    await _openDrawer(tester);
    await _tap(tester, find.text('View Education'));
    await _tap(tester, find.text('Retry'));
    await _tap(tester, find.text('Universitas Contoh'));
    expect(find.text('Detail Edukasi'), findsOneWidget);
    expect(find.text('Masih berlangsung'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Kelas 日本語'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Kelas 日本語'), findsOneWidget);
  });

  testWidgets('Education handles expired token and refreshes after save', (
    tester,
  ) async {
    var loginCount = 0;
    var saveCount = 0;
    var hasEntry = false;
    await tester.pumpWidget(
      _app((request) async {
        switch (request.url.path) {
          case '/api/v1/auth/token/':
            return http.Response(
              jsonEncode({'token': 'token-${++loginCount}'}),
              200,
            );
          case '/api/v1/education/':
            if (request.method == 'GET') {
              expect(request.headers['authorization'], isNull);
              return http.Response(
                jsonEncode(hasEntry ? [education] : []),
                200,
              );
            }
            saveCount++;
            expect(request.method, 'POST');
            expect(request.headers['authorization'], 'Token token-$saveCount');
            final payload = jsonDecode(request.body) as Map<String, dynamic>;
            expect(payload.containsKey('id'), isFalse);
            expect(payload['start_year'], 2025);
            expect(payload['end_year'], isNull);
            expect(payload['field_of_study'], 'Ilmu Komputer');
            if (saveCount == 1) return http.Response('', 401);
            hasEntry = true;
            return http.Response(jsonEncode(education), 201);
        }
        throw StateError('Unexpected request');
      }),
    );
    await _tap(tester, find.text('Lihat Edukasi'));
    expect(find.text('Belum ada data edukasi.'), findsOneWidget);
    await _tap(tester, find.text('Tambah Edukasi'));
    await _login(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Universitas Contoh');
    await tester.enterText(fields.at(1), 'Ilmu Komputer');
    await tester.enterText(fields.at(2), '2025');
    await tester.enterText(fields.at(3), '2024');
    await _tap(tester, find.widgetWithText(FilledButton, 'Simpan'));
    expect(
      find.text('Tahun selesai tidak boleh sebelum tahun mulai.'),
      findsOneWidget,
    );
    expect(saveCount, 0);

    await tester.enterText(fields.at(3), '');
    await _tap(tester, find.widgetWithText(FilledButton, 'Simpan'));
    await _login(tester);
    expect(saveCount, 1);
    await _tap(tester, find.widgetWithText(FilledButton, 'Simpan'));
    expect(find.text('Edukasi tersimpan'), findsOneWidget);
    await _tap(tester, find.text('OK'));
    expect(find.text('Universitas Contoh'), findsOneWidget);
    expect(saveCount, 2);
  });
}
