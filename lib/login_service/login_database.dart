import 'package:mongo_dart/mongo_dart.dart';
import 'users.dart';

class MongoDatabase {
  late Db _db;
  final String connectionString =
      'mongodb+srv://tunatezcann:twisterxx29@cluster0.mongodb.net/test?retryWrites=true&w=majority&dbname=basriyebastim';

  MongoDatabase() {
    init();
  }

  Future<void> init() async {
    _db = Db(connectionString);
    await openConnection();
  }

  Future<void> openConnection() async {
    await _db.open();
    print("Connected to MongoDB");
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  Future<void> insertUser(
    String username,
    String password,
    String email,
  ) async {
    final collection = _db.collection('users');
    UserData newUser =
        UserData(username: username, email: email, password: password);
    await collection.insertOne(newUser.toJson());
  }

  Future<Map<String, dynamic>?> findUserByUsername(String username) async {
    final collection = _db.collection('users');

    final result =
        await collection.find(where.eq('username', username)).toList();

    return result.isNotEmpty ? result[0] : null;
  }
}
