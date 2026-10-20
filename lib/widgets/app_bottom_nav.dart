import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/api_config.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';

class AppBottomNav extends StatelessWidget {
  static const _items = <_NavItem>[
    _NavItem(icon: Icons.tune, label: 'Dashboard'),
    _NavItem(icon: Icons.newspaper, label: 'Berita'),
    _NavItem(icon: Icons.photo_library, label: 'Galeri'),
    _NavItem(icon: Icons.mail_outline, label: 'Kontak'),
    _NavItem(icon: Icons.badge_outlined, label: 'Info'),
  ];

  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AppBottomNav({
    super.key,
    this.currentIndex = 0,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.gray300)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: _items[i],
                    selected: i == currentIndex,
                    onTap: () => onTabSelected(i),
                  ),
                ),
              Expanded(
                child: _NavButton(
                  item: const _NavItem(
                    icon: Icons.more_horiz,
                    label: 'Lainnya',
                  ),
                  selected: false,
                  onTap: () => _openMoreSheet(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Logout?'),
        content: const Text('Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'LOGOUT',
              style: TextStyle(color: AppColors.red400),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    await auth.logout();
  }

  void _openMoreSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, color: AppColors.gray300),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Pergi ke website'),
              onTap: () {
                Navigator.pop(ctx);
                _openWebsite();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.red400),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.red400),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _logout(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _openWebsite() async {
    final uri = Uri.parse(ApiConfig.websiteUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}

class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  Widget build(BuildContext context) {
    final color = widget.selected ? AppColors.gray900 : AppColors.gray500;

    return InkWell(
      onTap: widget.onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          ScaleTransition(
            scale: _scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: widget.selected ? AppColors.gray100 : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  widget.item.icon,
                  key: ValueKey(widget.selected),
                  size: 22,
                  color: color,
                ),
              ),
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 10,
              fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
            child: Text(
              widget.item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: widget.selected ? 16 : 4,
            height: 3,
            decoration: BoxDecoration(
              color: widget.selected ? AppColors.gray900 : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _NavButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.selected ? 1 : 0,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
