from pathlib import Path

MAIN = Path('lib/main.dart')

text = MAIN.read_text(encoding='utf-8')

import_line = "import 'core/theme/app_design_system.dart';\n"
anchor = "import 'core/theme/app_typography.dart';\n"
if import_line not in text:
    if anchor not in text:
        raise SystemExit('Typography import anchor not found.')
    text = text.replace(anchor, anchor + import_line, 1)

old = "return base.copyWith(textTheme: AppTypography.textTheme(arabic: arabic));"
new = "return AppDesignSystem.apply(\n      base.copyWith(textTheme: AppTypography.textTheme(arabic: arabic)),\n    );"

if old not in text and new not in text:
    raise SystemExit('Theme return statement not found.')

text = text.replace(old, new, 1)
MAIN.write_text(text, encoding='utf-8')
print('EMAN design system activated.')
