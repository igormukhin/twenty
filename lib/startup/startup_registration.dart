import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:twenty/startup/startup_registry.dart';

final startupRegistration = StartupRegistration();

class StartupRegistration {
  StartupRegistration({StartupRegistry? registry})
      : _registry = registry ?? WindowsStartupRegistry();

  final StartupRegistry _registry;

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
    final registeredValue = _registry.readValue(appName);
    return registeredValue?.toLowerCase() == _startupValue.toLowerCase();
  }

  Future<void> enable() async {
    if (_usesPackageRegistration) {
      await launchAtStartup.enable();
      return;
    }

    final appName = _requireAppName();
    _registry.writeValue(appName, _startupValue);
  }

  Future<void> disable() async {
    if (_usesPackageRegistration) {
      await launchAtStartup.disable();
      return;
    }

    final appName = _requireAppName();
    _registry.deleteValue(appName);
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
