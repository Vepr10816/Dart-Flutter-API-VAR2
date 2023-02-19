import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:aboba_backend/model/financeData_history.dart';
import '../model/model_response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppFinanceDataHistoryController extends ResourceController {
  AppFinanceDataHistoryController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getFinanceHistory() 
  async {
    try {

      final qGetFinanceData_history = Query<financeData_history>(managedContext);

      final List<financeData_history> list = await qGetFinanceData_history.fetch();

      if (list.isEmpty)
      {
        return Response.notFound(body: ModelResponse(data: [], message: "Пусто"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

}
