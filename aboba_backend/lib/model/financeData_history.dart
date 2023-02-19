import 'package:conduit/conduit.dart';
import 'user.dart';
import 'categories.dart';

class financeData_history extends ManagedObject<_financeData_history> implements _financeData_history {}
class _financeData_history 
{

  @Column(indexed: true)
  int? idFinance;
  @Column(indexed: true)
  String? operationName;
  @Column(indexed: true)
  String? description;
  @Column(indexed: true)
  DateTime? operationDate;
  @Column(indexed: true)
  double? operationTotal;
  @Column(indexed: true)
  bool isDeleted = false;
  @Column(indexed: true)
  int? idUser;
  @Column(indexed: true)
  int? idCategory;
  @primaryKey
  int? id;
}