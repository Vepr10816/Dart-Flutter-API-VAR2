import 'package:aboba_backend/aboba_backend.dart' as aboba_backend;
import 'package:aboba_backend/aboba_backend.dart';
import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:aboba_backend/model/categories.dart';
import 'package:aboba_backend/model/financeData.dart';
import 'package:aboba_backend/model/user.dart';
import 'package:aboba_backend/model/financeData_history.dart';

void main(List<String> arguments) async {
  final port = int.parse(Platform.environment["PORT"] ?? '8080');
  final service = Application<AppService>()..options.port=port;
  await service.start(numberOfInstances: 3, consoleLogging: true);
}
