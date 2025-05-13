import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/material.dart';

class Requestpage extends StatefulWidget {
  const Requestpage({super.key});

  @override
  State<Requestpage> createState() => _RequestpageState();
}

class _RequestpageState extends State<Requestpage> {

  bool isSwitched = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Stack(
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height*.25,
                child: Center(child: Text("REQUEST",style: TextStyle(fontSize: width*.08,fontWeight: FontWeight.bold,color: Colors.white),)),
              ),
              Expanded(child: Container(
                width: width*1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(width*.2),topRight: Radius.circular(width*.2)),
                  // border: Border.all()
                ),
                child: Column(
                  children: [
                    SizedBox(height: height*.2,
                    ),
                    Text("data"),
                  ],
                ),
              )),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: width*.38),
              child: Container(
                        // height: width*.5,
                      width: width*.75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(width*.05)),
                          color: Colors.white,
                          border: Border.all(color: Colors.black12)
                        ),
                        child: Column(mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: width*.02,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
              
                                borderRadius: BorderRadius.all(Radius.circular(width*.02))
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: width*.01,right: width*.01),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_on_rounded),
                                    SizedBox(width: width*.6,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          label: Text("From"),
                                
                                          // labelText: "cvbn",
                                          labelStyle: TextStyle(fontSize: width*.035),
                                          border: UnderlineInputBorder(borderSide: BorderSide.none,)
                                          
                                
                                        ),
                                        
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: width*.02,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black12,
              
                                borderRadius: BorderRadius.all(Radius.circular(width*.02))
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: width*.01,right: width*.01),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_on_rounded),
                                    SizedBox(width: width*.6,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          label: Text("To"),
                                
                                          // labelText: "cvbn",
                                          labelStyle: TextStyle(fontSize: width*.035),
                                          border: UnderlineInputBorder(borderSide: BorderSide.none,)
                                          
                                
                                        ),
                                        
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: width*.02,),
                            Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Switch(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      // splashRadius: 5,
                                                  value: isSwitched,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isSwitched = value;
                                                    });
                                                  },
                                                  activeColor: Colors.green,
                                                  inactiveThumbColor: Colors.grey,
                                                ),
                                    
                                                isSwitched==false?
                                                Text("1 WAY"):Text("2 WAY"),
                                  ],
                                ),
                              ],  
                            )

                          ],
                        ),
                      ),
            ),
          )
        ],
      ),
    );
  }
}