import 'package:user_profile/service/database/sqlite_db.dart';
import 'package:user_profile/service/model/user_details.dart';

class DataBase {
  DataBase._internal();
  static DataBase instance = DataBase._internal();

  Future<bool> insertData(UserDetails userDetails) async {
    try {
      UserDetails i =
          await TransactionDetailDataBase.instance.create(userDetails);
    } catch (e) {
      print('-------$e');
      return false;
    }
    return true;
  }

  Future<List<UserDetails>> getData() async {
    List<UserDetails> list = [];

    List<UserDetails> totalList = [
      UserDetails(
          email: 'abc',
          imagePath: '',
          mobile: '1234567890',
          password: 'sasa',
          userId: 10,
          userName: 'ada'),
      UserDetails(
          email: 'abssc',
          imagePath: '',
          mobile: '1234567892',
          password: 'sasa',
          userId: 11,
          userName: 'adarsh'),
    ];

    list = await TransactionDetailDataBase.instance.readAllDocuments();

    list.addAll(totalList);

    for (UserDetails i in list) {
      print(i.toJson());
    }
    list.removeWhere(
        (element) => element.email.isEmpty && element.mobile.isEmpty);
    return list;
  }
}
