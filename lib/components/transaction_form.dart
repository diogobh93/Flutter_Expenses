import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TransactionForm extends StatefulWidget {

  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  
  final _titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm(){
    final title = _titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    if(title.isEmpty || value <=0 || _selectedDate == null){
      return;
      }

    widget.onSubmit(title,value, _selectedDate);
  }

  _showDatePicker() {
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2020), 
      lastDate: DateTime.now(),

    ).then((pickedDate) {
      if(pickedDate == null) {return;}

      setState(() {
        _selectedDate = pickedDate;  
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
            child: Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.only(
                  top:10, 
                  right:10, 
                  left:10, 
                  bottom: 10 + mediaQuery.viewInsets.bottom,
                ),
                child: Column(
                  children: <Widget> [
                    TextField(
                      controller: _titleController,
                      onSubmitted: (_) => _submitForm(),
                      decoration: InputDecoration(
                        labelText: 'Título',
                      ),
                    ),
                    TextField(
                      controller: valueController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onSubmitted: (_) => _submitForm(),
                      decoration: InputDecoration(
                        labelText: 'Valor (R\$)',
                      ),
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_selectedDate == null ? 'Nenhuma data selecionada!'
                            :'Data Selecionada: ${DateFormat('dd/M/y').format(_selectedDate)}',
                            ),
                          ),
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text(
                            'Selecionar Data', 
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
                            onPressed: _showDatePicker,
                          ),
                      ],),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).textTheme.button.color,
                          child: Text('Nova Transação'),
                          onPressed: _submitForm
                        ),
                      ],
                    )
                  ]
                ),
              ),
            ),
    );
  }
}