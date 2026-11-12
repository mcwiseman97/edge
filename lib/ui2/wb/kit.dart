// WhoopsBand visual kit — original identity layered on the ui2 token system.
//
// Direction: near-black shell, elevated rounded cards, compact type, restrained
// sleep/recovery/strain/stress accents. Not a clone of any vendor app: no
// proprietary names, logos, or trademarked copy. Components consume only C / P /
// R / F / S / Motion from theme.dart so the token guard stays green.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../charts.dart';
import '../grammar.dart';
import '../theme.dart';

/// Product wordmark for chrome that needs a brand signal outside the nav.
const kWhoopsBandName = 'WhoopsBand';

/// Isolated demo values for gallery / empty-state previews. Never written into
/// LocalDb or treated as measured band data.
class WbDemo {
  const WbDemo._();

  static const sleepHours = 7.4;
  static const sleepNeedHours = 8.1;
  static const recovery = 67.0;
  static const strain = 9.2;
  static const stress = 28.0;
  static const restingHr = 54.0;
  static const vitalAge = 31.0;
  static const chronologicalAge = 34.0;

  static const sleepHistoryHours = <double>[6.2, 7.1, 5.8, 7.9, 8.0, 6.5, 7.4];
  static const performanceHistory = <double>[
    0.62,
    0.71,
    0.55,
    0.78,
    0.81,
    0.66,
    0.74,
  ];
}

/// Elevated card with the WhoopsBand radius language (xl, soft lift).
class WbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets pad;
  final VoidCallback? onTap;
  final Color? color;
  final int elevation;
  final String? semanticLabel;

  const WbCard({
    super.key,
    required this.child,
    this.pad = const EdgeInsets.all(S.x4),
    this.onTap,
    this.color,
    this.elevation = 2,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final p = P.of(context);
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Container(
        width: double.infinity,
        padding: pad,
        decoration: BoxDecoration(
          color: color ?? p.card,
          borderRadius: R.rXl,
          boxShadow: p.el(elevation),
          border: Border.all(color: p.line.withValues(alpha: 0.55)),
        ),
        child: child,
      ),
    );
  }
}

/// One circular summary used on the Overview dashboard.
class WbRingStat extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final double? frac;
  final Color accent;
  final IconData icon;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const WbRingStat({
    super.key,
    required this.label,
    required this.value,
    required this.sub,
    required this.frac,
    required this.accent,
    required this.icon,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final p = P.of(context);
    final ink = p.on(accent);
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel ?? '$label. $value. $sub',
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 104),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: Ring(
                      (frac ?? 0).clamp(0.0, 1.0),
                      ink,
                      p.track,
                      stroke: 8,
                      t: animate(context, 1),
                      solid: frac != null,
                    ),
                  ),
                  Icon(icon, size: 22, color: ink),
                ],
              ),
            ),
          ),
          const SizedBox(height: S.x3),
          Text(
            label.toUpperCase(),
            style: F.over.copyWith(color: p.ink3, letterSpacing: 0.8),
          ),
          const SizedBox(height: S.x1),
          Text(
            value,
            style: F.n24.copyWith(color: p.ink),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: S.x1),
          Text(
            sub,
            style: F.cap.copyWith(color: p.ink2),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Compact insight / outlook tile for Overview.
class WbInsightTile extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;
  final String? eyebrow;

  const WbInsightTile({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
    required this.accent,
    this.onTap,
    this.eyebrow,
  });

  @override
  Widget build(BuildContext context) {
    final p = P.of(context);
    return WbCard(
      onTap: onTap,
      semanticLabel: '$title. $body',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: p.wash(accent),
              borderRadius: R.rMd,
            ),
            child: Icon(icon, color: p.on(accent), size: 20),
          ),
          const SizedBox(width: S.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null) ...[
                  Text(eyebrow!, style: F.over.copyWith(color: p.on(accent))),
                  const SizedBox(height: S.x1),
                ],
                Text(title, style: F.head.copyWith(color: p.ink)),
                const SizedBox(height: S.x1),
                Text(body, style: F.cap.copyWith(color: p.ink2, height: 1.35)),
              ],
            ),
          ),
          if (onTap != null)
            Icon(LucideIcons.chevronRight, size: 16, color: p.ink3),
        ],
      ),
    );
  }
}

/// Large Body-tab hero: recovery charge + illustrative vital-age index.
///
/// [vitalAge] is a presentation index derived from readiness vs chronological
/// age when both are available. It is not a medical age estimate. Pass demo
/// values only through [WbDemo], never from fabricated band packets.
class WbVitalHero extends StatelessWidget {
  final double? recoveryPct;
  final double? vitalAge;
  final double? chronologicalAge;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const WbVitalHero({
    super.key,
    required this.recoveryPct,
    required this.vitalAge,
    required this.chronologicalAge,
    this.title = 'Vital charge',
    this.subtitle = 'Recovery mapped to an illustrative vitality index',
    this.onTap,
  });

  static double? illustrativeVitalAge({
    required double? recoveryPct,
    required double? chronologicalAge,
  }) {
    if (recoveryPct == null || chronologicalAge == null) return null;
    // Soft offset: high recovery reads younger, low recovery older — capped.
    final delta = ((50 - recoveryPct) / 50) * 6;
    return (chronologicalAge + delta).clamp(18.0, 90.0);
  }

