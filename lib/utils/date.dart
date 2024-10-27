
String formatFileModificationDate(DateTime? modificationDate) {
  if(modificationDate == null) {
    return "未知时间";
  }
  final now = DateTime.now();
  final difference = now.difference(modificationDate);

  if (difference.inDays > 365) {
    // 超过一年
    final years = (difference.inDays / 365).floor();
    return '$years 年前';
  } else if (difference.inDays > 30) {
    // 超过一个月
    final months = (difference.inDays / 30).floor();
    return '$months 月前';
  } else if (difference.inDays > 7) {
    // 超过一周
    final weeks = (difference.inDays / 7).floor();
    return '$weeks 周前';
  } else if (difference.inDays > 0) {
    // 超过一天
    return '${difference.inDays} 天前';
  } else if (difference.inHours > 0) {
    // 超过一小时
    return '${difference.inHours} 小时前';
  } else if (difference.inMinutes > 0) {
    // 超过一分钟
    return '${difference.inMinutes} 分钟前';
  } else {
    // 少于一分钟
    return '刚刚';
  }
}