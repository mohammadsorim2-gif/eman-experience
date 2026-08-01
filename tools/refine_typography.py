from pathlib import Path
import re

MAIN = Path('lib/main.dart')

text = MAIN.read_text(encoding='utf-8')

# Use DIN for Arabic content and Noto Sans for all other languages.
text = text.replace("fontFamily: arabic ? 'Noto Sans Arabic' : 'Inter',", "fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',")
text = text.replace("fontFamily: arabic ? 'Noto Sans Arabic' : 'Inter'", "fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans'")
text = text.replace("fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',", "fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',")

# Make Arabic typography lighter and more refined globally.
text = re.sub(
    r"textTheme:\s*base\.textTheme\.apply\((.*?)\),",
    "textTheme: base.textTheme.apply(\n"
    "        fontFamily: arabic ? 'DINNextLTArabic' : 'NotoSans',\n"
    "        fontFamilyFallback: const ['NotoSans', 'Tahoma', 'Arial', 'sans-serif'],\n"
    "      ).copyWith(\n"
    "        displayLarge: base.textTheme.displayLarge?.copyWith(fontWeight: arabic ? FontWeight.w500 : FontWeight.w700, height: arabic ? 1.15 : 1.05),\n"
    "        displayMedium: base.textTheme.displayMedium?.copyWith(fontWeight: arabic ? FontWeight.w500 : FontWeight.w700, height: arabic ? 1.18 : 1.08),\n"
    "        headlineLarge: base.textTheme.headlineLarge?.copyWith(fontWeight: arabic ? FontWeight.w500 : FontWeight.w700, height: arabic ? 1.22 : 1.10),\n"
    "        headlineMedium: base.textTheme.headlineMedium?.copyWith(fontWeight: arabic ? FontWeight.w500 : FontWeight.w700, height: arabic ? 1.25 : 1.12),\n"
    "        titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: arabic ? FontWeight.w500 : FontWeight.w700, height: arabic ? 1.28 : 1.15),\n"
    "        titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: arabic ? FontWeight.w500 : FontWeight.w600, height: arabic ? 1.30 : 1.18),\n"
    "        bodyLarge: base.textTheme.bodyLarge?.copyWith(fontWeight: arabic ? FontWeight.w400 : FontWeight.w400, height: arabic ? 1.65 : 1.50),\n"
    "        bodyMedium: base.textTheme.bodyMedium?.copyWith(fontWeight: arabic ? FontWeight.w400 : FontWeight.w400, height: arabic ? 1.60 : 1.45),\n"
    "        bodySmall: base.textTheme.bodySmall?.copyWith(fontWeight: arabic ? FontWeight.w300 : FontWeight.w400, height: arabic ? 1.55 : 1.40),\n"
    "        labelLarge: base.textTheme.labelLarge?.copyWith(fontFamily: 'NotoSans', fontWeight: FontWeight.w600),\n"
    "        labelMedium: base.textTheme.labelMedium?.copyWith(fontFamily: 'NotoSans', fontWeight: FontWeight.w600),\n"
    "        labelSmall: base.textTheme.labelSmall?.copyWith(fontFamily: 'NotoSans', fontWeight: FontWeight.w500),\n"
    "      ),",
    text,
    count=1,
    flags=re.S,
)

# Keep navigation labels in Noto Sans even when Arabic is selected.
text = text.replace(
    "selectedLabelTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: EmanExperienceApp.navy),",
    "selectedLabelTextStyle: TextStyle(fontFamily: 'NotoSans', fontSize: 13, fontWeight: FontWeight.w700, color: EmanExperienceApp.navy),",
)
text = text.replace(
    "unselectedLabelTextStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF607480)),",
    "unselectedLabelTextStyle: TextStyle(fontFamily: 'NotoSans', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF607480)),",
)

# NavigationRail labels.
text = text.replace(
    "label: Text(_label(item.$3)),",
    "label: Text(_label(item.$3), style: const TextStyle(fontFamily: 'NotoSans')),")

# NavigationDrawer labels.
text = text.replace(
    "label: Text(_label(item.$3)),",
    "label: Text(_label(item.$3), style: const TextStyle(fontFamily: 'NotoSans')),")

# Language selector and compact menu labels.
text = text.replace(
    "Expanded(child: Text(item.nativeName)),",
    "Expanded(child: Text(item.nativeName, style: const TextStyle(fontFamily: 'NotoSans'))),")
text = text.replace(
    "Text(language.nativeName, style: const TextStyle(fontWeight: FontWeight.w800)),",
    "Text(language.nativeName, style: const TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.w600)),")

# Buttons and small UI labels should stay lighter and neutral.
text = text.replace(
    "textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),",
    "textStyle: const TextStyle(fontFamily: 'NotoSans', fontSize: 14, fontWeight: FontWeight.w600),")

MAIN.write_text(text, encoding='utf-8')
print('Refined typography applied to lib/main.dart')
