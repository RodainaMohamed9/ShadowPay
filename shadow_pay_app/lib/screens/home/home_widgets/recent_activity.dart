import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/transaction_list.dart';

class RecentActivity extends StatelessWidget {
  final bool isDarkMode;

  const RecentActivity({
    super.key,
    required this.isDarkMode,
  });

  final List<Map<String, dynamic>> activities = const [
    {
      'title': 'Apple Store',
      'time': 'Today • 09:42 AM',
      'amount': '-\$249.00',
      'status': 'SAFE',
      'statusColor': 0xFF00D8A2,
    },
    {
      'title': 'SkyJet Travel',
      'time': 'Today • 01:14 PM',
      'amount': '-\$870.00',
      'status': 'RISK',
      'statusColor': 0xFFFF9800,
    },
    {
      'title': 'Nova Market',
      'time': 'Blocked • 11:57 PM',
      'amount': '-\$1,920.00',
      'status': 'BLOCKED',
      'statusColor': 0xFFF44336,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.recentActivity,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionList(),
                  ),
                );
              },
              child: Text(
                loc.viewAll,
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...activities.map((activity) => _buildActivityItem(activity, loc)),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, AppLocalizations loc) {
    String statusText = '';
    if (activity['status'] == 'SAFE') {
      statusText = loc.safe;
    } else if (activity['status'] == 'RISK') {
      statusText = loc.risk;
    } else if (activity['status'] == 'BLOCKED') {
      statusText = loc.blocked;
    } else {
      statusText = activity['status'];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1F2E) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(activity['statusColor']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForTitle(activity['title']),
              color: Color(activity['statusColor']),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['time'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity['amount'],
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(activity['statusColor']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: Color(activity['statusColor']),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Apple Store':
        return Icons.shopping_bag_outlined;
      case 'SkyJet Travel':
        return Icons.flight_takeoff;
      case 'Nova Market':
        return Icons.shopping_cart_outlined;
      default:
        return Icons.payment;
    }
  }
}