import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int timeRemaining;
  final Animation<double>? progressAnimation;

  const TimerWidget({
    super.key,
    required this.timeRemaining,
    this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer,
                color: timeRemaining <= 3
                    ? Colors.red.shade600
                    : Colors.deepPurple,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                '$timeRemaining s',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: timeRemaining <= 3
                      ? Colors.red.shade600
                      : Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barre de progression fluide avec animation
          AnimatedBuilder(
            animation: progressAnimation ?? const AlwaysStoppedAnimation(1.0),
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressAnimation?.value ?? 1.0,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    timeRemaining <= 3
                        ? Colors.red.shade600
                        : Colors.deepPurple,
                  ),
                  minHeight: 10,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
