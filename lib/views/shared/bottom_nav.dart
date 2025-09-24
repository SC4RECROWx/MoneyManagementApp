import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  const BottomNav({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_outlined),
              activeIcon: Icon(
                Icons.attach_money,
                color: Theme.of(context).primaryColor,
              ),
              label: 'Pemasukan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money_off_outlined),
              activeIcon: Icon(
                Icons.money_off,
                color: Theme.of(context).primaryColor,
              ),
              label: 'Pengeluaran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(
                Icons.bar_chart,
                color: Theme.of(context).primaryColor,
              ),
              label: 'Budget',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined),
              activeIcon: Icon(
                Icons.insert_chart,
                color: Theme.of(context).primaryColor,
              ),
              label: 'Laporan',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/income');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/expense');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/budget');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/report');
                break;
            }
          },
        ),
      ),
    );
  }
}
