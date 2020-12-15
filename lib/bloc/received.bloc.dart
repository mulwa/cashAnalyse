import 'dart:async';

import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/repositories/ledger_repository.dart';
import 'package:rxdart/rxdart.dart';

class ReceivedBloc {
  RecievedRepository _recievedRepository = RecievedRepository();

  BehaviorSubject _receivedController = BehaviorSubject<List<Received>>();
  BehaviorSubject<List<Received>> get received => _receivedController.stream;

  StreamController _receivedEventController =
      StreamController<ReceivedActions>();
  StreamSink<ReceivedActions> get eventSink => _receivedEventController.sink;
  Stream<ReceivedActions> get _eventStream => _receivedEventController.stream;

  ReceivedBloc() {
    print("inside receiver bloc");
    _eventStream.listen((event) async {
      if (event == ReceivedActions.read) {
        try {
          var result = await _recievedRepository.getReceived('received');
          print(result);
          _receivedController.add(result.received);
        } catch (error) {
          print(error);
          _receivedController.addError("An error has occured");
        }
      }
    });
  }

  void dispose() {
    _receivedController.close();
    _receivedEventController.close();
  }
}

final receivedBloc = ReceivedBloc();

enum ReceivedActions { read, delete }
