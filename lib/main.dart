import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';

import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'components/chart.dart';
import 'models/transaction.dart';
import 'dart:math';


main () => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.purple,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),
          )
        )
      )
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction (
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id){
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _opentransactionFormModal(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
      );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar (
        title: Text('Despesas Pessoais', style: TextStyle(
          fontSize: 15 * mediaQuery.textScaleFactor,
        ),),
        actions: <Widget>[

            if(isLandscape)
            IconButton(
              icon: Icon(_showChart ? Icons.list : Icons.pie_chart),
              onPressed: () { setState(() {
                _showChart = !_showChart;
              });
              },
            ),

            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _opentransactionFormModal(context)
            ),
        ],
      );

    final availableHeight = mediaQuery.size.height - 
        appBar.preferredSize.height - 
        MediaQuery.of(context).padding.top; // Verifica tamanho da tela removendo o appBar e a barra de funções.

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            if(_showChart || !isLandscape)
            Container(
              height: availableHeight * (isLandscape ? 0.7 : 0.25),
              child: Chart(_recentTransactions),
              ),
            if(!_showChart || !isLandscape)
            Container(
              height:  availableHeight * (isLandscape ? 1 : 0.65),
              child: TransactionList(_transactions, _removeTransaction)
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _opentransactionFormModal(context),
      ),
    );
  }
}