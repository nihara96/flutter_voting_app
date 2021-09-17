import 'package:flutter/material.dart';
import 'package:voting_app/models/candidate_model.dart';
import 'package:voting_app/vote_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'contract_data.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contractData = Provider.of<ContractData>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 150.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                onPressed: (){

                  handleVote(context);

                },
                child: const Text('Vote'),
            ),
                ElevatedButton(
                  onPressed: (){
                    registerVoter(context);
                  },
                  child: const Text('Register'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String winner = await contractData.getWinner();
                    Candidate candidate = Provider.of<ContractData>(context,listen: false).getCandidate(int.parse(winner));
                    showWinner(context,
                        candidate.name,
                      candidate.imageUrl,
                    );
                  },
                  child: const Text('Winner'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showWinner(context,winner,image) {

    showDialog(
        context: context,
        builder: (_)
        {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Winner Is $winner',
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                ),
                 const SizedBox(height: 20.0,),
                 CircleAvatar(
                  maxRadius: 60.0,
                  backgroundImage: NetworkImage(image),
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                ),
              ],
            ),
          );
        },
    );
  }

  void handleVote(context) {

    // var contractLink = Provider.of<ContractData>(context,listen: false);
    TextEditingController voterAddress = TextEditingController();

    showDialog(context: context,
        builder: (_)
        {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Voting',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                Padding(padding: const EdgeInsets.only(top: 10,bottom: 8.0),
                child: TextField(
                  controller: voterAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Voter Address",
                    hintText: "Enter Address"
                  ),
                ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(context,
                          MaterialPageRoute(builder:(context)=> VoteScreen(address: voterAddress.text,)),

                          );
                        },
                        child: const Text('Ok'),
                    )
                  ],
                ),
              ],
            ),
          );
        }
    );

  }

  void registerVoter(context) {
    var contractLink = Provider.of<ContractData>(context, listen: false);
    TextEditingController voterAddress = TextEditingController();
    TextEditingController adminAddress = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               const Text(
                  "Register Voter",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding:const EdgeInsets.only(top: 18.0, bottom: 8.0),
                  child: TextField(
                    controller: adminAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Admin Address",
                        hintText: "Enter Admin Address..."),
                  ),
                ),
                Padding(
                  padding:const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: voterAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Voter Address",
                        hintText: "Enter Voter Address..."),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:const Text("Cancel")),
                    Padding(
                      padding:const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                          onPressed: () {

                            try{
                              contractLink.registerVoter(
                                  voterAddress.text, adminAddress.text);
                              Fluttertoast.showToast(
                                msg: "Voter ${voterAddress.text.substring(0, 5)}XXX Registered.",
                              );

                            }catch(e){
                              Fluttertoast.showToast(
                                msg:'Registration Error !',
                              );
                            }


                            Navigator.pop(context);
                          },
                          child:const Text("Register")),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

}
