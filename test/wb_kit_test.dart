import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openstrap_edge/ui2/app_shell.dart';
import 'package:openstrap_edge/ui2/theme.dart';
import 'package:openstrap_edge/ui2/wb/kit.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: buildTheme(Brightness.dark),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('WbVitalHero renders recovery and vital index', (t) async {
    await t.pumpWidget(
      wrap(
        WbVitalHero(
          recoveryPct: WbDemo.recovery,
          vitalAge: WbDemo.vitalAge,
          chronologicalAge: WbDemo.chronologicalAge,
        ),
      ),
    );
    expect(find.textContaining('vital index'), findsOneWidget);
    expect(find.text('67% charge'), findsOneWidget);
    expect(find.text('31'), findsOneWidget);
  });

  testWidgets('WbSleepPerformance announces percent', (t) async {
    await t.pumpWidget(
      wrap(
        const WbSleepPerformance(
          performance: 0.82,
          headline: '7h 24m asleep',
          detail: 'Need 8.1 h',
        ),
      ),
    );
    expect(find.text('82'), findsOneWidget);
    expect(find.textContaining('SLEEP PERFORMANCE'), findsOneWidget);
  });

  testWidgets('WbHistoryBars draws without overflow', (t) async {
    await t.pumpWidget(
      wrap(
        WbHistoryBars(
          title: 'Performance history',
          values: WbDemo.performanceHistory,
          accent: C.wbSleep,
          labels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
        ),
      ),
    );
    expect(find.text('Performance history'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  test('illustrativeVitalAge moves with recovery', () {
    final young = WbVitalHero.illustrativeVitalAge(
      recoveryPct: 90,
      chronologicalAge: 34,
    );
    final older = WbVitalHero.illustrativeVitalAge(
      recoveryPct: 20,
      chronologicalAge: 34,
    );
    expect(young, lessThan(34));
    expect(older, greaterThan(34));
  });

  test('shell labels are WhoopsBand originals', () {
    expect(ShellDomain.today.label, 'Overview');
    expect(ShellDomain.sleep.label, 'Rest');
    expect(ShellDomain.activity.label, 'Move');
    expect(ShellDomain.health.label, 'Body');
  });
}
