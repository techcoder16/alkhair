import 'package:alkahir/plugins/global.dart';
import 'package:flutter/material.dart';


String assertiveURL =
    base_Url  + "alkhair/storage/app/public/images/distributors/";

List<String> _splitString(String value) {
  var arrayOfString = value.split(',');


  var index = 0;
 arrayOfString.forEach((element) {

   arrayOfString[index] =  assertiveURL +    arrayOfString[index] ;

   index +=1;
 });

  return arrayOfString;
}


Customdialog(BuildContext context,dynamic data, int index)
{




  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    child: dialogContent(context,data,index),
  );

}

Widget dialogContent(BuildContext context,dynamic data,int index) {
  List <String> stringAvatar= _splitString(
      data[index].avatar);


  return Container(
    margin: EdgeInsets.only(left: 0.0,right: 0.0),
    child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 18.0,
          ),
          margin: EdgeInsets.only(top: 13.0,right: 8.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(55, 75, 167, 1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                ),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Name: " + data[index].name + "\n\nCode: "  +

                    data[index].dst_code + "\n\nShop Name: " +

                        data[index].shop_name + "\n\nEmail: " +
                        data[index].email


                        , style:TextStyle(fontSize: 20.0,color: Colors.white

                   ,   fontFamily: 'Raleway',
                      fontWeight: FontWeight.normal,
                    )),


                  )//
              ),

              Row(
                children:<Widget> [
                  SizedBox(width: 10,),

                  Container(
                    width :90,
                    height: 200,
                    child: Image.network(

                        stringAvatar[0]
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width :90,
                    height: 200,
                    child: Image.network(

                        stringAvatar[1]
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width :90,
                    height: 200,
                    child: Image.network(

                        stringAvatar[2]
                    ),
                  ),


                ],
              )
            ,



              SizedBox(height: 24.0),

            ],
          ),
        ),
        Positioned(
          right: 0.0,
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: Color.fromRGBO(55, 75, 167, 1)),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
