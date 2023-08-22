import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class whetherScreen extends StatefulWidget {
  const whetherScreen({Key? key}) : super(key: key);

  @override
  State<whetherScreen> createState() => _whetherScreenState();
}

class _whetherScreenState extends State<whetherScreen> {
  @override
  double temp=0;

  Future getCurrentWeather() async{
       try{
      String city='Dabra';
      final res=await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=81787ca181824b568c0414e52507e49a'
      ));
      final data=jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;
  } catch (e) {
  throw e.toString();
  }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App',
          style: TextStyle(
          fontWeight: FontWeight.w500,
        ),),
        actions: [IconButton(
             icon: Icon(Icons.refresh_rounded),
          onPressed: (){
              print("refresh..");
          },
        )],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          // if(snapshot.hasData){
          //   return Center(child: Text('An exception occur !!'));
          // }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final data=snapshot.data!;
          final curtemp=data['list'][0]['main']['temp'];
          final cursky=data['list'][0]['weather'][0]['main'];
          final humidity=data['list'][0]['main']['humidity'];
          final pressure=data['list'][0]['main']['pressure'];
          final wspeed=data['list'][0]['wind']['speed'];
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                 child:Card(
                   elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('${curtemp.toString()} K',
            style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
            ),
                      ),
              SizedBox(height: 15,),
              Icon(cursky=='Clouds'|| cursky=='Rain'?Icons.cloud:Icons.sunny,size: 48,),
              SizedBox(height: 15,),
              Text('${cursky.toString()}',style: TextStyle(
                    fontSize: 20)),

          ],
          ),
                )
              )
              ),

              SizedBox(height: 12,),
              Text("Weather Forcast",style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,

              )),
              SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for(int i=0;i<6;i++)
                     SizedBox(
                width: 100,
                       child: Card(
                         elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [


                                  Text(data['list'][i+1]['dt'].toString(), style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                                  SizedBox(height: 10,),
                                  Icon(data['list'][i+1]['weather'][0]['main']=='Clouds'
                                      || data['list'][i+1]['weather'][0]['main']=='Rain'
                                      ?Icons.cloud:Icons.sunny, size: 20,),
                                  SizedBox(height: 10,),
                                  Text(data['list'][i+1]['main']['temp'].toString()),


                              ],
                            ),
                          ),
                        ),
                     ),



                  ],
                ),
              ),

              SizedBox(height: 12,),
              Text("Additinal Information",style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,

              )),
              SizedBox(height: 16,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [

                      Icon(Icons.water_drop,size:20),
                      SizedBox(height: 10,),
                      Text('Humidity'),
                      SizedBox(height: 10,),
                      Text(humidity.toString(),style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [

                      Icon(Icons.air,size:20),
                      SizedBox(height: 10,),
                      Text('Pressure'),
                      SizedBox(height: 10,),
                      Text(pressure.toString(),style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [

                      Icon(Icons.wind_power,size:20),
                      SizedBox(height: 10,),
                      Text('Wind Speed'),
                      SizedBox(height: 10,),
                      Text(wspeed.toString(),style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                    ],
                  ),
                ],
              )
              ],
          ),


        );
        },
      )
    );
  }
}
