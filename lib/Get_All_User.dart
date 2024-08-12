import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'GetById.dart';

import 'User_model.dart';

class Getall extends StatefulWidget {
  const Getall({super.key});

  @override
  State<Getall> createState() => _GetallState();
}

class _GetallState extends State<Getall> {


  void initState(){
    super.initState();
    loadUsers();
  }

  Future<List<Users>> loadUsers() async {
    setState(() {
    });
      var res = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      var data = jsonDecode(res.body);
      print(data);
      return (data as List).map((e) => Users.fromJson(e)).toList();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users",style: TextStyle(fontSize: 30),),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: loadUsers(),
              builder: (BuildContext context, snapshot){
                if(snapshot.hasData){
                  List<Users> list = snapshot.data!;// I assign the data into the list(variable)
                  return Container(
                    height: 900,
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => getSingle(id: list[index].id!,)));
                            },
                            child: Card(
                              borderOnForeground: true,
                              color: Colors.grey,
                              elevation: 20.0,
                              shadowColor: Colors.grey,
                              child: ListTile(
                                title: Column(
                                  children: [
                                    Text("ID:${list[index].id!.toString()}",style: TextStyle(color: Colors.red,fontSize: 25)),
                                    Text("Name:${list[index].name!.toString()}"),
                                    Text("UserName:${list[index].username!.toString()}"),
                                    Text("Email:${list[index].email!.toString()}"),
                                    Text("Street:${list[index].address!.street.toString()}"),
                                    Text("Suite:${list[index].address!.suite.toString()}"),
                                    Text("City:${list[index].address!.city.toString()}"),
                                    Text("ZipCode:${list[index].address!.zipcode.toString()}"),
                                    Text("Latitude:${list[index].address!.geo!.lat.toString()}"),
                                    Text("Longitude:${list[index].address!.geo!.lng.toString()}"),
                                    Text("Phone:${list[index].phone!.toString()}"),
                                    Text("Website:${list[index].website!.toString()}"),
                                    Text("Company Name:${list[index].company!.name!.toString()}"),
                                    Text("Company CatchPhrase:${list[index].company!.catchPhrase!.toString()}"),
                                    Text("Company bs:${list[index].company!.bs!.toString()}"),


                                  ],
                                ),

                              ),
                            ),
                          );
                        }
                    ),
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
