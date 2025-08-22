import '../../../core/constants/game_constants.dart';

enum CardSuit {
  hearts,
  diamonds,
  clubs,
  spades,
}

enum CardRank {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
}

class PlayingCard {
  final CardSuit suit;
  final CardRank rank;

  const PlayingCard({
    required this.suit,
    required this.rank,
  });

  // Card point values in Pişti
  int get points {
    switch (rank) {
      case CardRank.ace:
        return GameConstants.acePoints;
      case CardRank.jack:
        return GameConstants.jackPoints;
      case CardRank.two:
        return suit == CardSuit.clubs ? GameConstants.twoOfClubsPoints : 0;
      case CardRank.ten:
        return suit == CardSuit.diamonds ? GameConstants.tenOfDiamondsPoints : 0;
      default:
        return 0;
    }
  }

  // Check if this card can capture another card
  bool canCapture(PlayingCard tableCard) {
    return rank == tableCard.rank || rank == CardRank.jack;
  }

  String get displayName {
    final suitName = _getSuitName();
    final rankName = _getRankName();
    return '$rankName $suitName';
  }

  String get imagePath {
    return 'assets/images/cards/${_getSuitSymbol()}_${_getRankSymbol()}.png';
  }

  String _getSuitName() {
    switch (suit) {
      case CardSuit.hearts:
        return 'Kupa';
      case CardSuit.diamonds:
        return 'Karo';
      case CardSuit.clubs:
        return 'Sinek';
      case CardSuit.spades:
        return 'Maça';
    }
  }

  String _getRankName() {
    switch (rank) {
      case CardRank.ace:
        return 'As';
      case CardRank.two:
        return 'İki';
      case CardRank.three:
        return 'Üç';
      case CardRank.four:
        return 'Dört';
      case CardRank.five:
        return 'Beş';
      case CardRank.six:
        return 'Altı';
      case CardRank.seven:
        return 'Yedi';
      case CardRank.eight:
        return 'Sekiz';
      case CardRank.nine:
        return 'Dokuz';
      case CardRank.ten:
        return 'On';
      case CardRank.jack:
        return 'Vale';
      case CardRank.queen:
        return 'Kız';
      case CardRank.king:
        return 'Papaz';
    }
  }

  String _getSuitSymbol() {
    switch (suit) {
      case CardSuit.hearts:
        return 'hearts';
      case CardSuit.diamonds:
        return 'diamonds';
      case CardSuit.clubs:
        return 'clubs';
      case CardSuit.spades:
        return 'spades';
    }
  }

  String _getRankSymbol() {
    switch (rank) {
      case CardRank.ace:
        return 'ace';
      case CardRank.two:
        return '2';
      case CardRank.three:
        return '3';
      case CardRank.four:
        return '4';
      case CardRank.five:
        return '5';
      case CardRank.six:
        return '6';
      case CardRank.seven:
        return '7';
      case CardRank.eight:
        return '8';
      case CardRank.nine:
        return '9';
      case CardRank.ten:
        return '10';
      case CardRank.jack:
        return 'jack';
      case CardRank.queen:
        return 'queen';
      case CardRank.king:
        return 'king';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayingCard &&
          runtimeType == other.runtimeType &&
          suit == other.suit &&
          rank == other.rank;

  @override
  int get hashCode => suit.hashCode ^ rank.hashCode;

  @override
  String toString() => displayName;
}