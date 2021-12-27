// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../database/database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CartItemDao? _cartItemDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CartItem` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `price` REAL NOT NULL, `count` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CartItemDao get cartItemDao {
    return _cartItemDaoInstance ??= _$CartItemDao(database, changeListener);
  }
}

class _$CartItemDao extends CartItemDao {
  _$CartItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cartItemInsertionAdapter = InsertionAdapter(
            database,
            'CartItem',
            (CartItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'count': item.count
                }),
        _cartItemUpdateAdapter = UpdateAdapter(
            database,
            'CartItem',
            ['id'],
            (CartItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'count': item.count
                }),
        _cartItemDeletionAdapter = DeletionAdapter(
            database,
            'CartItem',
            ['id'],
            (CartItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'count': item.count
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CartItem> _cartItemInsertionAdapter;

  final UpdateAdapter<CartItem> _cartItemUpdateAdapter;

  final DeletionAdapter<CartItem> _cartItemDeletionAdapter;

  @override
  Future<List<CartItem>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM CartItem',
        mapper: (Map<String, Object?> row) => CartItem(
            id: row['id'] as String,
            name: row['name'] as String,
            price: row['price'] as double,
            count: row['count'] as int));
  }

  @override
  Future<CartItem?> findItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM CartItem WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CartItem(
            id: row['id'] as String,
            name: row['name'] as String,
            price: row['price'] as double,
            count: row['count'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllItems() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CartItem');
  }

  @override
  Future<void> insertItem(CartItem item) async {
    await _cartItemInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItem(CartItem item) {
    return _cartItemUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteItem(CartItem item) {
    return _cartItemDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}
