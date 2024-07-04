import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category_ selectedCategory = Category_.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitExpenseButton() {
    
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;
    
    if (_titleController.text.trim().isEmpty || amountIsValid ||_selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
            'Please make sure a valid title,amount,date and category was entered.'),
        actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
        
    widget.onAddExpense(Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: selectedCategory)
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx,constraints){
      final width = constraints.maxWidth;

      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16,16,16,keyboardSpace + 16),
          child: Column(
            children: [
              if(width >= 600)
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(label: Text('Title')),
                          ),
                        ),
                        const SizedBox(width: 24,),
                        Expanded(
                        // This line ensures the TextField gets a bounded width
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: 'Rs ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        //Category
                        DropdownButton(
                          value: selectedCategory,
                          items: Category_.values
                            .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()))).toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          }
                        ),
                        const SizedBox(width: 24,), // Spacing
                        // Date Picker
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!)),
                              IconButton(
                                  onPressed: () async {
                                    final now = DateTime.now();
                                    final firstDate = DateTime(now.year - 1, now.month, now.day);
                                    final pickedDate = await showDatePicker(
                                        context: context,
                                        firstDate: firstDate,
                                        lastDate: now);
                                    setState(() {
                                      _selectedDate = pickedDate;
                                    });
                                  },
                                  icon: const Icon(Icons.calendar_month)),
                              ],
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        //Cancel Button
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        const SizedBox(width: 8), // Adds some spacing between the buttons
                        //submit Button
                        ElevatedButton(
                            onPressed: _submitExpenseButton,
                            child: const Text('Save Expense')),
                      ],
                    ) 
                  ],
                )
              else
                Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(label: Text('Title')),
                    ),
                    Row(
                      children: [
                        //amount
                        Expanded(
                          // This line ensures the TextField gets a bounded width
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: 'Rs ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        //Date Picker
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!)),
                              IconButton(
                                  onPressed: () async {
                                    final now = DateTime.now();
                                    final firstDate =
                                        DateTime(now.year - 1, now.month, now.day);
                                    final pickedDate = await showDatePicker(
                                        context: context,
                                        firstDate: firstDate,
                                        lastDate: now);
                                    setState(() {
                                      _selectedDate = pickedDate;
                                    });
                                  },
                                  icon: const Icon(Icons.calendar_month)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.end, // Aligns buttons to the end of the row
                      children: [
                        //Category
                        DropdownButton(
                            value: selectedCategory,
                            items: Category_.values
                                .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase())))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                        const Spacer(),
                        //Cancel Button
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        const SizedBox(width: 8), // Adds some spacing between the buttons
                        //Submit Button
                        ElevatedButton(
                            onPressed: _submitExpenseButton,
                            child: const Text('Save Expense')),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
    });
  }
}
