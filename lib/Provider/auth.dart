import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Models/httpdeleteerror.dart';


class Auth with ChangeNotifier {
  String _token;
  DateTime expiryTime;
  String _userId;
  Timer authTimer;
  bool isAuthenticated(){
    return token!=null;
  }
  String get token{
    if(_token!=null && expiryTime!=null && expiryTime.isAfter(DateTime.now())){
      return _token;
    }
    return null;
  }
  String get UserId{
    return _userId;
  }
  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBysIOGxfzzLnz-Zc1lEZFn52tbt-mLOb0');
    try{
    final response=await http.post(url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    var responseBody=jsonDecode(response.body);
    if(responseBody['error']!=null){
      throw HttpDeleteException(responseBody['error']['message']);
    }
    _token=responseBody['idToken'];
    _userId=responseBody['localId'];
    expiryTime=DateTime.now().add(Duration(seconds: int.parse(responseBody['expiresIn'])));
    final prefs=await SharedPreferences.getInstance();
    final data=jsonEncode({'token':_token,'userId':_userId,'expiryTime':expiryTime});
    prefs.setString('userData',data);
    autoLogout();
    notifyListeners();
    }
    catch(error){
      throw error;
    }
  }
  Future<void> login(String email,String password) async{
    final url=Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBysIOGxfzzLnz-Zc1lEZFn52tbt-mLOb0');
    try{
    final response=await http.post(url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    var responseBody=jsonDecode(response.body);
    if(responseBody['error']!=null){
      throw HttpDeleteException(responseBody['error']['message']);
    }
     _token=responseBody['idToken'];
     _userId=responseBody['localId'];
    expiryTime=DateTime.now().add(Duration(seconds: int.parse(responseBody['expiresIn'])));
    final prefs=await SharedPreferences.getInstance();
    final data=jsonEncode({'token':_token,'userId':_userId,'expiryTime':expiryTime.toIso8601String()});
    prefs.setString('userData',data);
    autoLogout();
    notifyListeners();
  }
  catch(error){
    throw error;
  }
}
Future<void> logout() async{
  _token=null;
  _userId=null;
  if(authTimer!=null){
    authTimer.cancel();
    authTimer=null;
  }
  final prefs=await SharedPreferences.getInstance();
  prefs.clear();
  notifyListeners(); 
}
Future<bool> tryAutoLogin()async{
  final prefs=await SharedPreferences.getInstance();
  if(!prefs.containsKey('userData')){
     return false;   
  }
  final extractedData=jsonDecode(prefs.getString('userData')) as Map<String,Object>;
  final expiryyTime=DateTime.parse(extractedData['expiryTime']);
  if(expiryyTime.isAfter(DateTime.now())){
    return false;
  }
  _token=extractedData['token'];
  _userId=extractedData['userId'];
  expiryTime=expiryyTime;
  print(_token);
  notifyListeners();
  return true;
}
void autoLogout(){
  if(authTimer!=null){
    authTimer.cancel();
  }
  int expiry=expiryTime.difference(DateTime.now()).inSeconds;
  authTimer=Timer(Duration(seconds:expiry),logout);
}
}