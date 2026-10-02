import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() => runApp(const GoldApp());

class GoldApp extends StatelessWidget {
  const GoldApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GoldHunterPage(),
    );
  }
}

class GoldHunterPage extends StatefulWidget {
  const GoldHunterPage({super.key});
  @override
  State<GoldHunterPage> createState() => _GoldHunterPageState();
}

class _GoldHunterPageState extends State<GoldHunterPage> {
  double? goldPrice;
  String status = "جاري التحميل...";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchGold();
    timer = Timer.periodic(const Duration(seconds: 30), (t) => fetchGold());
  }

  Future<void> fetchGold() async {
    try {
      final res = await http.get(Uri.parse('https://api.gold-api.com/price/XAU'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          goldPrice = (data['price'] as num).toDouble();
          status = "مباشر LIVE";
        });
      }
    } catch (e) {
      setState(() => status = "خطأ بالاتصال");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gold Hunter - LIVE'), centerTitle: true, backgroundColor: Colors.amber[700]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on, size: 80, color: Colors.amber[400]),
            const SizedBox(height: 20),
            Text(status, style: const TextStyle(fontSize: 20, color: Colors.green)),
            const SizedBox(height: 20),
            if (goldPrice!= null)
              Text("\$${goldPrice!.toStringAsFixed(2)}", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold))
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text("سعر أونصة الذهب / XAU", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: fetchGold, child: const Text("تحديث الآن")),
          ],
        ),
      ),
    );
  }
}
