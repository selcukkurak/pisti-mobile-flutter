import 'package:equatable/equatable.dart';

enum Suit { hearts, diamonds, clubs, spades }
enum Rank { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }

class PlayingCard extends Equatable {
  final Suit suit;
  final Rank rank;
  final bool isVisible;

  const PlayingCard({
    required this.suit,
    required this.rank,
    this.isVisible = true,
  });

  PlayingCard copyWith({
    Suit? suit,
    Rank? rank,
    bool? isVisible,
  }) {
    return PlayingCard(
      suit: suit ?? this.suit,
      rank: rank ?? this.rank,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  bool get isJack => rank == Rank.jack;
  bool get isAce => rank == Rank.ace;
  bool get isTwoOfClubs => rank == Rank.two && suit == Suit.clubs;
  bool get isTenOfDiamonds => rank == Rank.ten && suit == Suit.diamonds;

  int get points {
    if (isJack) return 1;
    if (isAce) return 1;
    if (isTwoOfClubs) return 2;
    if (isTenOfDiamonds) return 3;
    return 0;
  }

  String get imagePath {
    final suitName = suit.name;
    final rankName = rank.name;
    return 'assets/images/cards/${rankName}_of_${suitName}.png';
  }

  String get displayName {
    final rankDisplay = switch (rank) {
      Rank.ace => 'A',
      Rank.two => '2',
      Rank.three => '3',
      Rank.four => '4',
      Rank.five => '5',
      Rank.six => '6',
      Rank.seven => '7',
      Rank.eight => '8',
      Rank.nine => '9',
      Rank.ten => '10',
      Rank.jack => 'J',
      Rank.queen => 'Q',
      Rank.king => 'K',
    };
    final suitDisplay = switch (suit) {
      Suit.hearts => '♥',
      Suit.diamonds => '♦',
      Suit.clubs => '♣',
      Suit.spades => '♠',
    };
    return '$rankDisplay$suitDisplay';
  }

  @override
  List<Object?> get props => [suit, rank, isVisible];

  @override
  String toString() => 'Card($displayName)';
}