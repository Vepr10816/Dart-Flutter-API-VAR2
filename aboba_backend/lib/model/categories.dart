import 'package:conduit/conduit.dart';
import 'financeData.dart';

class Categories extends ManagedObject<_Categories> implements _Categories {}
class _Categories {
  @primaryKey
  int? ID_Category;
  @Column(unique: true, indexed: true)
  String? categoryName;
ManagedSet<financeData>? financeList;
}