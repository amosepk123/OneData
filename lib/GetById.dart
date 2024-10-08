import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:one_data/Login/login.dart';
import 'Login/auth_service.dart';
import 'User_model.dart';

class getSingle extends StatefulWidget {
  final int id;
  const getSingle({super.key, required this.id});

  @override
  State<getSingle> createState() => _getSingleState();
}

class _getSingleState extends State<getSingle> {
  final auth = AuthService();
  Future<Users> fetch() async {
    final int id = widget.id;
    var res = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users/$id"));
    return Users.fromJson(jsonDecode(res.body));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get_By_Id"),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: fetch(),
              builder: (BuildContext context, snapshot){
                if(snapshot.hasData){
                  final list=snapshot.data!;
                  return Column(
                    children: [
                      Card(
                        borderOnForeground: true,
                        color: Colors.grey,
                        elevation: 20.0,
                        shadowColor: Colors.grey,
                        child: ListTile(
                          title: Column(
                            children: [
                              Text("ID:${list!.id!.toString()}",style: TextStyle(color: Colors.red,fontSize: 25),),
                              Text("Name:${list.name!.toString()}"),
                              Text("UserName:${list.username!.toString()}"),
                              Text("Email:${list.email!.toString()}"),
                              Text("Street:${list.address!.street.toString()}"),
                              Text("Suite:${list.address!.suite.toString()}"),
                              Text("City:${list.address!.city.toString()}"),
                              Text("ZipCode:${list.address!.zipcode.toString()}"),
                              Text("Latitude:${list.address!.geo!.lat.toString()}"),
                              Text("Longitude:${list.address!.geo!.lng.toString()}"),
                              Text("Phone:${list.phone!.toString()}"),
                              Text("Website:${list!.website!.toString()}"),
                              Text("Company Name:${list.company!.name!.toString()}"),
                              Text("Company CatchPhrase:${list.company!.catchPhrase!.toString()}"),
                              Text("Company bs:${list.company!.bs!.toString()}"),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await auth.signout();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                          },
                          child: Text("logout"))
                    ],
                  );
                } else if(snapshot.hasError){
                  return Text("${snapshot.error}");
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 400,),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
          )
        ],
      ),
    );
  }
}
