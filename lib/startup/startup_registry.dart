import 'package:win32_registry/win32_registry.dart';

abstract interface class StartupRegistry {
  String? readValue(String name);

  void writeValue(String name, String value);

  void deleteValue(String name);
}

class WindowsStartupRegistry implements StartupRegistry {
  static const _runKeyPath = r'Software\Microsoft\Windows\CurrentVersion\Run';

  @override
  String? readValue(String name) {
    final key = Registry.openPath(
      RegistryHive.currentUser,
      path: _runKeyPath,
    );
    try {
      return key.getValueAsString(name);
    } finally {
      key.close();
    }
  }

  @override
  void writeValue(String name, String value) {
    final currentUser = Registry.currentUser;
    try {
      final key = currentUser.createKey(_runKeyPath);
      try {
        key.createValue(
          RegistryValue(name, RegistryValueType.string, value),
        );
      } finally {
        key.close();
      }
    } finally {
      currentUser.close();
    }
  }

  @override
  void deleteValue(String name) {
    final key = Registry.openPath(
      RegistryHive.currentUser,
      path: _runKeyPath,
      desiredAccessRights: AccessRights.allAccess,
    );
    try {
      if (key.getValue(name) != null) {
        key.deleteValue(name);
      }
    } finally {
      key.close();
    }
  }
}
