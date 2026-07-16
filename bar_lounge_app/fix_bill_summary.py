import textwrap

file_path = 'lib/features/orders/presentation/bill_summary_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add import
if "import '../../../core/utils/error_handler.dart';" not in content:
    content = content.replace("import '../../../core/utils/money.dart';", 
                              "import '../../../core/utils/money.dart';\\nimport '../../../core/utils/error_handler.dart';")

# 1. Call waiter
content = content.replace("Could not reach the waiter: $e", "Could not reach the waiter: ${ErrorHandler.getMessage(e)}")
# 2. Add more quantity
content = content.replace("Cannot add more: $e", "Cannot add more: ${ErrorHandler.getMessage(e)}")
# 3. Confirm order
content = content.replace("'Error: $error'", "ErrorHandler.getMessage(error)")
# 4. Request payment
# Since it is multiline, we replace the dialog block
old_payment_error = """        _showDialog(
          'Payment Failed',
          'Error: $error',
        );"""
new_payment_error = """        _showDialog(
          'Payment Failed',
          ErrorHandler.getMessage(error),
        );"""
content = content.replace(old_payment_error, new_payment_error)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated bill_summary_screen.dart")
