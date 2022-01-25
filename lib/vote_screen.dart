import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_app/contract_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/candidate_model.dart';


class VoteScreen extends StatelessWidget {

  final String address;

  VoteScreen({Key key, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
     
      body:Consumer<ContractData>(
        builder: (context,data,child){
          return ListView.builder(
              itemCount: data.candidatesCount,
              itemBuilder: (context,index) {
                Candidate candidate = data.getCandidate(index);

                return SizedBox(
                  width: size.width,
                  height: 120.0,
                  child: Card(
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        Text('Name : ${candidate.name}'),
                        ElevatedButton(
                            onPressed: (){

                              try{

                              }catch(e){

                                Fluttertoast.showToast(
                                  msg:'you cant vote at this time',
                                );
                              }

                            },
                            child: const Text('Vote'))
                      ],
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }





}
