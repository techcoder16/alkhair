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

    child: dialogContent(context,data,index),
  );

}

Widget dialogContent(BuildContext context,dynamic data,int index) {
  List <String> stringAvatar= _splitString(
      data[index].avatar);

print( data[0].avatar );

  return Container(
    margin: EdgeInsets.only(left: 0.0,right: 0.0),
    child: Stack(
      children: <Widget>[

              Center(
                  child: /*Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Name: " + data[index].name + "\n\nCode: "  +

                    data[index].dst_code + "\n\nAddress: " +
                        data[index].address + "\n\nContact Number: " +
                        data[index].contact_no_1 +
                        "\n\nShop Name: " +

                        data[index].shop_name +
                        "\n\nShop Size: "
                         +      data[index].shop_size
                         + "\n\nCovered Sale : "
                        +   data[index].covered_sale
                        + "\n\nCovered Sale : "
                        +   data[index].covered_sale
                        + "\n\nUncovered Sale : "
                        +   data[index].uncovered_sale
                        + "\n\nTotal Sale : "
                        +   data[index].total_sale

                        + "\n\nCredit Limit : "
                        +   data[index].credit_limit



                        , style:TextStyle(fontSize: 20.0,color: Colors.white

                   ,   fontFamily: 'Raleway',
                      fontWeight: FontWeight.normal,
                    )),


                  )//
              ),*/

                  Table(
                    border: TableBorder.symmetric(
                        inside: BorderSide.none,
                        outside:
                        BorderSide(width: 1)),
                    defaultColumnWidth:
                    FixedColumnWidth(
                        MediaQuery.of(context)
                            .size
                            .width *0.25
                            ),
                    children: [
                      TableRow(children: [
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text(
                                    'Visiting Card',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text('Shop Size',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text(
                                    'Customer Type',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                      ]),
                      TableRow(children: [
                        Container(
                          height: 100,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Container(
                                  height: 70,
                                  child: Image.network(
                                      data[
                                  index]
                                      .avatar ),
                                ),
                              ]),
                        ),
                        Container(
                          height: 100,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                    data[index]
                                        .city,
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .black,
                                      fontSize:
                                      15.0,
                                    )),
                              ]),
                        ),
                        SizedBox(
                          height: 60,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                   data[index]
                                        .distributor_type,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )),
                              ]),
                        ),
                      ]),
                      TableRow(children: [
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text(
                                    'Customer\nName',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text(
                                    'Shop Name',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text('Email',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                      ]),
                      TableRow(children: [
                        SizedBox(
                          height: 60,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                   data[index]
                                        .name,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )),
                              ]),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                   data[index]
                                        .shop_name,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )),
                              ]),
                        ),
                        SizedBox(
                          height: 60,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                   data[index]
                                        .email,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )),
                              ]),
                        ),
                      ]),
                      TableRow(children: [
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text('Remarks',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text('Covered Sale',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text(
                                    'Uncovered Sale',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                      ]),
                      TableRow(children: [
                        SizedBox(
                          height: 60,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Flexible(child:Text(


                                    data[index]
                                        .shop_size,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,

                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )


                                ),),
                              ]),
                        ),
                        SizedBox(
                          height: 60,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                    data[index]
                                        .covered_sale,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )),
                              ]),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                  data[index]
                                        .uncovered_sale,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )),
                              ]),
                        ),
                      ]),

                      TableRow(children: [
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text('Address',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text('Companies Working With',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                        Container(
                          color: Color.fromRGBO(
                              106, 136, 171, 1),
                          height: 50,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: const [
                                Text('Our Brands',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                      15.0,
                                      backgroundColor:
                                      Color.fromRGBO(
                                          106,
                                          136,
                                          171,
                                          1),
                                    )),
                              ]),
                        ),
                      ]),
                      TableRow(children: [
                        SizedBox(
                          height: 60,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Flexible(child:  Text(
                                  data[index]
                                        .address,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,

                                    maxLines: 2,

                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    ))),
                              ]),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Text(
                                  data[index]
                                        .companies_working_with,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )),
                              ]),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .center,
                              children: [
                                Flexible(child:Text(
                                   data[index].our_brands,

                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      12.0,
                                    )),),
                              ]),
                        ),

                      ]),


                      /*   TableRow(children: [
                                                    Container(
                                                      color: Color.fromRGBO(
                                                          106, 136, 171, 1),
                                                      height: 50,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text('City',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                )),
                                                          ]),
                                                    ),
                                                    Container(
                                                      color: Color.fromRGBO(
                                                          106, 136, 171, 1),
                                                      height: 50,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text('Address',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .distributor_city,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .distributor_address,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    Container(
                                                      color: Color.fromRGBO(
                                                          106, 136, 171, 1),
                                                      height: 50,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text('Companies',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                )),
                                                          ]),
                                                    ),
                                                    Container(
                                                      color: Color.fromRGBO(
                                                          106, 136, 171, 1),
                                                      height: 50,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text('Owned',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.0,
                                                                  backgroundColor:
                                                                      Color.fromRGBO(
                                                                          106,
                                                                          136,
                                                                          171,
                                                                          1),
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .companies_working_with,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .owned,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                )),
                                                          ]),
                                                    ),
                                                  ]),*/
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
