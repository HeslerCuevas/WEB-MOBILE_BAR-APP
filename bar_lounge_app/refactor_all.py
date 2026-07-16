import textwrap

files = [
    'lib/features/auth/presentation/signup_screen.dart',
    'lib/features/account/presentation/account_profile_screen.dart',
    'lib/features/auth/presentation/token_action_screen.dart',
    'lib/features/auth/presentation/welcome_screen.dart',
    'lib/features/menu/presentation/menu_screen.dart',
    'lib/features/auth/presentation/login_screen.dart'
]

def add_import(content):
    if "import '../../../core/utils/error_handler.dart';" not in content and "import '../../core/utils/error_handler.dart';" not in content:
        # replace the first import with itself + our error handler import
        content = content.replace("import 'package:flutter/material.dart';", 
                                  "import 'package:flutter/material.dart';\\nimport '../../../core/utils/error_handler.dart';")
        content = content.replace("import 'package:flutter/material.dart';\\nimport '../../../core/utils/error_handler.dart';", 
                                  "import 'package:flutter/material.dart';\\nimport '../../../core/utils/error_handler.dart';")
    return content

for f in files:
    try:
        with open(f, 'r', encoding='utf-8') as file:
            c = file.read()
        
        c = add_import(c)
        
        if 'signup_screen.dart' in f:
            c = c.replace("setState(() => _error = detail);", "setState(() => _error = ErrorHandler.getMessage(e));")
            c = c.replace("} catch (_) {\\n      setState(() => _error = 'Could not create account. Please try again.');", 
                          "} catch (e) {\\n      setState(() => _error = ErrorHandler.getMessage(e, fallback: 'Could not create account. Please try again.'));")
        
        if 'account_profile_screen.dart' in f:
            c = c.replace("setState(() => _saveError = detail ?? 'Could not save changes. Please try again.');", 
                          "setState(() => _saveError = ErrorHandler.getMessage(e, fallback: 'Could not save changes. Please try again.'));")
            c = c.replace("} catch (_) {\\n      setState(() => _saveError = 'Could not save changes. Please try again.');",
                          "} catch (e) {\\n      setState(() => _saveError = ErrorHandler.getMessage(e, fallback: 'Could not save changes. Please try again.'));")
            c = c.replace("setState(() { loading = false; dialogError = detail ?? 'Could not send confirmation. Please try again.'; });",
                          "setState(() { loading = false; dialogError = ErrorHandler.getMessage(e, fallback: 'Could not send confirmation. Please try again.'); });")
            c = c.replace("} catch (_) {\\n                  setState(() { loading = false; dialogError = 'Could not send confirmation. Please try again.'; });",
                          "} catch (e) {\\n                  setState(() { loading = false; dialogError = ErrorHandler.getMessage(e, fallback: 'Could not send confirmation. Please try again.'); });")
                          
        if 'token_action_screen.dart' in f:
            c = c.replace("} catch (_) {\\n      _error = 'An error occurred while processing the link.';",
                          "} catch (e) {\\n      _error = ErrorHandler.getMessage(e, fallback: 'An error occurred while processing the link.');")
                          
        if 'welcome_screen.dart' in f:
            # welcome screen has empty catches, maybe leave them alone if they are just suppressing navigation errors.
            pass

        if 'menu_screen.dart' in f:
            c = c.replace("} catch (e) {\\n                      _showSnack('Error adding item.');",
                          "} catch (e) {\\n                      _showSnack(ErrorHandler.getMessage(e, fallback: 'Error adding item.'));")

        if 'login_screen.dart' in f:
            c = c.replace("} catch (_) {\\n      if (mounted) setState(() => _error = 'Could not send reactivation email. Please try again.');",
                          "} catch (e) {\\n      if (mounted) setState(() => _error = ErrorHandler.getMessage(e, fallback: 'Could not send reactivation email. Please try again.'));")

        with open(f, 'w', encoding='utf-8') as file:
            file.write(c)
        print(f"Refactored {f}")
    except Exception as e:
        print(f"Error refactoring {f}: {e}")
