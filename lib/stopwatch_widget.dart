// Copyright 2019 Ben Hills (ben.hills@amugofjava.me.uk).
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch_bloc_example/stopwatch_bloc.dart';
import 'package:stopwatch_bloc_example/stopwatch_state.dart';

/// This Widget builds the time and start, stop and reset buttons. I have built
/// this as a separate widget in order to demonstrate how you obtain the BLoC
/// instance from Provider lower down the tree.
class StopwatchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StopwatchBloc bloc = Provider.of<StopwatchBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<String>(
            stream: bloc.stopwatchTime,
            builder: (context, snapshot) {
              return snapshot.hasData ? Text(snapshot.data, style: const TextStyle(fontSize: 48.0)) : Text('');
            }),
        Padding(
          padding: EdgeInsets.all(48.0),
        ),
        StreamBuilder<StopwatchState>(
            stream: bloc.stopwatchState,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      child: Text('START'),
                      onPressed: (snapshot.data is StopwatchStopState)
                          ? () => bloc.transitionState(StopwatchStartState())
                          : null),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                  ),
                  RaisedButton(
                      child: Text('STOP'),
                      onPressed: (snapshot.data is StopwatchStartState)
                          ? () => bloc.transitionState(StopwatchStopState())
                          : null),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                  ),
                  RaisedButton(
                      child: Text('RESET'),
                      onPressed: () {
                        bloc.transitionState(StopwatchResetState());
                      }),
                ],
              );
            }),
      ],
    );
  }
}
