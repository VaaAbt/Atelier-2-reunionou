import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/connexion.dart';
import 'package:mobile_app/models/events.dart';
import 'package:mobile_app/models/eventDetail.dart';

var ip = "192.168.42.55:8082";


var dataEventDetails;

class DataMethodes {
  
  Future<Connexion> postConnexion(String? dataTokenAuth, String? dataId, String? dataMdp) async{
    final response = await http.post(
      Uri.parse('http://$ip/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding' : 'gzip, deflate, br',
        'authorization': 'Basic '+ base64Encode(utf8.encode('$dataId:$dataMdp'))
      },
    );

    if (response.statusCode == 200) {
      var res = Connexion.fromJson(jsonDecode(response.body));
      dataTokenAuth = res.token;
      return res;
    } else {
      throw Exception('Failed to get token');
    }
  }

  checkConnection(String? dataTokenAuth) {
    if (dataTokenAuth != null){
      return true;
    }else {
      return false;
    }
  }

  getUserCredentials(String? dataTokenAuth, String? dataId, String? dataMdp) {
    if (checkConnection(dataTokenAuth)){
      return {dataId,dataMdp};
    }
  }

  Future<Events> getUserEvents(String? dataTokenAuth) async{

    var dataEventList;

    final response = await http.get(
      Uri.parse('http://$ip/events'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding' : 'gzip, deflate, br',
        'authorization': 'Bearer $dataTokenAuth'
      },
    );

    if (response.statusCode == 200) {
      var res = Events.fromJson(jsonDecode(response.body));
      dataEventList = res.events;
      return res;
    } else {
      throw Exception('Failed to get events');
    }
  }

  Future<EventDetail> getEventDetails(String? id, String? dataTokenAuth) async{
    final response = await http.post(
      Uri.parse('http://$ip/events/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding' : 'gzip, deflate, br',
        'authorization': 'Bearer '+ dataTokenAuth!,
      },
    );

    if (response.statusCode == 200) {
      var res = EventDetail.fromJson(jsonDecode(response.body));
      dataEventDetails = res.eventDetail;
      return res;
    } else {
      throw Exception('Failed to get event details');
    }
  }

  Future<EventDetail> createEvent(String? titre,String? description,String? date,String?heure,String? lieu, String? dataTokenAuth) async{
    final response = await http.post(
      Uri.parse('http://$ip/events/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding' : 'gzip, deflate, br',
        'authorization': 'Bearer '+ dataTokenAuth!,
      },
      body: <String, String>{
        'titre': titre!,
        'description': description!,
        'date': date!,
        'heure': heure!,
        'lieu': lieu!
      }
    );

    if (response.statusCode == 200) {
      var res = EventDetail.fromJson(jsonDecode(response.body));
      dataEventDetails = res.eventDetail;
      return res;
    } else {
      throw Exception('Failed to create new event');
    }
  }

  String? disconnectUser(String? dataTokenAuth) {
    if (checkConnection(dataTokenAuth!)){
      dataTokenAuth = "";
      return dataTokenAuth;
    }
  }
}