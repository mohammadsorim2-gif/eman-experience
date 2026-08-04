#!/usr/bin/env python3
from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

factory_import = "import 'screens/factory/instant_drink_factory_hub.dart';\n"
auth_import = "import 'screens/auth/firebase_auth_gate.dart';\n"
factory_anchor = "import 'screens/factory/advanced_factory_dashboard.dart';\n"

if factory_import not in text:
    if factory_anchor not in text:
        raise SystemExit('Factory dashboard import anchor was not found in lib/main.dart')
    text = text.replace(factory_anchor, factory_anchor + factory_import, 1)

if auth_import not in text:
    auth_anchor = "import 'screens/executive/advanced_executive_dashboard.dart';\n"
    if auth_anchor not in text:
        raise SystemExit('Authentication import anchor was not found in lib/main.dart')
    text = text.replace(auth_anchor, auth_anchor + auth_import, 1)

text = text.replace(
    '  static const pages = [',
    '  List<Widget> get pages => [',
    1,
)

old_page = '    AdvancedFactoryDashboard(),'
new_page = '    InstantDrinkFactoryHub(languageCode: widget.language.code),'
if old_page in text:
    text = text.replace(old_page, new_page, 1)
elif new_page not in text:
    raise SystemExit('Factory page entry was not found in lib/main.dart')

old_home = '      home: EmanOneShell(language: _language, onLanguageChanged: _setLanguage),'
new_home = """      home: FirebaseAuthGate(
        languageCode: _language.code,
        authenticatedBuilder: (_) => EmanOneShell(
          language: _language,
          onLanguageChanged: _setLanguage,
        ),
      ),"""
if old_home in text:
    text = text.replace(old_home, new_home, 1)
elif new_home not in text:
    raise SystemExit('Application home entry was not found in lib/main.dart')

path.write_text(text, encoding='utf-8')
print('Instant drink factory hub and Firebase auth gate activated in lib/main.dart')
