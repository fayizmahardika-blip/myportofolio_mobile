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

  testWidgets('Education remains available without a project token', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app((_) async => throw StateError('Unexpected call')),
    );
    await _tap(tester, find.text('Tambah Edukasi'));
    expect(find.byType(EducationFormPage), findsOneWidget);
  });
}
