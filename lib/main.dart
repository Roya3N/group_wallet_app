import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.SUPABASE_URL,
    anonKey: Env.SUPABASE_ANON_KEY,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final supabase = Supabase.instance.client;

  Future<void> fetchGroups(BuildContext context) async {
    try {
      final response = await supabase.from('groups').select();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fetched ${response.length} groups successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching groups: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Wallet Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => fetchGroups(context),
          child: const Text('Fetch Groups'),
        ),
      ),
    );
  }
}
