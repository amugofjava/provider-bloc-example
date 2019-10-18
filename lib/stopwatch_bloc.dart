// Copyright 2019 Ben Hills (ben.hills@amugofjava.me.uk).
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stopwatch_bloc_example/stopwatch_state.dart';

import 'stopwatch_state.dart';

/// This BLoC handles the state of the stopwatch. The stopwatch can either be in a stopped, started
/// or reset. The BLoC communicates through sinks and streams only and is responsible for formatting
/// the stopwatch time into a string which is then streamed to listeners - which in this example is
/// just the UI.
class StopwatchBloc {
  /// The current state of the stopwatch: stop, start or reset.
  final BehaviorSubject<StopwatchState> _stopwatchState = BehaviorSubject<StopwatchState>.seeded(StopwatchStopState());

  /// The current time of the stopwatch. We seed it with 00:00:00 so that we have a value on first run.
  final BehaviorSubject<String> _stopwatchTime = BehaviorSubject<String>.seeded('00:00:00');

  /// Provided by the Dart framework and provides us with all we need for a stopwatch.
  final Stopwatch _stopwatch = Stopwatch();

  /// A subscription to a timer Observable which fires every 50 milliseconds.
  StreamSubscription subscription;

  StopwatchBloc() {
    _setupBLoC();
  }

  /// If order for the BLoC to know what to do we need to listen on the _stopwachState. Every
  /// time we receive a new state we execute the relevant function.
  _setupBLoC() {
    _stopwatchState.listen((event) {
      switch (event.runtimeType) {
        case StopwatchStartState:
          _start();
          break;
        case StopwatchStopState:
          _stop();
          break;
        case StopwatchResetState:
          _reset();
          break;
      }
    });
  }

  void Function(StopwatchState) get transitionState => _stopwatchState.add;

  Observable<String> get stopwatchTime => _stopwatchTime.stream;

  Observable<StopwatchState> get stopwatchState => _stopwatchState.stream;

  /// This method is called when the state is transitioned to StopwatchStartState. Here we
  /// start the _stopwatch and then setup an Observable to trigger every 50 milliseconds.
  /// On each trigger we fetch the elapsed time from the _stopwatch and split it into
  /// hundredths, seconds and minutes. We then format a String to show the current
  /// elapsed time and push it into the _stopwatchTime sink. Anything that subscribes
  /// to _stopwatchTime (in this case our UI) will receive the updated String every
  /// 50 milliseconds.
  void _start() {
    _stopwatch.start();

    subscription = Observable.periodic(Duration(milliseconds: 50)).listen((tick) {
      final elapsed = _stopwatch.elapsed;

      final int hundreds = (elapsed.inMilliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();

      String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
      String minutesStr = (minutes % 60).toString().padLeft(2, '0');
      String secondsStr = (seconds % 60).toString().padLeft(2, '0');

      var t = '$minutesStr:$secondsStr:$hundredsStr';

      _stopwatchTime.add(t);
    });
  }

  /// We stop the stopwatch and then cancel the subscription. There is no point the
  /// Observable firing every 50 milliseconds if there is no-one listening to it.
  void _stop() {
    _stopwatch.stop();

    if (subscription != null) {
      subscription.cancel();
    }
  }

  /// Reset the stopwatch back to zero.
  void _reset() {
    _stopwatch.reset();

    /// Push out our reset time.
    _stopwatchTime.add('00:00:00');

    /// Put as back to the stopped state.
    _stopwatchState.add(StopwatchStopState());
  }

  /// Called to dispose of our BehaviorSubjects. This method is will be handled and
  /// called by Provider.
  void dispose() {
    _stopwatchState.close();
    _stopwatchTime.close();
  }
}
