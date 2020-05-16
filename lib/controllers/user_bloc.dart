import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _errorController = BehaviorSubject<String>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<String> get outError => _errorController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  Map<String, dynamic> user;

  Map<String, dynamic> unsavedData;

  UserBloc({this.user}) {
    unsavedData = user;
    _createdController.add(true);
    _dataController.add(unsavedData);
  }

  void saveName(String name) {
    unsavedData["name"] = name;
  }

  void saveEmail(String email) {
    unsavedData["email"] = email;
  }

  void saveAddress(String address) {
    unsavedData["address"] = address;
  }

  void savePhone1(String phone1) {
    unsavedData["phone1"] = phone1;
  }

  void savePhone2(String phone1) {
    unsavedData["phone2"] = phone1;
  }

  void saveCep(String cep) {
    unsavedData["cep"] = cep;
  }

  void saveCity(var city) {
    unsavedData["city"] = city;
  }

  void saveDistrict(var district) {
    unsavedData["district"] = district;
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
    _errorController.close();
  }
}
