import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataProvider {
  static Database db;

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
}

  static Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'database6.db'),
        version: 1, onConfigure: _onConfigure, onCreate: (Database db, int version) async {

/*
      await db.execute('''
          CREATE TABLE IF NOT EXISTS Ingredients(
            id integer primary key autoincrement,
            title text not null,
            text text not null
          );
        ''');

      await db.execute('''
          CREATE TABLE IF NOT EXISTS Recipes(
            id integer primary key autoincrement,
            title text not null,
            text text not null
       );
       ''');
*/
        await db.execute('''
            CREATE TABLE recipes(
             id integer constraint recipes_pk primary key autoincrement,
             name  varchar(50) not null,
             draft boolean default TRUE not null
           );
         ''');

         await db.execute('''
           CREATE TABLE ingredients(
             id integer not null constraint ingredients_pk primary key autoincrement,
             name  varchar(50),
             carbon_intensity float,
             calorie_intensity integer,
             quantity integer,
             unit varchar(50) default 'g',
             draft boolean default TRUE,
             recipe_id integer references recipes on update cascade on delete cascade
           );
           create unique index recipes_name_uindex on recipes (name);
         ''');
    });
  }

  static Future<List<Map<String, dynamic>>> getIngredientsList() async {
    if (db == null) {
      await open();
    }
    //return await db.query('Ingredients'); WHERE draft = TRUE'''
    return await db.rawQuery('''SELECT * FROM Ingredients
    WHERE draft =?''',[1]);
  }

  static Future insertIngredient(Map<String, dynamic> ingredient) async {
    await db.insert('Ingredients', ingredient);
  }

  static Future updateIngredient(Map<String, dynamic> ingredient) async {
    await db.update('Ingredients', ingredient, where: 'id = ?', whereArgs: [ingredient['id']]);
  }

  static Future deleteIngredient(int id) async {
    await db.delete('Ingredients', where: 'id = ?', whereArgs: [id]);
  }




  static Future insertRecipe(Map<String, dynamic> recipe) async {
    await db.insert('Recipes', recipe);
  }

  static Future<List<Map<String, dynamic>>> getLibraryList() async {
    if (db == null) {
      await open();
    }
    return await db.query('Recipes');
  }

  static Future<List<Map<String, dynamic>>> getRecipeIngredientsList(recipeid) async {
    if (db == null) {
      await open();
    }
    //return await db.query('Ingredients'); WHERE draft = TRUE'''
    return await db.rawQuery('''SELECT * FROM Ingredients
    WHERE recipe_id =?''',[recipeid]);
  }

    static Future deleteRecipe(int id) async {
    await db.delete('Recipes', where: 'id = ?', whereArgs: [id]);
  }
}
