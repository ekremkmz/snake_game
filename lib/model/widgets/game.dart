import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/cubit/screen_cubit.dart';

import '../active_direction.dart';
import 'game_board.dart';
import 'score.dart';

class Game extends StatelessWidget {
  const Game({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ScreenCubit, ScreenState>(
        builder: (context, state) {
          switch (state) {
            case ScreenState.startGame:
              return _startgame(context);
            case ScreenState.gameBoard:
              return _gameBoard(context);
            default:
              return Container(
                child: Text("Unimplemented Screen"),
              );
          }
        },
      ),
    );
  }

  Widget _startgame(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: FlatButton(
          padding: EdgeInsets.fromLTRB(100, 50, 100, 50),
          color: Colors.black,
          textColor: Colors.white,
          onPressed: BlocProvider.of<ScreenCubit>(context, listen: false).start,
          child: Text(
            "Start",
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }

  Widget _gameBoard(BuildContext context) {
    ActiveDirection activeDirection =
        Provider.of<ActiveDirection>(context, listen: false);
    return GestureDetector(
      onPanUpdate: (det) {
        _checkMove(det, activeDirection);
      },
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GameBoard(),
              Score(),
            ],
          ),
        ),
      ),
    );
  }

  void _checkMove(DragUpdateDetails det, ActiveDirection activeDirection) {
    if (det.delta.dx.abs() > det.delta.dy.abs()) {
      if (det.delta.dx > 0.1) {
        activeDirection.direction =
            (activeDirection.lastDirection == Direction.left)
                ? Direction.left
                : Direction.right;
      } else if (det.delta.dx < -0.1) {
        activeDirection.direction =
            (activeDirection.lastDirection == Direction.right)
                ? Direction.right
                : Direction.left;
      }
    } else {
      if (det.delta.dy > 0.1) {
        activeDirection.direction =
            (activeDirection.lastDirection == Direction.down)
                ? Direction.down
                : Direction.up;
      } else if (det.delta.dy < -0.1) {
        activeDirection.direction =
            (activeDirection.lastDirection == Direction.up)
                ? Direction.up
                : Direction.down;
      }
    }
  }
}