library iris;

export 'middleware/body_parser.dart';

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}

// TODO: Export any utility modules intended for clients of this library.
