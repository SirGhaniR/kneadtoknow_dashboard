import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:kneadtoknow_admin/config/api_config.dart';
import 'package:kneadtoknow_admin/providers/auth_provider.dart';
import 'package:kneadtoknow_admin/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late DioAdapter adapter;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
    adapter = DioAdapter(dio: dio);
    ApiService.injectDioForTest(dio);
  });

  tearDown(() {
    ApiService.resetDioForTest();
  });

  group('AuthProvider', () {
    group('loadSession', () {
      test('isLoggedIn is false when no token stored', () async {
        final auth = AuthProvider();
        await auth.loadSession();

        expect(auth.isLoggedIn, isFalse);
        expect(auth.user, isNull);
      });

      test('isLoggedIn is true when a token is stored', () async {
        SharedPreferences.setMockInitialValues({
          ApiConfig.tokenKey: 'some-saved-token',
        });

        final auth = AuthProvider();
        await auth.loadSession();

        expect(auth.isLoggedIn, isTrue);
      });
    });

    group('login', () {
      test('stores token and user on success', () async {
        adapter.onPost(
          ApiConfig.login,
          (server) => server.reply(200, {
            'success': true,
            'data': {
              'token': 'abc123',
              'user': {
                'id': 1,
                'name': 'Admin',
                'email': 'admin@tastyfood.com',
              },
            },
          }),
          data: {
            'email': 'admin@tastyfood.com',
            'password': 'password',
          },
        );

        final auth = AuthProvider();
        final ok = await auth.login('admin@tastyfood.com', 'password');

        expect(ok, isTrue);
        expect(auth.isLoggedIn, isTrue);
        expect(auth.error, isNull);
        expect(auth.user?.name, 'Admin');
        expect(auth.user?.email, 'admin@tastyfood.com');

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(ApiConfig.tokenKey), 'abc123');
      });

      test('returns false and sets error on 401', () async {
        adapter.onPost(
          ApiConfig.login,
          (server) => server.reply(401, {
            'message': 'These credentials do not match our records.',
          }),
          data: {
            'email': 'admin@tastyfood.com',
            'password': 'wrong',
          },
        );

        final auth = AuthProvider();
        final ok = await auth.login('admin@tastyfood.com', 'wrong');

        expect(ok, isFalse);
        expect(auth.isLoggedIn, isFalse);
        expect(auth.error, isNotNull);
        expect(auth.error, contains('credentials'));

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(ApiConfig.tokenKey), isNull);
      });

      test('isLoading is true during login and false after', () async {
        adapter.onPost(
          ApiConfig.login,
          (server) => server.reply(200, {
            'success': true,
            'data': {
              'token': 'tok',
              'user': {'id': 1, 'name': 'A', 'email': 'a@b.c'},
            },
          }),
          data: {'email': 'a@b.c', 'password': 'pw'},
        );

        final auth = AuthProvider();
        expect(auth.isLoading, isFalse);

        final future = auth.login('a@b.c', 'pw');
        // isLoading flips true synchronously via notifyListeners.
        expect(auth.isLoading, isTrue);

        await future;
        expect(auth.isLoading, isFalse);
      });

      test('error is cleared on a subsequent successful attempt', () async {
        adapter.onPost(
          ApiConfig.login,
          (server) => server.reply(401, {'message': 'Nope'}),
          data: {'email': 'x@y.z', 'password': 'bad'},
        );
        adapter.onPost(
          ApiConfig.login,
          (server) => server.reply(200, {
            'success': true,
            'data': {
              'token': 'ok',
              'user': {'id': 1, 'name': 'X', 'email': 'x@y.z'},
            },
          }),
          data: {'email': 'x@y.z', 'password': 'good'},
        );

        final auth = AuthProvider();
        await auth.login('x@y.z', 'bad');
        expect(auth.error, isNotNull);

        await auth.login('x@y.z', 'good');
        expect(auth.error, isNull);
        expect(auth.isLoggedIn, isTrue);
      });
    });

    group('logout', () {
      test('clears token, user, and isLoggedIn', () async {
        SharedPreferences.setMockInitialValues({
          ApiConfig.tokenKey: 'abc123',
        });

        adapter.onPost(
          ApiConfig.logout,
          (server) => server.reply(200, {'success': true}),
        );

        final auth = AuthProvider();
        await auth.loadSession();
        expect(auth.isLoggedIn, isTrue);

        await auth.logout();

        expect(auth.isLoggedIn, isFalse);
        expect(auth.user, isNull);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(ApiConfig.tokenKey), isNull);
      });

      test('still clears local state if the server call fails', () async {
        SharedPreferences.setMockInitialValues({
          ApiConfig.tokenKey: 'abc123',
        });

        adapter.onPost(
          ApiConfig.logout,
          (server) => server.reply(500, {'message': 'Server error'}),
        );

        final auth = AuthProvider();
        await auth.loadSession();
        await auth.logout();

        expect(auth.isLoggedIn, isFalse);
        expect(auth.user, isNull);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(ApiConfig.tokenKey), isNull);
      });
    });

    group('expireSession', () {
      test('clears token and flips isLoggedIn without an API call', () async {
        SharedPreferences.setMockInitialValues({
          ApiConfig.tokenKey: 'abc123',
        });

        final auth = AuthProvider();
        await auth.loadSession();
        expect(auth.isLoggedIn, isTrue);

        await auth.expireSession();

        expect(auth.isLoggedIn, isFalse);
        expect(auth.user, isNull);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString(ApiConfig.tokenKey), isNull);
      });
    });
  });
}
