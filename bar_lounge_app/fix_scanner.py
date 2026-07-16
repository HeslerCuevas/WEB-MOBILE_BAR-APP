import textwrap

file_path = 'lib/features/scanner/presentation/scanner_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add import
if "import '../../../core/utils/error_handler.dart';" not in content:
    content = content.replace("import '../../../core/theme/app_colors.dart';", 
                              "import '../../../core/theme/app_colors.dart';\\nimport '../../../core/utils/error_handler.dart';")

# 1. Scanner catch block
content = content.replace("setState(() => _error = 'Failed to link table. Try again.');",
                          "setState(() => _error = ErrorHandler.getMessage(e, fallback: 'Failed to link table. Try again.'));")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated scanner_screen.dart")
