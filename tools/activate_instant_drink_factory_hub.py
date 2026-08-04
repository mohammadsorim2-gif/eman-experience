#!/usr/bin/env python3
from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

import_line = "import 'screens/factory/instant_drink_factory_hub.dart';\n"
anchor = "import 'screens/factory/advanced_factory_dashboard.dart';\n"
if import_line not in text:
    if anchor not in text:
        raise SystemExit('Factory dashboard import anchor was not found in lib/main.dart')
    text = text.replace(anchor, anchor + import_line, 1)

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

path.write_text(text, encoding='utf-8')
print('Instant drink factory hub activated in lib/main.dart')
