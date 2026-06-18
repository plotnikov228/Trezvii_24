
import 'package:flutter/services.dart';

class CardTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Удаляем все пробелы из нового значения
    String sanitizedText = newValue.text.replaceAll(' ', '');

    StringBuffer newText = StringBuffer();

    int index = 0;
    for (int i = 0; i < sanitizedText.length; i++) {
      newText.write(sanitizedText[i]);
      index++;

      // Добавляем пробелы после 5, 10 и 15 символов
      if (index == 4 || index == 8 || index == 12) {
        newText.write(' ');
      }
    }

    if(newValue.text.length < oldValue.text.length && newValue.text[newValue.text.length] == ' ') {
      newText.clear();
      final text = sanitizedText.substring(0, sanitizedText.length -2);
      int index = 0;
      for (int i = 0; i < text.length; i++) {
        newText.write(text[i]);
        index++;

        // Добавляем пробелы после 5, 10 и 15 символов
        if (index == 4 || index == 8 || index == 12) {
          newText.write(' ');
        }
      }

    }

    return newValue.copyWith(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}