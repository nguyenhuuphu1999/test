import 'package:flutter/material.dart';
import '../core/error/result.dart';

/// A reusable widget for displaying API errors with retry functionality
class ErrorDisplayWidget extends StatelessWidget {
  final Result result;
  final VoidCallback? onRetry;
  final String? customMessage;
  final Widget? customIcon;
  final bool showRetryButton;

  const ErrorDisplayWidget({
    super.key,
    required this.result,
    this.onRetry,
    this.customMessage,
    this.customIcon,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return result.when(
      ok: (data) => const SizedBox.shrink(),
      err: (failure) => _buildErrorContent(context, failure),
    );
  }

  Widget _buildErrorContent(BuildContext context, failure) {
    final message = customMessage ?? failure.message ?? 'An error occurred';
    final statusCode = failure.statusCode;
    
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              customIcon ?? Icon(
                Icons.error_outline,
                color: Colors.red.shade600,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusCode != null 
                        ? 'Error $statusCode' 
                        : 'Error',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A compact error display for use in lists or cards
class CompactErrorDisplay extends StatelessWidget {
  final Result result;
  final VoidCallback? onRetry;

  const CompactErrorDisplay({
    super.key,
    required this.result,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return result.when(
      ok: (data) => const SizedBox.shrink(),
      err: (failure) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red.shade600,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                failure.message ?? 'Failed to load',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onRetry != null)
              GestureDetector(
                onTap: onRetry,
                child: Icon(
                  Icons.refresh,
                  color: Colors.red.shade600,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Error display for empty states
class EmptyStateDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const EmptyStateDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
