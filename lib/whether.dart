import 'dart:convert';
import 'package:intl/intl.dart';
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
  TextEditingController tec=TextEditingController();
  String city='';
  @override
  void initState() {
    super.initState();
    city = 'Bhopal'; // Assign an initial value
    tec.text = 'Bhopal'; // Set initial value to the TextField
  }
  void updateValue() {
    setState(() {
      city = tec.text;
    });
  }
  Future getCurrentWeather() async{
       try{
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
        title: const Text('Weather App',
          style: TextStyle(
          fontWeight: FontWeight.w500,
        ),),
        actions: [IconButton(
             icon: Icon(Icons.refresh_rounded),
          onPressed: (){

          },
        )],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

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
              TextField(
                controller: tec,
                style: const TextStyle(
                 color: Colors.white,
                 ),
            decoration: InputDecoration(
              hintText: 'Search city weather',
              hintStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              fillColor: Colors.black,
              filled: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: (){
                  setState(() {
                    updateValue();
                  });
                },
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),

          ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                 child:Card(
                   elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('${curtemp.toString()} K',
            style: const TextStyle(
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
              const Text("Weather Forcast",style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,

              )),
              SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(

                  children: [
                     for(int i=0;i<8;i++)
                     SizedBox(
                width: 100,

                       child: Card(
                         elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(

                              children: [
                                  Text(DateFormat.j().format(DateTime.parse(data['list'][i+1]['dt_txt'])),
                                      style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                                  SizedBox(height: 10,),
                                  Icon(data['list'][i+1]['weather'][0]['main']=='Clouds'
                                      || data['list'][i+1]['weather'][0]['main']=='Rain'
                                      ?Icons.cloud:Icons.sunny, size: 20,),
                                  SizedBox(height: 10,),
                                  Text('${data['list'][i+1]['main']['temp'].toString()} K'),


                              ],
                            ),
                          ),
                        ),
                     )],
                ),
              ),

              SizedBox(height: 12,),
              const Text("Additinal Information",style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,

              )),
              SizedBox(height: 16,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [

                      const Icon(Icons.water_drop,size:20),
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
                      Text(pressure.toString(),style: const TextStyle(
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
                      Text(wspeed.toString(),style: const TextStyle(
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
