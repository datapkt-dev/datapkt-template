import 'package:flutter/material.dart';


import 'listview_searchbar/Infinite_scrolling.dart'; // 確保這是無限滾動頁面的檔案名稱

class TemplateIndexPage extends StatefulWidget {
  @override
  _TemplateIndexPageState createState() => _TemplateIndexPageState();
}

class _TemplateIndexPageState extends State<TemplateIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '列表與輸入框',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    '列表無限滾動',
                    '',
                    Icons.credit_card,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfiniteScrollingPage(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard('外幣活/定存', '美元定存14天 8.0%', Icons.attach_money, null),
                  _buildFeatureCard('外幣轉換', '', Icons.currency_exchange, null),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                '放大我的財富',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard('投資', '', Icons.bar_chart, null),
                  _buildFeatureCard('貸款', '手續費 NT\$399 起', Icons.money, null),
                  _buildFeatureCard('保險', '', Icons.shield, null),
                  _buildFeatureCard('更多功能', '', Icons.more_horiz, null),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: '總覽'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: '收付'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: '探索'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap, // 點擊卡片執行 onTap 方法
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
