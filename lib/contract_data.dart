import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:voting_app/models/candidate_model.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';

class ContractData extends ChangeNotifier{

   final  List<Candidate> _candidates = [
    Candidate(name: "John",imageUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    Candidate(name: "Alex",imageUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    Candidate(name: "Eve",imageUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
    Candidate(name: "Adam",imageUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
  ];

  final String _rpcUrl = "http://192.168.8.156:7545";
  final String _wsUrl = "ws://192.168.8.156:7545";
  final String _privateKey = "fcfccaca3f7efaadc6a53f2bafe404bb17ad2765bac254d0f8e485a3b3436a2a";


  Web3Client _client;
  String _abiCode;

  bool isLoading;


  Credentials _credentials;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;

  DeployedContract _contract;
  ContractFunction _admin;
  ContractFunction _register;
  ContractFunction _vote;
  ContractFunction _winner;

  ContractData(){
    initialConfig();
  }


  void initialConfig() async {

    _client = Web3Client(_rpcUrl, Client(), socketConnector: (){
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContracts();
  }

  Future getAbi() async {
    String abiStringFile = await rootBundle.loadString("src/abis/Election.json");
    var file = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(file['abi']);
    _contractAddress = EthereumAddress.fromHex(file['networks']['5777']['address']);
  }

  Future getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownAddress = await _credentials.extractAddress();
  }

  Future getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Election"),
        _contractAddress
    );

    _admin =_contract.function("admin");
    _register = _contract.function("Register");
    _vote = _contract.function("Vote");
    _winner = _contract.function("Winner");
    getAdmin();
  }

  Future getAdmin() async {
    var admin = await _client.call(contract: _contract, function: _admin, params: []);

    print("${admin.first}");
    isLoading = false;
    notifyListeners();
  }

   Future registerVoter(String voterAddress, String adminAddress) async
  {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _register,
            parameters: [
              EthereumAddress.fromHex(voterAddress),
              EthereumAddress.fromHex(adminAddress),
            ]
        ),
    );
    print("Registered");
    getAdmin();
  }

   Future vote(int proposal, String voterAddress) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _vote,
            parameters: [
              BigInt.from(proposal),
              EthereumAddress.fromHex(voterAddress)
            ]),
    );
  }

  Future<String> getWinner() async {
    var winner = await _client.call(
        contract: _contract,
        function: _winner,
        params: []
    );

    return "${winner.first}";
  }


  UnmodifiableListView<Candidate> get allCandidates{
    return UnmodifiableListView(_candidates);
  }

  int get candidatesCount{
    return _candidates.length;
  }

  Candidate getCandidate(int index)
  {
    return _candidates[index];
  }

  void addCandidate(Candidate candidate){
    _candidates.add(candidate);
    notifyListeners();
  }

  void testFunction()
  {

  }
}