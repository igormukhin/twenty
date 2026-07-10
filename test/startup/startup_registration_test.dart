import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:twenty/startup/startup_registration.dart';
import 'package:twenty/startup/startup_registry.dart';

void main() {
  group('unpackaged registration', () {
    late FakeStartupRegistry registry;
    late StartupRegistration registration;

    setUp(() {
      registry = FakeStartupRegistry();
      registration = StartupRegistration(registry: registry)
        ..setup(
          appName: 'Twenty',
          appPath: r'C:\Program Files\Twenty\twenty.exe',
        );
    });

    test('is disabled when the value is missing', () async {
      expect(await registration.isEnabled(), isFalse);
    });

    test('requires an exact executable value match', () async {
      registry.values['Twenty'] =
          r'"C:\Program Files\Twenty\twenty.exe" --unexpected';

      expect(await registration.isEnabled(), isFalse);
    });

    test('matches Windows paths without case sensitivity', () async {
      registry.values['Twenty'] = r'"c:\program files\twenty\TWENTY.EXE"';

      expect(await registration.isEnabled(), isTrue);
    });

    test('enable writes the quoted executable path', () async {
      await registration.enable();

      expect(
        registry.values['Twenty'],
        r'"C:\Program Files\Twenty\twenty.exe"',
      );
    });

    test('disable removes the startup value', () async {
      registry.values['Twenty'] = 'old value';

      await registration.disable();

      expect(registry.values, isNot(contains('Twenty')));
    });
  });

  test(
    'unpackaged registration adds and removes the executable from startup',
    () async {
      const appName = 'TwentyStartupRegistrationTest';
      final registration = StartupRegistration()
        ..setup(
          appName: appName,
          appPath: Platform.resolvedExecutable,
        );

      await registration.disable();

      try {
        await registration.enable();
        expect(await registration.isEnabled(), isTrue);
      } finally {
        await registration.disable();
      }

      expect(await registration.isEnabled(), isFalse);
    },
    skip: !Platform.isWindows,
  );
}

class FakeStartupRegistry implements StartupRegistry {
  final values = <String, String>{};

  @override
  void deleteValue(String name) => values.remove(name);

  @override
  String? readValue(String name) => values[name];

  @override
  void writeValue(String name, String value) {
    values[name] = value;
  }
}