  @override
  Widget build(BuildContext context) {
    final p = P.of(context);
    final frac = recoveryPct == null
        ? null
        : (recoveryPct! / 100).clamp(0.0, 1.0);
    final ink = p.on(C.wbVital);
    final ageText = vitalAge == null ? '—' : vitalAge!.toStringAsFixed(0);
    final recoveryText = recoveryPct == null ? '—' : '${recoveryPct!.round()}';

    return WbCard(
      onTap: onTap,
      semanticLabel: '$title $recoveryText percent. Vital index $ageText',
      child: Column(
        children: [
          Text(
            title.toUpperCase(),
            style: F.over.copyWith(color: p.ink3, letterSpacing: 1.0),
          ),
          const SizedBox(height: S.x4),
          SizedBox(
            width: 196,
            height: 196,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(196, 196),
                  painter: Ring(
                    frac ?? 0.18,
                    ink,
                    p.track,
                    stroke: 12,
                    t: animate(context, 1),
                    solid: frac != null,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(ageText, style: F.n48.copyWith(color: p.ink)),
                    const SizedBox(height: S.x1),
                    Text('vital index', style: F.cap.copyWith(color: p.ink2)),
                    const SizedBox(height: S.x2),
                    Text(
                      '$recoveryText% charge',
                      style: F.head.copyWith(color: ink),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: S.x4),
          Text(
            chronologicalAge == null
                ? subtitle
                : 'Chronological ${chronologicalAge!.toStringAsFixed(0)} · $subtitle',
            style: F.cap.copyWith(color: p.ink3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Sleep performance ring with supporting copy.
class WbSleepPerformance extends StatelessWidget {
  final double? performance; // 0..1
  final String headline;
  final String detail;
  final VoidCallback? onTap;

  const WbSleepPerformance({
    super.key,
    required this.performance,
    required this.headline,
    required this.detail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = P.of(context);
    final ink = p.on(C.wbSleep);
    final pct = performance == null ? '—' : '${(performance! * 100).round()}';
    return WbCard(
      onTap: onTap,
      semanticLabel: 'Sleep performance $pct percent. $headline',
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(92, 92),
                  painter: Ring(
                    (performance ?? 0.12).clamp(0.0, 1.0),
                    ink,
                    p.track,
                    stroke: 9,
                    t: animate(context, 1),
                    solid: performance != null,
                  ),
                ),
                Text(pct, style: F.n24.copyWith(color: p.ink)),
              ],
            ),
          ),
          const SizedBox(width: S.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SLEEP PERFORMANCE',
                  style: F.over.copyWith(color: p.on(C.wbSleep)),
                ),
                const SizedBox(height: S.x2),
                Text(headline, style: F.head.copyWith(color: p.ink)),
                const SizedBox(height: S.x1),
                Text(detail, style: F.cap.copyWith(color: p.ink2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical bar history (sleep performance or hours).
class WbHistoryBars extends StatelessWidget {
  final List<double> values; // 0..1 preferred, or raw hours with [maxValue]
  final Color accent;
  final String title;
  final double? maxValue;
  final List<String>? labels;

  const WbHistoryBars({
    super.key,
    required this.values,
    required this.accent,
    required this.title,
    this.maxValue,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final p = P.of(context);
    final ink = p.on(accent);
    final maxV =
        maxValue ??
        values.fold<double>(0, (a, b) => math.max(a, b)).clamp(0.01, 999);
    return WbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: F.head.copyWith(color: p.ink)),
          const SizedBox(height: S.x4),
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < values.length; i++) ...[
                  if (i > 0) const SizedBox(width: S.x2),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 84 * (values[i] / maxV).clamp(0.06, 1.0),
                          decoration: BoxDecoration(
                            color: ink.withValues(alpha: 0.85),
                            borderRadius: R.rSm,
                          ),
                        ),
                        if (labels != null && i < labels!.length) ...[
                          const SizedBox(height: S.x2),
                          Text(
                            labels![i],
                            style: F.over.copyWith(color: p.ink3),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Hours slept vs hours needed — dual bar comparison.
class WbHoursNeededChart extends StatelessWidget {
  final double? sleptHours;
  final double? needHours;
  final String title;

  const WbHoursNeededChart({
    super.key,
    required this.sleptHours,
    required this.needHours,
    this.title = 'Hours vs need',
  });

  @override
  Widget build(BuildContext context) {
    final p = P.of(context);
    final slept = sleptHours ?? 0;
    final need = needHours ?? 0;
    final maxV = math.max(slept, need).clamp(1.0, 24.0);
    Widget bar(String label, double hours, Color accent) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: F.cap.copyWith(color: p.ink2)),
              Text(
                '${hours.toStringAsFixed(1)} h',
                style: F.head.copyWith(color: p.ink),
              ),
            ],
          ),
          const SizedBox(height: S.x2),
          ClipRRect(
            borderRadius: R.rPill,
            child: LinearProgressIndicator(
              value: (hours / maxV).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: p.track,
              color: p.on(accent),
            ),
          ),
        ],
      );
    }

    return WbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: F.head.copyWith(color: p.ink)),
          const SizedBox(height: S.x4),
          bar('Asleep', slept, C.wbSleep),
          const SizedBox(height: S.x4),
          bar('Need', need == 0 ? slept : need, C.wbRecovery),
        ],
      ),
    );
  }
}

/// Compact stress / health mini metrics for Overview.
class WbMiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;

  const WbMiniMetric({
    super.key,
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = P.of(context);
    return WbCard(
      pad: const EdgeInsets.all(S.x3),
      elevation: 1,
      onTap: onTap,
      semanticLabel: '$label $value $sub',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: p.on(accent)),
          const SizedBox(height: S.x3),
          Text(value, style: F.n24.copyWith(color: p.ink)),
          const SizedBox(height: S.x1),
          Text(label, style: F.cap.copyWith(color: p.ink2)),
          Text(sub, style: F.over.copyWith(color: p.ink3)),
        ],
      ),
    );
  }
}
