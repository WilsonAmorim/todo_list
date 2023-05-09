import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo_list_provaider/app/core/database/migration/migration.dart';

class MigrationV3 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
      create table teste2(id Integer)
      ''');
  }

  @override
  void update(Batch batch) {
    void create(Batch batch) {
      batch.execute('''
      create table teste2(id Integer)
      ''');
    }
  }
}
