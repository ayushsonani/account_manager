import 'package:accountmamager/database_controler.dart';
import 'package:accountmamager/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'credit_and_debit_antry.dart';

class DashBoard extends StatefulWidget {
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // const DashBoard({super.key});
  @override
  List<String> tables = [];

  TextEditingController account_name = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatabase();
  }

  getdatabase() async {
    String database_path = await getDatabasesPath();
    data.path = join(database_path, "AccountManager.db");
    data.database = await openDatabase(
      data.path,
      version: 1,
      onConfigure: (db) {},
      onCreate: (db, version) {
        db.execute(
            "create table accounts (id integer primary key autoincrement, name text, credit double, debit double,balance double)");
        // db.execute("create table Total_balance (id integer primary key autoincrement,)");
        db
            .execute(
                "create table user_account_entry (id integer primary key autoincrement,account_name text,date text,particular text,credit double,debit double) ;")
            .then((value) {
          print("table successfully created....");
        });
      },
    );
    getdatabase_datas();
  }

  getdatabase_datas() async {
    print(
        ' accounts table data:= ${data.database!.rawQuery("select * from accounts")}');
    data.accounts_table =
        await data.database!.rawQuery("select * from accounts");
    print("accounts tables  := ${data.accounts_table}");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("Dashboard",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          actions: [
            Icon(Icons.search),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.more_vert),
          ],
        ),
        body: ListView.builder(
          itemCount: data.accounts_table.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AccountInsertData(
                          data.accounts_table[index]['name']);
                    },
                  ));
                },
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ListTile(
                      leading: Text("${data.accounts_table[index]['name']}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      trailing: Wrap(children: [
                        IconButton(
                            onPressed: () async {
                              account_name.text =
                                  data.accounts_table[index]['name'];
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Account Name"),
                                    content: TextField(
                                        controller: account_name,
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Colors.orange,
                                            )),
                                            labelStyle:
                                                TextStyle(color: Colors.orange),
                                            labelText: "Account Name")),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            await data.database?.rawUpdate(
                                                "update user_account_entry set name = '${account_name.text}' where name='${data.accounts_table[index]['name']}'");
                                            await data.database
                                                ?.rawUpdate(
                                                    "update accounts set name = '${account_name.text}' where id = '${data.accounts_table[index]['id']}'")
                                                .then((value) {
                                              print(
                                                  "data successfully updated....");
                                            });
                                            getdatabase_datas();
                                            account_name.clear();
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: Text("SAVE"))
                                    ],
                                  );
                                },
                              );
                              account_name.clear();
                            },
                            icon: Icon(Icons.edit)),
                        SizedBox(width: 15),
                        IconButton(
                            onPressed: () {
                              data.database?.rawDelete(
                                  "delete from accounts where id='${data.accounts_table[index]['id']}'");
                              getdatabase_datas();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ]),
                    ),
                    Row(
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
                          child: Text(
                              "Credit() \n ₹${data.accounts_table[index]['credit']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 3.7,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Text(
                              "Debit() \n ₹${data.accounts_table[index]['debit']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 3.7,
                          decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Text(
                              "Balance() \n ₹${data.accounts_table[index]['balance']}",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Account Name"),
                    content: TextField(
                        controller: account_name,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.orange,
                            )),
                            labelStyle: TextStyle(color: Colors.orange),
                            labelText: "Account Name")),
                    actions: [
                      ElevatedButton(
                          onPressed: () async {
                            data.database
                                ?.rawInsert(
                                    "insert into accounts values(null,'${account_name.text}',0.0,0.0,0.0)")
                                .then((value) {
                              print("data successfully data inserted....");
                            });
                            getdatabase_datas();
                            account_name.clear();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text("SAVE"))
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add)),
        drawer: Drawer(),
      ),
    );
  }
}
