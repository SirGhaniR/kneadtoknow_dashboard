String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) return 'baru saja';
  if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
  if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
  if (diff.inDays < 30) return '${diff.inDays} hari yang lalu';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} bulan yang lalu';
  return '${(diff.inDays / 365).floor()} tahun yang lalu';
}
