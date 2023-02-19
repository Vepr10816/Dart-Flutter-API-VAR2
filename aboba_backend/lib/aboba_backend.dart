import 'dart:io';

import 'package:aboba_backend/controllers/app_auth_controller.dart';
import 'package:aboba_backend/controllers/app_financedata_controller.dart';
import 'package:aboba_backend/controllers/app_financedata_history_controller.dart';
import 'package:aboba_backend/controllers/app_token_controller.dart';
import 'package:aboba_backend/controllers/app_user_controller.dart';
import 'package:conduit/conduit.dart';
import 'package:aboba_backend/model/categories.dart';
import 'package:aboba_backend/model/financeData.dart';
import 'package:aboba_backend/model/user.dart';
import 'package:aboba_backend/model/financeData_history.dart';

class AppService extends ApplicationChannel{
  late final ManagedContext managedContext;
  @override
  Future prepare(){
    final persistentStore = _initDataBase();
    managedContext = ManagedContext(ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }
  @override
  Controller get entryPoint =>Router()
  ..route('token/[:refresh]').link(
    () => AppAuthController(managedContext),
  )
  ..route('user')
        .link(AppTokenController.new)!
        .link(() => AppUserController(managedContext))
  
  ..route('finance/[:id]')
        .link(AppTokenController.new)!
        .link(() => AppFinanceDataController(managedContext))
  ..route('history')
        .link(AppTokenController.new)!
        .link(() => AppFinanceDataHistoryController(managedContext));
  
  PersistentStore _initDataBase(){
    final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? '3785';
     final host = Platform.environment['DB_HOST'] ?? '127.0.0.1';
      final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
       final databaseName = Platform.environment['DB_NAME'] ?? 'postgres';
       return PostgreSQLPersistentStore(username, password, host, port, databaseName);

  }
}
