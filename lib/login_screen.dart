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
                  onPressed: () {
                    handleVote(context);
                  },
                  child: const Text('Vote'),
                ),
                ElevatedButton(
                  onPressed: () {
                    registerVoter(context);
                  },
                  child: const Text('Register'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String winner = await contractData.getWinner();
                    Candidate candidate =
                        Provider.of<ContractData>(context, listen: false)
                            .getCandidate(int.parse(winner));
                    showWinner(
                      context,
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

  void showWinner(context, winner, image) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Winner Is $winner',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CircleAvatar(
                maxRadius: 60.0,
                backgroundImage: NetworkImage(image),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
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
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: const Color(0xFF737373),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Enter Wallet Address'),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(fontSize: 17),
                              hintText: 'Address',
                              contentPadding: EdgeInsets.all(20),
                            ),
                            controller: voterAddress,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: SizedBox(
                              width: 150.0,
                              child: ElevatedButton(
                                child: const Text("OK"),
                                onPressed: () async {
                                  var contractLink = Provider.of<ContractData>(
                                      context,
                                      listen: false);

                                  try {
                                    await contractLink
                                        .checkVoted(voterAddress.text);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VoteScreen(
                                                address: voterAddress.text,
                                              )),
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);

                                    RegExp voted = RegExp(
                                        "\\b" + "Already voted" + "\\b",
                                        caseSensitive: false);
                                    RegExp noRights = RegExp(
                                        "\\b" + "Has no right to vote" + "\\b",
                                        caseSensitive: false);

                                    if (voted.hasMatch(e.toString())) {
                                      Fluttertoast.showToast(
                                        msg: "You are already voted",
                                      );
                                    } else if (noRights
                                        .hasMatch(e.toString())) {
                                      Fluttertoast.showToast(
                                        msg: "Has no right to vote",
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "You cant vote this time",
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void registerVoter(context) {
    var contractLink = Provider.of<ContractData>(context, listen: false);
    TextEditingController voterAddress = TextEditingController();
    TextEditingController adminAddress = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: const Color(0xFF737373),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Enter Admin Wallet Address'),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(fontSize: 17),
                              hintText: 'Admin\'s Address',
                              contentPadding: EdgeInsets.all(20),
                            ),
                            controller: adminAddress,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text('Enter Voter Wallet Address'),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(fontSize: 17),
                              hintText: 'Voter\'s Address',
                              contentPadding: EdgeInsets.all(20),
                            ),
                            controller: voterAddress,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: SizedBox(
                              width: 150.0,
                              child: ElevatedButton(
                                child: const Text("OK"),
                                onPressed: () async {
                                  try {
                                    contractLink.registerVoter(
                                        voterAddress.text, adminAddress.text);
                                    Fluttertoast.showToast(
                                      msg:
                                          "Voter ${voterAddress.text.substring(0, 5)}XXX Registered.",
                                    );
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                      msg: 'Registration Error !',
                                    );
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
