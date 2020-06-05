import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataProvider {
  static Database db;

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
}

  static Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'database23.db'),
        version: 1, onConfigure: _onConfigure, onCreate: (Database db, int version) async {

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
             calorie_intensity float,
             quantity float,
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
//SELECT EXISTS(SELECT * FROM recipes WHERE draft = TRUE)
  static Future getBuildMode() async {
    if (db == null) {
       await open();
    }
     //var result = await db.rawQuery('''SELECT SUM(id) FROM recipes;''');
    var result = await db.rawQuery('''SELECT EXISTS(SELECT * FROM recipes WHERE draft = TRUE);''');
    return result[0]["EXISTS(SELECT * FROM recipes WHERE draft = TRUE)"];
  }

    static Future getRecipeMax() async {
    if (db == null) {
       await open();
    }
     //var result = await db.rawQuery('''SELECT SUM(id) FROM recipes;''');
    var result = await db.rawQuery('''SELECT MAX(id) FROM recipes;''');
    return result[0]["MAX(id)"];
  }

    static Future deleteRecipe(int id) async {
    await db.delete('Recipes', where: 'id = ?', whereArgs: [id]);
  }

    static Future<List<Map<String, dynamic>>> getRecipeNameFromId(recipeid) async {
    if (db == null) {
      await open();
    }
    //return await db.query('Ingredients'); WHERE draft = TRUE'''
    var result= await db.rawQuery('''SELECT * FROM recipes
    WHERE id =?''',[recipeid]);
    return result[0]['name'];
  }

  static Future<List<Map<String, dynamic>>> getCompareRecipeIngredientsList(recipeid,comparerecipeid) async {
    if (db == null) {
      await open();
    }
    //return await db.query('Ingredients'); WHERE draft = TRUE'''
    return await db.rawQuery('''SELECT * FROM Ingredients
    WHERE recipe_id =?
    OR recipe_id =?''',[recipeid,comparerecipeid]);
  }

  static Future updateRecipe(Map<String, dynamic> recipe) async {
    await db.update('recipes', recipe, where: 'id = ?', whereArgs: [recipe['id']]);
  }

}
