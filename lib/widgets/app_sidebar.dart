import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/api_config.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';

class AppSidebar extends StatelessWidget {
  final VoidCallback? onNavigate;

  const AppSidebar({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppColors.gray900,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SidebarItem(
              icon: Icons.tune,
              label: 'DASHBOARD',
              isBrand: true,
              onTap: () => _goHome(context),
            ),
            const SizedBox(height: 40),
            _SidebarItem(
              icon: Icons.newspaper,
              label: 'Berita',
              onTap: () => _go(context, '/news'),
            ),
            _SidebarItem(
              icon: Icons.photo_library,
              label: 'Galeri',
              onTap: () => _go(context, '/gallery'),
            ),
            _SidebarItem(
              icon: Icons.mail_outline,
              label: 'Kontak',
              onTap: () => _go(context, '/contacts'),
            ),
            _SidebarItem(
              icon: Icons.badge_outlined,
              label: 'Info Kontak',
              onTap: () => _go(context, '/contact-info'),
            ),
            _SidebarItem(
              icon: Icons.open_in_new,
              label: 'Kembali ke website',
              onTap: _openWebsite,
            ),
            const Spacer(),
            _SidebarItem(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  void _closeDrawer(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold != null && scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
    }
  }

  void _go(BuildContext context, String route) {
    _closeDrawer(context);
    onNavigate?.call();
    Navigator.of(context).popUntil((r) => r.isFirst);
    Navigator.of(context).pushNamed(route);
  }

  void _goHome(BuildContext context) {
    _closeDrawer(context);
    onNavigate?.call();
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  Future<void> _openWebsite() async {
    final uri = Uri.parse(ApiConfig.websiteUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    _closeDrawer(context);
    onNavigate?.call();
    Navigator.of(context).popUntil((r) => r.isFirst);
    await auth.logout();
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isBrand;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isBrand = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.gray800,
        splashColor: AppColors.gray700,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isBrand ? 32 : 16,
          ),
          child: Row(
            mainAxisAlignment: isBrand
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            spacing: 12,
            children: [
              Icon(icon, color: Colors.white, size: isBrand ? 20 : 18),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: isBrand ? 18 : 14,
                  letterSpacing: isBrand ? 1 : 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
