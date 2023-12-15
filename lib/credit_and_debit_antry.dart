import 'package:accountmamager/database_controler.dart';
import 'package:accountmamager/main.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'desh_board_page.dart';

class AccountInsertData extends StatefulWidget {
  String account_name;

  AccountInsertData(this.account_name);

  @override
  State<AccountInsertData> createState() => _AccountInsertDataState();
}

class _AccountInsertDataState extends State<AccountInsertData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = TextEditingController(
        text: "${dateTime.day}/${dateTime.month}/${dateTime.year}");
    get_user_input_data();
  }

  DateTime dateTime = DateTime.now();

  TextEditingController date = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController particular = TextEditingController();

  double credit = 0;
  double debit = 0;

  bool? tran_sion;

  List account_name_data = [];

  get_user_input_data() async {
    account_name_data = await data.database!.rawQuery(
        "select * from user_account_entry where account_name='${widget.account_name}'");

    print("table data := ${data.accounts_table}");
    // print("account data := $account_name_data");
    col = List.filled(account_name_data.length, null);

    for (int i = 0; i < account_name_data.length; i++) {
      if (account_name_data[i]['credit'] != 0.0) {
        col[i] = Colors.green;
      } else {
        col[i] = Colors.red;
      }
    }
    await total_balance_count();
    total_balance = total_credit - total_debit;
    print("total credit := ${total_credit}");
    print("total debit := ${total_debit}");
    print("total balance := ${total_balance}");
    data.database!.rawUpdate("update accounts set credit = ${total_credit},debit = ${total_debit},balance = ${total_balance} where name = '${widget.account_name}'");

    setState(() {});
  }

  double total_credit = 0;
  double total_debit = 0;
  double total_balance = 0;

  total_balance_count() {
    total_credit = 0;
    total_debit = 0;

    for(int i=0; i<account_name_data.length; i++){
      total_credit = total_credit + account_name_data[i]['credit'];
      total_debit = total_debit + account_name_data[i]['debit'];
    }

  }

  List col = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        showDialog(context: context, builder:
        (context) {
          return AlertDialog(
            title: Text(" exit your account "),
            actions: [
              ElevatedButton(onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return DashBoard();
                },));
              }, child: Text("exit account"))
            ],
          );
        },);
        return true;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("${widget.account_name}",
              style: TextStyle(color: Colors.white, fontSize: 25)),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState1) {
                          return AlertDialog(
                            scrollable: true,
                            // elevation:300,
                            contentPadding: EdgeInsets.all(5),
                            titlePadding: EdgeInsets.all(0),
                            titleTextStyle: TextStyle(fontSize: 25),
                            title: Container(
                              width: 100,
                              height: 50,
                              alignment: Alignment.center,
                              color: Colors.deepPurple,
                              child: Text("Setting", textAlign: TextAlign.center),
                              margin: EdgeInsets.all(0),
                            ),
                            content: Container(
                              child: Column(children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: "date",
                                    labelStyle: TextStyle(color: Colors.orange),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.orange)),
                                  ),
                                  controller: date,
                                  onTap: () async {
                                    dateTime = (await showDatePicker(
                                        context: context,
                                        initialDate: dateTime,
                                        firstDate: DateTime(2005),
                                        lastDate: DateTime(2050))) as DateTime;
                                    date.text =
                                        "${dateTime.day}/${dateTime.month}/${dateTime.year}";
                                    print("date is := ${date.text}");
                                    setState(() {});
                                    setState1(() {});
                                  },
                                ),
                                Row(
                                  children: [
                                    Text("Transaction type :",
                                        style: TextStyle(fontSize: 10)),
                                    Radio(
                                      activeColor: Colors.deepPurple,
                                      value: true,
                                      groupValue: tran_sion,
                                      onChanged: (value) {
                                        tran_sion = value;
                                        setState(() {});
                                        setState1(() {});
                                      },
                                    ),
                                    Text("Credit(+)",
                                        style: TextStyle(fontSize: 10)),
                                    Radio(
                                      activeColor: Colors.deepPurple,
                                      value: false,
                                      groupValue: tran_sion,
                                      onChanged: (value) {
                                        tran_sion = value;
                                        setState(() {});
                                        setState1(() {});
                                      },
                                    ),
                                    Text("debit(-)",
                                        style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                                TextField(
                                  controller: amount,
                                  decoration: InputDecoration(
                                      labelText: "Amount",
                                      labelStyle: TextStyle(color: Colors.orange),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.orange))),
                                ),
                                TextField(
                                  controller: particular,
                                  decoration: InputDecoration(
                                      labelText: "Particular",
                                      labelStyle: TextStyle(color: Colors.orange),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.orange))),
                                ),
                              ]),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 15,
                                  width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(color: Colors.deepPurple)),
                                  alignment: Alignment.center,
                                  child: Text("CANCEL",
                                      style: TextStyle(color: Colors.deepPurple)),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (tran_sion!) {
                                    credit = double.parse("${amount.text}");
                                  } else {
                                    debit = double.parse("${amount.text}");
                                  }

                                  await data.database!
                                      .rawInsert(
                                          "insert into user_account_entry values(null,'${widget.account_name}','${date.text}','${particular.text}',$credit,$debit)")
                                      .then((value) {
                                    print("data successfully inserted.....");
                                    get_user_input_data();
                                    amount.clear();
                                    particular.clear();
                                    credit = 0;
                                    debit = 0;
                                    Navigator.pop(context);
                                  });
                                  total_balance_count();
                                  total_balance = total_credit - total_debit;
                                  print("total credit := ${total_credit}");
                                  print("total debit := ${total_debit}");
                                  print("total balance := ${total_balance}");
                                  data.database!.rawUpdate("update accounts set credit = ${total_credit},debit = ${total_debit},balance = ${total_balance} where name = '${widget.account_name}'");

                                  setState(() {});
                                  setState1(() {});
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 15,
                                  width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("ADD",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                icon: Icon(Icons.add)),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 50,
                            maxWidth: MediaQuery.of(context).size.width / 4,
                            maxHeight: MediaQuery.of(context).size.height / 14),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text("Date",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700))),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 50,
                            maxWidth: MediaQuery.of(context).size.width / 4,
                            maxHeight: MediaQuery.of(context).size.height / 14),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("Perticular",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 50,
                            maxWidth: MediaQuery.of(context).size.width / 5,
                            maxHeight: MediaQuery.of(context).size.height / 10),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("Credit(+)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 50,
                            maxWidth: MediaQuery.of(context).size.width / 5,
                            maxHeight: MediaQuery.of(context).size.height / 14),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("debit",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 14,
              child: Container(
                child: ListView.builder(
                  itemCount: account_name_data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      color: ((index % 2) == 1) ? Colors.white : Colors.black12,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width / 4,
                                maxHeight:
                                    MediaQuery.of(context).size.height / 14),
                            child: Container(
                                alignment: Alignment.center,
                                child: Text("${account_name_data[index]['date']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: col[index]))),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width / 4,
                                maxHeight:
                                    MediaQuery.of(context).size.height / 14),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                  "${account_name_data[index]['particular']}",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 18, color: col[index])),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width / 5,
                                maxHeight:
                                    MediaQuery.of(context).size.height / 10),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("${account_name_data[index]['credit']}",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 18, color: col[index])),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width / 5,
                                maxHeight:
                                    MediaQuery.of(context).size.height / 14),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("${account_name_data[index]['debit']}",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 18, color: col[index])),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 9,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 3.7,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Text("Credit() \n ₹${total_credit}"),
              ),
              Container(
                margin: EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 3.7,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Text("Debit() \n ₹${total_debit}"),
              ),
              Container(
                margin: EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 3.7,
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Text("Balance() \n ₹${total_balance}",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
