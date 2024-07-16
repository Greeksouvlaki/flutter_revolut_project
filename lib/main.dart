import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Revolut Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> futureTransactions;

  @override
  void initState() {
    super.initState();
    futureTransactions = apiService.fetchTransactions();
  }

  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  void _submitTransaction() {
    final description = _descriptionController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final date = _dateController.text;

    if (description.isNotEmpty && amount != 0.0 && date.isNotEmpty) {
      apiService.addTransaction(description, amount, date).then((_) {
        setState(() {
          futureTransactions = apiService.fetchTransactions();
        });
        _descriptionController.clear();
        _amountController.clear();
        _dateController.clear();
      }).catchError((error) {
        print('Failed to add transaction: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '\$1,234.56',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionButton(
                      icon: Icons.send,
                      label: 'Send',
                      onPressed: () {},
                    ),
                    ActionButton(
                      icon: Icons.request_page,
                      label: 'Request',
                      onPressed: () {},
                    ),
                    ActionButton(
                      icon: Icons.swap_horiz,
                      label: 'Exchange',
                      onPressed: () {},
                    ),
                    ActionButton(
                      icon: Icons.more_horiz,
                      label: 'More',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureTransactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final transactions = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionItem(
                        description: transaction['description'],
                        amount: transaction['amount'].toString(),
                        date: transaction['date'],
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitTransaction,
                  child: Text('Add Transaction'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: Colors.white,
            foregroundColor: Colors.indigo,
            padding: EdgeInsets.all(16),
          ),
          child: Icon(icon, size: 32),
          onPressed: onPressed,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String description;
  final String amount;
  final String date;

  TransactionItem({
    required this.description,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.receipt, color: Colors.indigo),
      title: Text(description),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(
          color: amount.startsWith('-') ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
