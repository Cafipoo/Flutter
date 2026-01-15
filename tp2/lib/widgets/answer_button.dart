import 'package:flutter/material.dart';
import '../models.dart';

class AnswerButton extends StatelessWidget {
  final Answer answer;
  final int index;
  final bool isSelected;
  final bool isAnswerValidated;
  final Color buttonColor;
  final VoidCallback? onPressed;

  const AnswerButton({
    super.key,
    required this.answer,
    required this.index,
    required this.isSelected,
    required this.isAnswerValidated,
    required this.buttonColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: buttonColor,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: isSelected
                ? const BorderSide(
                    color: Colors.white,
                    width: 3,
                  )
                : BorderSide.none,
          ),
          elevation: isSelected ? 8 : 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected && !isAnswerValidated)
              const Icon(
                Icons.radio_button_checked,
                size: 24,
              ),
            if (isSelected && !isAnswerValidated)
              const SizedBox(width: 10),
            Text(
              answer.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isSelected && isAnswerValidated)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(
                  answer.isCorrect ? Icons.check_circle : Icons.cancel,
                  size: 28,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
