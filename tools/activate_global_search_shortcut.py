from pathlib import Path

MAIN = Path("lib/main.dart")


def main() -> None:
    source = MAIN.read_text(encoding="utf-8")

    shortcut_import = "import 'core/search/global_search_shortcut.dart';"
    search_import = "import 'core/search/global_search.dart';"
    if shortcut_import not in source:
        if search_import not in source:
            raise SystemExit("Global search import not found in lib/main.dart")
        source = source.replace(
            search_import,
            f"{search_import}\n{shortcut_import}",
            1,
        )

    old = """  Widget _currentPage() => KeyedSubtree(
    key: ValueKey('${widget.language.code}-$currentIndex'),
    child: pages[currentIndex],
  );
"""
    new = """  Widget _currentPage() => GlobalSearchShortcut(
    onSearch: _openSearch,
    child: KeyedSubtree(
      key: ValueKey('${widget.language.code}-$currentIndex'),
      child: pages[currentIndex],
    ),
  );
"""

    if old in source:
        source = source.replace(old, new, 1)
    elif "GlobalSearchShortcut(" not in source:
        raise SystemExit("Current page wrapper was not found in lib/main.dart")

    MAIN.write_text(source, encoding="utf-8")
    print("Global search keyboard shortcut activated in lib/main.dart")


if __name__ == "__main__":
    main()
