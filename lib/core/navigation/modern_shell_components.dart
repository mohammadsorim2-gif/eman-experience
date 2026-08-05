import 'package:flutter/material.dart';

class ShellDestination {
  const ShellDestination({
    required this.icon,
    required this.label,
    required this.accent,
    this.badge,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final String? badge;
}

class ModernSidebar extends StatelessWidget {
  const ModernSidebar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.logo,
    required this.footer,
    required this.collapsed,
    required this.onToggleCollapsed,
    super.key,
  });

  final List<ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget logo;
  final Widget footer;
  final bool collapsed;
  final VoidCallback onToggleCollapsed;

  @override
  Widget build(BuildContext context) {
    final width = collapsed ? 88.0 : 260.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: width,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              collapsed ? 14 : 20,
              18,
              collapsed ? 14 : 20,
              14,
            ),
            child: Row(
              children: [
                Expanded(child: logo),
                IconButton(
                  tooltip: collapsed ? 'Expand' : 'Collapse',
                  onPressed: onToggleCollapsed,
                  icon: Icon(
                    collapsed
                        ? Icons.keyboard_double_arrow_right_rounded
                        : Icons.keyboard_double_arrow_left_rounded,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
              itemCount: destinations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = destinations[index];
                final selected = selectedIndex == index;
                return _SidebarTile(
                  destination: item,
                  selected: selected,
                  collapsed: collapsed,
                  onTap: () => onSelected(index),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(padding: EdgeInsets.all(collapsed ? 12 : 16), child: footer),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatefulWidget {
  const _SidebarTile({
    required this.destination,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final ShellDestination destination;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.destination;
    final background = widget.selected
        ? item.accent.withValues(alpha: .12)
        : hovered
        ? const Color(0xFFF5F8FA)
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: Tooltip(
        message: widget.collapsed ? item.label : '',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: widget.collapsed ? 10 : 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(16),
                border: widget.selected
                    ? Border.all(color: item.accent.withValues(alpha: .18))
                    : null,
              ),
              child: Row(
                mainAxisAlignment: widget.collapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: item.accent.withValues(
                        alpha: widget.selected ? .20 : .11,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(item.icon, color: item.accent, size: 21),
                  ),
                  if (!widget.collapsed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF173042),
                          fontWeight: widget.selected
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (item.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item.accent.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          item.badge!,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: item.accent),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ModernTopBar extends StatelessWidget {
  const ModernTopBar({
    required this.title,
    required this.subtitle,
    required this.searchLabel,
    required this.onSearch,
    required this.onNotifications,
    required this.onMessages,
    required this.onTasks,
    required this.language,
    required this.profile,
    super.key,
  });

  final String title;
  final String subtitle;
  final String searchLabel;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onMessages;
  final VoidCallback onTasks;
  final Widget language;
  final Widget profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF71828D),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: onSearch,
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F8FA),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFE2E9ED)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Color(0xFF4D6A79)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        searchLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF71828D),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE1E8EC)),
                      ),
                      child: const Text('⌘ K'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _TopAction(
            icon: Icons.checklist_rounded,
            tooltip: 'Tasks',
            onTap: onTasks,
            badge: '3',
          ),
          _TopAction(
            icon: Icons.forum_outlined,
            tooltip: 'Messages',
            onTap: onMessages,
            badge: '5',
          ),
          _TopAction(
            icon: Icons.notifications_none_rounded,
            tooltip: 'Notifications',
            onTap: onNotifications,
            badge: '8',
          ),
          const SizedBox(width: 6),
          language,
          const SizedBox(width: 8),
          profile,
        ],
      ),
    );
  }
}

class _TopAction extends StatefulWidget {
  const _TopAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.badge,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final String badge;

  @override
  State<_TopAction> createState() => _TopActionState();
}

class _TopActionState extends State<_TopAction> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: IconButton(
          onPressed: widget.onTap,
          style: IconButton.styleFrom(
            backgroundColor: hovered
                ? const Color(0xFFF3F7F9)
                : Colors.transparent,
          ),
          icon: Badge(
            label: Text(widget.badge),
            child: Icon(widget.icon, size: 21),
          ),
        ),
      ),
    );
  }
}
