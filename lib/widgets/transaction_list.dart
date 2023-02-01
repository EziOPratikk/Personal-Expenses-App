import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return
        // Container(
        //   // MediaQuery is for responsive design like in CSS
        //   // Here .size.height takes full device screen height and multiplying
        //   // by 0.65 will take 65% of the device screen height.
        //   height: MediaQuery.of(context).size.height * 0.65,
        transactions.isEmpty
            ? LayoutBuilder(builder: (ctx, constraints) {
                return Column(
                  children: [
                    Text(
                      "No transactions added yet!",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    // SizedBox is used to add some spacing
                    SizedBox(height: constraints.maxHeight * 0.03),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              })
            // List View is just like a column which takes infinite height
            // List View builder is also same like List View but it only loads
            // the lists that is visibile in the viewport
            // which is better for performance
            // if we know the no. of list then we can use List View otherwise
            // use List View builder.
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return TransactionItem(
                    key: ValueKey(transactions[index].id),
                    transaction: transactions[index],
                    deleteTx: deleteTx,
                  );
                },
                itemCount: transactions.length,
              );
  }
}
