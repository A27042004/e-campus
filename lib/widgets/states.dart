import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'animations.dart';
import 'custom_button.dart';

/// Skeleton list shown while data loads – never a blank screen.
class LoadingWidget extends StatelessWidget {
  final int count;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  const LoadingWidget({
    super.key,
    this.count = 4,
    this.itemHeight = 96,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Shimmer(
      child: ListView.separated(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, __) => Container(
          height: itemHeight,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              const SkeletonBox(width: 56, height: 56, radius: 16),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(height: 14),
                    SizedBox(height: 10),
                    SkeletonBox(height: 12, width: 160),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title, message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(color: p.primary.withOpacity(0.08), shape: BoxShape.circle),
                  ),
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(color: p.primary.withOpacity(0.14), shape: BoxShape.circle),
                  ),
                  Icon(icon, size: 40, color: p.primary),
                ],
              ),
              const SizedBox(height: 20),
              Text(title, style: t.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(message, style: t.bodyMedium?.copyWith(color: p.subtext), textAlign: TextAlign.center),
              if (actionLabel != null) ...[
                const SizedBox(height: 20),
                CustomButton(label: actionLabel!, onPressed: onAction, expanded: false, small: true),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Friendly error – never shows raw exceptions.
class ErrorStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  const ErrorStateWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) => EmptyStateWidget(
        icon: Icons.cloud_off_rounded,
        title: 'Something went wrong',
        message: 'Unable to load this information. Please check your connection and try again.',
        actionLabel: onRetry == null ? null : 'Try again',
        onAction: onRetry,
      );
}

/// FutureBuilder wrapper that handles loading / error / empty consistently.
class AsyncBody<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final bool Function(T)? isEmpty;
  final Widget? empty;
  final Widget? loading;
  final VoidCallback? onRetry;

  const AsyncBody({
    super.key,
    required this.future,
    required this.builder,
    this.isEmpty,
    this.empty,
    this.loading,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snap) {
        Widget child;
        if (snap.connectionState != ConnectionState.done) {
          child = KeyedSubtree(key: const ValueKey('l'), child: loading ?? const LoadingWidget());
        } else if (snap.hasError) {
          child = KeyedSubtree(key: const ValueKey('e'), child: ErrorStateWidget(onRetry: onRetry));
        } else if (isEmpty?.call(snap.data as T) == true) {
          child = KeyedSubtree(key: const ValueKey('m'), child: empty ?? const SizedBox.shrink());
        } else {
          child = KeyedSubtree(key: const ValueKey('d'), child: builder(context, snap.data as T));
        }
        return AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: child);
      },
    );
  }
}

/// Non-scrolling skeleton, safe inside a Column / ListView.
class SkeletonList extends StatelessWidget {
  final int count;
  final double height;
  const SkeletonList({super.key, this.count = 3, this.height = 72});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Shimmer(
      child: Column(
        children: List.generate(
          count,
          (_) => Container(
            height: height,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [SkeletonBox(height: 13), SizedBox(height: 10), SkeletonBox(height: 10, width: 140)],
            ),
          ),
        ),
      ),
    );
  }
}
