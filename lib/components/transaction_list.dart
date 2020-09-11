import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final void Function(String) onRemove;
  TransactionList(this.transactions, this.onRemove);


  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty ? 
      LayoutBuilder(
        builder: (ctx, constraints) {
          return Column(
          children: <Widget> [
            SizedBox(height: 20),
            Container(
              height: constraints.maxHeight * 0.3,
              child: Text(
                'Nenhuma Transação Cadastrada',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: constraints.maxHeight * 0.5,
              child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover, 
                ),
            ),
          ],
          );
        }
      ): 
      ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {
          final tr = transactions[index];
          return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(           
                vertical:8, 
                horizontal: 5
                ),
              child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    child: Text('R\$${tr.value}')
                    ),
                ),
              ),
              title: Text(
                tr.title,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(
                DateFormat('d MMM y').format(tr.date),
              ),
              trailing: MediaQuery.of(context).size.width > 480 ? 
              FlatButton.icon(
                onPressed: ()=> onRemove(tr.id), 
                icon: Icon(Icons.delete),
                label: Text('Excluir'),
                textColor: Theme.of(context).errorColor,
                )
              :IconButton(
                icon: Icon(Icons.delete), 
                onPressed: ()=> onRemove(tr.id),
                color: Theme.of(context).errorColor,
                ),
            ),
          );
        }
      );
  }
}