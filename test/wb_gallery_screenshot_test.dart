import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openstrap_edge/ui2/theme.dart';
import 'package:openstrap_edge/ui2/wb/kit.dart';

/// Captures WhoopsBand kit composites for the PR (not golden-compared).
Future<void> _save(WidgetTester t, String name) async {
  final boundary = t.renderObject<RenderRepaintBoundary>(
    find.byType(RepaintBoundary).first,
  );
  final image = await boundary.toImage(pixelRatio: 2);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final dir = Directory('screenshots/whoopsband');
  await dir.create(recursive: true);
  final file = File('${dir.path}/$name.png');
  await file.writeAsBytes(bytes!.buffer.asUint8List());
}

void main() {
  // Skipped: toImage/RepaintBoundary capture hangs under flutter_test on this host.
  testWidgets(
    'capture WhoopsBand overview composite',
    (t) async {
      await t.binding.setSurfaceSize(const Size(390, 844));
      await t.pumpWidget(
        MaterialApp(
          theme: buildTheme(Brightness.dark),
          home: Scaffold(
            backgroundColor: P(true).bg,
            body: RepaintBoundary(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(S.x4),
                child: Column(
                  children: [
                    Text(
                      kWhoopsBandName,
                      style: F.t1.copyWith(color: P(true).ink),
                    ),
                    const SizedBox(height: S.x4),
                    WbCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: WbRingStat(
                              label: 'Sleep',
                              value: '7h 24m',
                              sub: 'of 8h 06m',
                              frac: 0.91,
                              accent: C.wbSleep,
                              icon: Icons.nightlight_round,
                            ),
                          ),
                          Expanded(
                            child: WbRingStat(
                              label: 'Recovery',
                              value: '67',
                              sub: 'Steady',
                              frac: 0.67,
                              accent: C.wbRecovery,
                              icon: Icons.battery_charging_full,
                            ),
                          ),
                          Expanded(
                            child: WbRingStat(
                              label: 'Strain',
                              value: '9.2',
                              sub: 'of 21',
                              frac: 9.2 / 21,
                              accent: C.wbStrain,
                              icon: Icons.bolt,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: S.x3),
                    const WbInsightTile(
                      eyebrow: kWhoopsBandName,
                      title: 'Recovery is steady',
                      body: 'HRV and resting heart rate lead today.',
                      icon: Icons.auto_awesome,
                      accent: C.wbRecovery,
                    ),
                    const SizedBox(height: S.x3),
                    WbVitalHero(
                      recoveryPct: WbDemo.recovery,
                      vitalAge: WbDemo.vitalAge,
                      chronologicalAge: WbDemo.chronologicalAge,
                    ),
                    const SizedBox(height: S.x3),
                    const WbSleepPerformance(
                      performance: 0.86,
                      headline: '7h 24m asleep',
                      detail: 'Need 8.1 h',
                    ),
                    const SizedBox(height: S.x3),
                    WbHistoryBars(
                      title: 'Performance history',
                      values: WbDemo.performanceHistory,
                      accent: C.wbSleep,
                      labels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await t.pump(); // avoid settle — rings use finite animate() already
      await t.pump(const Duration(milliseconds: 50));
      await _save(t, 'overview-body-sleep');
    },
    // Reason: toImage/RepaintBoundary hangs under flutter_test on this host;
    // kit coverage remains in wb_kit_test.dart.
    skip: true,
  );
}
