import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InfiniteScrollingPage extends StatefulWidget {
  const InfiniteScrollingPage({Key? key}) : super(key: key);

  @override
  _InfiniteScrollingPageState createState() => _InfiniteScrollingPageState();
}

class _InfiniteScrollingPageState extends State<InfiniteScrollingPage> {
  final List<Product> _products = [];
  late ScrollController _scrollController;
  int _currentPage = 1;
  bool _isLoading = false; // 是否正在讀取資料
  bool _hasMore = true;    // 是否還有更多資料可抓

  @override
  void initState() {
    super.initState();

    // 初始化 ScrollController
    _scrollController = ScrollController()
      ..addListener(() {
        // 檢查使用者是否已經滾到最底部
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          // 如果還有更多資料(_hasMore=true) && 沒在讀取中(_isLoading=false)，才fetch
          if (!_isLoading && _hasMore) {
            _fetchProducts();
          }
        }
      });

    // 進入頁面先給他載第一批
    _fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          'http://57.180.15.102/api/erms/v1/products?page=$_currentPage&pageSize=10',
        ),
      );

      if (response.statusCode == 200) {
        final body = response.body;

        if (body.isEmpty) {
          throw Exception('Received empty response from server');
        }

        final List<dynamic> data = json.decode(body);

        // 如果已經沒有更多資料了，_hasMore 設為 false
        if (data.isEmpty) {
          setState(() {
            _hasMore = false;
          });
        } else {
          setState(() {
            _products.addAll(
              data.map((item) => Product.fromJson(item)).toList(),
            );
            _currentPage++;
          });
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('無限滾動產品清單'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _products.length + 1,   // 多 1 個用來顯示「載入中」或「沒有更多資料」
        itemBuilder: (context, index) {
          if (index < _products.length) {
            // 資料項
            final product = _products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                title: Text(product.name),
                subtitle: Text('庫存：${product.stock}'),
              ),
            );
          } else {
            // 最後一個 item => 顯示 Loading 或「沒有更多資料了」
            if (_hasMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    '沒有更多資料了',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['product_name'],
      stock: json['stock'],
    );
  }
}
