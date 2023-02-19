import 'package:conduit/conduit.dart';
import 'user.dart';
import 'categories.dart';

class financeData extends ManagedObject<_financeData> implements _financeData {}
class _financeData {
  @primaryKey
  int? ID_OperationNumber;
  @Column(indexed: true)
  String? operationName;
  @Column(indexed: true)
  String? description;
  @Column(indexed: true)
  DateTime? operationDate;
  @Column(indexed: true)
  double? operationTotal;
  @Column(indexed: true)
  bool? isDeleted;
  @Relate(#financeList, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
  @Relate(#financeList, isRequired: true, onDelete: DeleteRule.cascade)
  Categories? category;
}