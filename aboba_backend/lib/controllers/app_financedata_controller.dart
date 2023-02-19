import 'dart:io';

import 'package:aboba_backend/model/financeData.dart';
import 'package:conduit/conduit.dart';

import 'package:aboba_backend/model/model_response.dart';
import 'package:aboba_backend/utils/app_response.dart';
import 'package:aboba_backend/utils/app_utils.dart';


class AppFinanceDataController extends ResourceController {
  AppFinanceDataController(this.managedContext);

  final ManagedContext managedContext;
  @Operation.post()
  Future<Response> createFinanceData(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.query('operationName') String operationName,
      @Bind.query('description') String description,
      @Bind.query('operationDate') DateTime operationDate,
      @Bind.query('operationTotal') double operationTotal,
      @Bind.query('category') int category) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final qCreateFinanceData = Query<financeData>(managedContext)
        ..values.operationName = operationName
        ..values.description = description
        ..values.operationDate = operationDate
        ..values.operationTotal = operationTotal
        ..values.isDeleted = false
        ..values.user!.id = id
        ..values.category!.ID_Category = category;
      await qCreateFinanceData.insert();
      return AppResponse.ok(message: 'Успешное создание финансового отчета');
    } catch (error) {
      return AppResponse.serverError(error, message: 'Ошибка создания финансового отчета');
    }
  }

  @Operation.get()
  Future<Response> getFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.query("page") int page,
    
  ) async {
    try {
      final id = AppUtils.getIdFromHeader(header);

      final qCreateFinanceData = Query<financeData>(managedContext)
        ..where((x) => x.user!.id).equalTo(id)
        ..where((x) => x.isDeleted).equalTo(false)
        ..fetchLimit = 3
        ..offset = (page-1) * 20;

      final List<financeData> list = await qCreateFinanceData.fetch();

      if (list.isEmpty)
      {
        return Response.notFound(body: ModelResponse(data: [], message: "Нет ни одной записи по финансам"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

    @Operation.get("id")
  Future<Response> getFinanceDataFromID(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path('id') int id,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final finData = await managedContext.fetchObjectWithID<financeData>(id);
      if (finData == null) {
        return AppResponse.ok(message: "Финансовая запись не найдена");
      }
      if (finData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к финансовой записи");
      }
      finData.backing.removeProperty("user");
      return Response.ok(finData);
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка получения финансовой записи");
    }
  }

  @Operation.put('id')
  Future<Response> updateFinanceData(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id,
      @Bind.query('operationName') String operationName,
      @Bind.query('description') String description,
      @Bind.query('operationDate') DateTime operationDate,
      @Bind.query('isDeleted') bool isDeleted,
      @Bind.query('operationTotal') double operationTotal,
      @Bind.query('category') int category) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final finData = await managedContext.fetchObjectWithID<financeData>(id);
      if (finData == null) {
        return AppResponse.ok(message: "Финансовая запись не найдена");
      }
      if (finData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к финансовой записи");
      }
      final qUpdateFinanceData = Query<financeData>(managedContext)
        ..where((x) => x.ID_OperationNumber).equalTo(id)
        ..values.operationName = operationName
        ..values.description = description
        ..values.operationDate = operationDate
        ..values.operationTotal = operationTotal
        ..values.isDeleted = isDeleted
        ..values.user!.id = currentUserId
        ..values.category!.ID_Category = category;
      await qUpdateFinanceData.update();
      return AppResponse.ok(message: 'Финансовая запись успешно обновлена');
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.put()
  Future<Response> returnLogicalFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final qDeleteLogicalFinanceData = Query<financeData>(managedContext)
        ..where((x) => x.isDeleted).equalTo(true)
        ..where((x) => x.user!.id).equalTo(currentUserId)
        ..values.isDeleted = false;
      await qDeleteLogicalFinanceData.update();
      return AppResponse.ok(message: "Успешное логическое восстановление финансовых записей");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка логического удаления или восстановления финансовой записи");
    }
  }



  @Operation.delete("id")
  Future<Response> deleteFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final finData = await managedContext.fetchObjectWithID<financeData>(id);
      if (finData == null) {
        return AppResponse.ok(message: "Финансовая запись не найдена");
      }
      if (finData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к финансовой записи");
      }
      final qDeleteFinanceData = Query<financeData>(managedContext)
        ..where((x) => x.ID_OperationNumber).equalTo(id);
      await qDeleteFinanceData.delete();
      return AppResponse.ok(message: "Успешное удаление финансовой записи");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка удаления финансовой записи");
    }
  }
  // Future<Response> deleteLogicalFinanceData(
  //   @Bind.header(HttpHeaders.authorizationHeader) String header,
  //   @Bind.path("id") int id,
  //   @Bind.query('isDeleted') bool isDeleted,
  // ) async {
  //   try {
  //     final currentUserId = AppUtils.getIdFromHeader(header);
  //     final finData = await managedContext.fetchObjectWithID<financeData>(id);
  //     if (finData == null) {
  //       return AppResponse.ok(message: "Финансовая запись не найден");
  //     }
  //     if (finData.user?.id != currentUserId) {
  //       return AppResponse.ok(message: "Нет доступа к финансовой записи :(");
  //     }
  //     final qDeleteLogicalFinanceData = Query<financeData>(managedContext)
  //       ..where((x) => x.ID_OperationNumber).equalTo(id)
  //       ..values.isDeleted = isDeleted;
  //     await qDeleteLogicalFinanceData.update();
  //     return AppResponse.ok(message: "Успешное логическое удаление финансовой записи");
  //   } catch (error) {
  //     return AppResponse.serverError(error, message: "Ошибка логического удаления финансовой записи");
  //   }
  // }
}