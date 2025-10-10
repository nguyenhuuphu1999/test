import 'package:flutter/material.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';
import 'package:vpncn2_app/widgets/key_item_tile.dart';
import 'package:vpncn2_app/widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final List<_KeyItem> items = <_KeyItem>[
      _KeyItem(name: 'Key-Name-01', quota: '120GB/150GB', remainDays: 5),
      _KeyItem(name: 'Key-Name-02', quota: '120GB/150GB', remainDays: 5),
      _KeyItem(name: 'Key-Name-03', quota: '120GB/150GB', remainDays: 5),
      _KeyItem(name: 'Key-Name-03', quota: '120GB/150GB', remainDays: 5),
      _KeyItem(name: 'Key-Name-03', quota: '120GB/150GB', remainDays: 0, expired: true),
    ].where((e) => e.name.toLowerCase().contains(search.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F8),
      bottomNavigationBar: _BottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _HeaderCard(balance: '20\$', greeting: t.hiUser('Manhnt')),
              const SizedBox(height: 12),
              SearchField(onChanged: (v) => setState(() => search = v)),
              const SizedBox(height: 12),
              for (final item in items)
                KeyItemTile(
                  name: item.name,
                  quotaText: item.quota,
                  remainDays: item.remainDays,
                  expired: item.expired,
                  onConnect: () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String balance;
  final String greeting;

  const _HeaderCard({required this.balance, required this.greeting});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF4894FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(greeting, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              Text(balance, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _HeaderAction(icon: Icons.monetization_on_outlined, label: t.payment),
              _HeaderAction(icon: Icons.help_outline, label: t.faq),
              _HeaderAction(icon: Icons.shopping_bag_outlined, label: t.buy),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFF2F6BFF), size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x11000000), blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _BottomItem(icon: Icons.home_outlined, label: t.home, active: true),
          _BottomItem(icon: Icons.cloud_outlined, label: 'Cloud'),
          _BottomItem(icon: Icons.person_outline, label: ''),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomItem({required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final Color color = active ? const Color(0xFF4894FE) : const Color(0xFF9AA6B2);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: color),
        if (label.isNotEmpty) Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class _KeyItem {
  final String name;
  final String quota;
  final int remainDays;
  final bool expired;

  _KeyItem({required this.name, required this.quota, required this.remainDays, this.expired = false});
}


