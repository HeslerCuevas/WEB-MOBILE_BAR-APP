/// Currency configuration for the app.
/// Change [kMoneda] to update the prefix everywhere prices are displayed.
const String kMoneda = 'DOP';

/// Format a numeric value as a money string: e.g. "DOP$1,250.00"
String fmtMoney(double amount, {int decimals = 0}) {
  // Format with thousands separator
  final parts = amount.toStringAsFixed(decimals).split('.');
  final intPart = parts[0];
  final decPart = parts.length > 1 ? parts[1] : '';

  // Add thousands separator
  final buffer = StringBuffer();
  int count = 0;
  for (int i = intPart.length - 1; i >= 0; i--) {
    if (count > 0 && count % 3 == 0 && intPart[i] != '-') {
      buffer.write(',');
    }
    buffer.write(intPart[i]);
    count++;
  }

  final formattedInt = buffer.toString().split('').reversed.join();
  final result = decimals > 0 ? '$formattedInt.$decPart' : formattedInt;
  return '$kMoneda\$$result';
}

/// Compact label form: "DOP$50" (no comma for small numbers)
String fmtMoneyCompact(double amount) => fmtMoney(amount, decimals: 0);
