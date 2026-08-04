#!/usr/bin/env python3
from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

import_line = "import 'screens/auth/auth_gate.dart';\n"
anchor = "import 'screens/executive/advanced_executive_dashboard.dart';\n"
if import_line not in text:
    if anchor not in text:
        raise SystemExit('Could not find main.dart import anchor')
    text = text.replace(anchor, import_line + anchor, 1)

old_home = (
    "      home: EmanOneShell(language: _language, onLanguageChanged: _setLanguage),\n"
)
new_home = """      home: AuthGate(
        languageCode: _language.code,
        authenticatedBuilder: (context, user, signOut) => EmanOneShell(
          language: _language,
          onLanguageChanged: _setLanguage,
        ),
      ),
"""

if old_home in text:
    text = text.replace(old_home, new_home, 1)
elif 'home: AuthGate(' not in text:
    raise SystemExit('Could not find MaterialApp home configuration')

path.write_text(text, encoding='utf-8')
print('Authentication gate activated in lib/main.dart')
