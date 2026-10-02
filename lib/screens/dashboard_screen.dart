import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 0;
  final labels = const ['Dashboard', 'Users', 'Services', 'Orders', 'Finance', 'AI', 'Reports', 'Support', 'Settings', 'Audit Logs'];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('FELANCE WORK • ${labels[index]}'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: Text(auth.adminProfile['role'] ?? 'ADMIN')),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => auth.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Align(alignment: Alignment.bottomLeft, child: Text('FELANCE WORK\nAdmin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            ),
            for (var i = 0; i < labels.length; i++)
              ListTile(
                selected: index == i,
                leading: Icon(_icons[i]),
                title: Text(labels[i]),
                onTap: () { Navigator.pop(context); setState(() => index = i); },
              ),
          ],
        ),
      ),
      body: _buildPage(index),
    );
  }

  Widget _buildPage(int i) {
    if (i == 0) return const _DashboardHome();
    return AdminSection(title: labels[i], permission: _permissionFor(i));
  }

  String _permissionFor(int i) => const {
    1: 'users.read', 2: 'services.read', 3: 'orders.read', 4: 'payments.read',
    5: 'ai.read', 6: 'reports.read', 7: 'support.read', 8: 'settings.read', 9: 'audit.read',
  }[i] ?? '*';

  static const _icons = [
    Icons.dashboard_outlined, Icons.people_outline, Icons.inventory_2_outlined,
    Icons.receipt_long_outlined, Icons.account_balance_wallet_outlined,
    Icons.auto_awesome_outlined, Icons.flag_outlined, Icons.support_agent_outlined,
    Icons.settings_outlined, Icons.history,
  ];
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    final cards = [
      ('Total Users', '—', Icons.people),
      ('Freelancers', '—', Icons.work_outline),
      ('Pending Services', '—', Icons.pending_actions),
      ('Orders', '—', Icons.receipt_long),
      ('Platform Revenue', '—', Icons.payments),
      ('Pending Payouts', '—', Icons.account_balance_wallet),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Overview', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 260, mainAxisExtent: 120, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: cards.length,
          itemBuilder: (_, i) => Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                Icon(cards[i].$3, size: 32),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(cards[i].$1),
                  const SizedBox(height: 8),
                  Text(cards[i].$2, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('Connect the dashboard metrics to secure Cloud Functions. Do not calculate privileged totals from untrusted client input.'))),
      ],
    );
  }
}

class AdminSection extends StatelessWidget {
  final String title;
  final String permission;
  const AdminSection({super.key, required this.title, required this.permission});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (!auth.hasPermission(permission)) {
      return const Center(child: Text('You do not have permission to view this section.'));
    }
    return Center(child: Text('$title\n\nPermission: $permission', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22)));
  }
}
