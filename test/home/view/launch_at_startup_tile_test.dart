import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twenty/home/view/home_page.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/startup/startup_registration.dart';
import 'package:twenty/startup/startup_registry.dart';

void main() {
  testWidgets('failed enable leaves the toggle off without an uncaught error', (
    tester,
  ) async {
    final registry = FailingStartupRegistry();
    final registration = StartupRegistration(registry: registry)
      ..setup(appName: 'Twenty', appPath: r'C:\Twenty\twenty.exe');

    await tester.pumpWidget(
      FluentApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScaffoldPage(
          content: LaunchAtStartupTile(registration: registration),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<ToggleSwitch>(find.byType(ToggleSwitch)).checked,
      false,
    );

    await tester.tap(find.byType(ToggleSwitch));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
    expect(
      tester.widget<ToggleSwitch>(find.byType(ToggleSwitch)).checked,
      false,
    );
    expect(
      find.text('Could not update launch at startup. Please try again.'),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}

class FailingStartupRegistry implements StartupRegistry {
  @override
  void deleteValue(String name) {}

  @override
  String? readValue(String name) => null;

  @override
  void writeValue(String name, String value) {
    throw StateError('Registry write failed');
  }
}
