import 'dart:io';

import 'package:launch_at_startup/launch_at_startup.dart';

final startupRegistration = StartupRegistration();

class StartupRegistration {
  static const _runKey = r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run';

  String? _appName;
  String? _appPath;
  String? _packageName;

  void setup({
    required String appName,
    required String appPath,
    String? packageName,
  }) {
    _appName = appName;
    _appPath = appPath;
    _packageName = packageName;

    if (_usesPackageRegistration) {
      launchAtStartup.setup(
        appName: appName,
        appPath: appPath,
        packageName: packageName,
      );
    }
  }

  Future<bool> isEnabled() async {
    if (_usesPackageRegistration) {
      return launchAtStartup.isEnabled();
    }

    final appName = _requireAppName();
    final result = await Process.run(
      'reg',
      ['query', _runKey, '/v', appName],
    );

    if (result.exitCode != 0) {
      return false;
    }

    final stdout = result.stdout.toString().toLowerCase();
    return stdout.contains(_startupValue.toLowerCase());
  }

  Future<void> enable() async {
    if (_usesPackageRegistration) {
      await launchAtStartup.enable();
      return;
    }

    final appName = _requireAppName();
    final result = await Process.run(
      'reg',
      [
        'add',
        _runKey,
        '/v',
        appName,
        '/t',
        'REG_SZ',
        '/d',
        _startupValue,
        '/f',
      ],
    );

    if (result.exitCode != 0) {
      throw ProcessException(
        'reg',
        ['add', _runKey],
        result.stderr.toString(),
        result.exitCode,
      );
    }
  }

  Future<void> disable() async {
    if (_usesPackageRegistration) {
      await launchAtStartup.disable();
      return;
    }

    final appName = _requireAppName();
    final result = await Process.run(
      'reg',
      ['delete', _runKey, '/v', appName, '/f'],
    );

    if (result.exitCode != 0) return;
  }

  bool get _usesPackageRegistration => _packageName != null;

  String get _startupValue => '"${_requireAppPath()}"';

  String _requireAppName() {
    final appName = _appName;
    if (appName == null) {
      throw StateError('StartupRegistration.setup must be called first.');
    }
    return appName;
  }

  String _requireAppPath() {
    final appPath = _appPath;
    if (appPath == null) {
      throw StateError('StartupRegistration.setup must be called first.');
    }
    return appPath;
  }
}
