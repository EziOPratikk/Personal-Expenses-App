import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // This code is used for setting device orientations
  // Here, we fixed the orientation to only portrait mode
  // services.dart package is also needed for this.
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        // primarySwatch contains different shades too, which is not available
        // in primaryColor.
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        // by default errorColor is red.
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          // headline6 just means title as in app bar.
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// with keyword is called mix in, which we use to get extra features of
// that class. Let's understand as it interface keyword.
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // String titleInput;

  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 59.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 15.53,
    //   date: DateTime.now(),
    // )
  ];

  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    // App life cycle has different state such as inactive, paused,
    // resume and suspended.
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    // context ctx is passed to the function which passes that context
    // to the modalbottomsheet then it starts building that sheet that slides in
    // and to that builder it gives its own context but for now we don't need
    // for this case.
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
          //GestureDetector(
          //   onTap: () {},
          // behavior: HitTestBehavior.opaque,
          // )
        });
  }

  void _deleteTransaction(String id) {
    // _userTransactions.removeWhere((tx) {
    //   return tx.id == id;
    // });
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  // creating a builder method to return widget in order to make code or widget
  // tree more clean and readable
  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show Chart'),
          // adaptive adapts w.r.t platform i.e. android, ios etc.
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              // Created a variable named appBar to store appBar widget and
              // deducted appBar height size and status bar height size
              // to calculate the remaining portion of screen.
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        // Created a variable named appBar to store appBar widget and
        // deducted appBar height size and status bar height size
        // to calculate the remaining portion of screen.
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      // action is an argument that can display list of widgets in a row.
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
      title: Text(
        'Personal Expenses',
        // style: TextStyle(fontFamily: 'Open Sans'),
      ),
    );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return /* Platform.isIOS
        ? CupertinoPageScaffold()
        : */
        Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLandscape)
                ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
              if (!_isLandscape)
                // ... is called spread operator. It is used in front of list.
                // Here, it is used since we are passing list inside of the
                // list of widgets, so using this operator we can pull elements
                // out of the list and merge them as single elements into the
                // surrounding list. For eg: here column takes list of childrens
                // and this _buildPortraitContent method returns a list.
                // So in this case the list that this method returns are pulled
                // outside of the list and as single elements next to eachother
                // in the outer list i.e. column's lists.
                ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
    );
  }
}
