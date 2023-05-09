import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_provaider/app/core/database/Sqlite_Adm_Connection.dart';
import 'package:todo_list_provaider/app/modules/auth/auth_module.dart';
import 'package:todo_list_provaider/app/modules/splash/splash_page.dart';
import 'package:todo_list_provaider/app/modules/ui/todo_list_ui_config.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  var sqliteAdmConnection = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(sqliteAdmConnection);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addObserver(sqliteAdmConnection);
    FirebaseAuth auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list Providere',
      initialRoute: '/login',
      theme: TodoListUiConfig.Theme,
      routes: {...AuthModule().routers},
      home: SplashPage(),
    );
  }
}
