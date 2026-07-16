import textwrap

file_path = 'lib/shared/widgets/cancellation_banner.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add import
if "import '../../core/utils/error_handler.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", 
                              "import 'package:flutter/material.dart';\\nimport '../../core/utils/error_handler.dart';")

content = content.replace("content: Text('Could not cancel order: $e'),",
                          "content: Text(ErrorHandler.getMessage(e, fallback: 'Could not cancel order.')),")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated cancellation_banner.dart")
