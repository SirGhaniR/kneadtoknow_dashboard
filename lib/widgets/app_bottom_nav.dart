import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/api_config.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';

class AppBottomNav extends StatelessWidget {
  static const _items = <_NavItem>[
    _NavItem(icon: Icons.tune, label: 'Dashboard', route: null),
    _NavItem(icon: Icons.newspaper, label: 'Berita', route: '/news'),
    _NavItem(icon: Icons.photo_library, label: 'Galeri', route: '/gallery'),
    _NavItem(icon: Icons.mail_outline, label: 'Kontak', route: '/contacts'),
    _NavItem(icon: Icons.badge_outlined, label: 'Info', route: '/contact-info'),
  ];

  final int currentIndex;

  const AppBottomNav({super.key, this.currentIndex = 0});

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
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: _items[i],
                    selected: i == currentIndex,
                    onTap: () => _goTo(context, i),
                  ),
                ),
              Expanded(
                child: _NavButton(
                  item: const _NavItem(
                    icon: Icons.more_horiz,
                    label: 'Lainnya',
                    route: null,
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

  void _goTo(BuildContext context, int index) {
    if (index == currentIndex) return;

    final route = _items[index].route;
    final navigator = Navigator.of(context);

    if (route == null) {
      navigator.popUntil((r) => r.isFirst);
    } else {
      navigator.popUntil((r) => r.isFirst);
      navigator.pushNamed(route);
    }
  }

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final navigator = Navigator.of(context);

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

    navigator.popUntil((r) => r.isFirst);
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

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.gray900 : AppColors.gray500;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Icon(item.icon, size: 22, color: color),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: selected ? AppColors.gray900 : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String? route;

  const _NavItem({required this.icon, required this.label, this.route});
}
