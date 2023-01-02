import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    // Constraints is a concept in flutter that simply refers to height and
    // width, it defines how a widget is rendered on the screen.
    return LayoutBuilder(builder: (ctx, Constraints) {
      return Column(
        children: [
          Container(
            height: Constraints.maxHeight * 0.15,
            // FittedBox widget forces the child into the box and avoids growing of
            // its child i.e. it shrinks to fit in the box.
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(height: Constraints.maxHeight * 0.05),
          Container(
            height: Constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              // Stack widget also takes list of widgets and the first widget is
              // the bottom one and the next widget will be on top of that
              // bottom widget and so on like a stack.
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Constraints.maxHeight * 0.05),
          Container(
            height: Constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
