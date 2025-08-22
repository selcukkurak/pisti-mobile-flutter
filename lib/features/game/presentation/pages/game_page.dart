import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/injection_container.dart' as di;
import '../../../shared/widgets/cards/card_widget.dart';
import '../../domain/entities/playing_card.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/game.dart';
import '../../domain/usecases/pisti_game_engine.dart';
import '../bloc/game_bloc.dart';

class GamePage extends StatefulWidget {
  final String? gameMode;

  const GamePage({super.key, this.gameMode});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late GameBloc _gameBloc;
  late AnimationController _pistiAnimationController;
  late Animation<double> _pistiAnimation;
  
  Game? currentGame;
  String? selectedCardId;

  @override
  void initState() {
    super.initState();
    _gameBloc = di.sl<GameBloc>();
    
    _pistiAnimationController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.pistiAnimationDuration),
      vsync: this,
    );
    
    _pistiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pistiAnimationController,
      curve: Curves.elasticOut,
    ));
    
    // Initialize game
    _initializeGame();
  }

  @override
  void dispose() {
    _pistiAnimationController.dispose();
    _gameBloc.close();
    super.dispose();
  }

  void _initializeGame() {
    // Create players based on game mode
    final players = [
      const Player(
        id: 'player1',
        name: 'You',
        type: PlayerType.human,
        isCurrentPlayer: true,
      ),
      Player(
        id: 'player2',
        name: widget.gameMode == AppConstants.offlineMode ? 'AI' : 'Opponent',
        type: widget.gameMode == AppConstants.offlineMode 
            ? PlayerType.ai 
            : PlayerType.online,
      ),
    ];

    // Create game
    final gameMode = _getGameModeFromString(widget.gameMode ?? AppConstants.offlineMode);
    currentGame = PistiGameEngine.createGame('game_1', gameMode, players);
    
    setState(() {});
  }

  GameMode _getGameModeFromString(String modeString) {
    switch (modeString) {
      case AppConstants.offlineMode:
        return GameMode.offline;
      case AppConstants.onlineMode:
        return GameMode.online;
      case AppConstants.privateRoomMode:
        return GameMode.privateRoom;
      default:
        return GameMode.offline;
    }
  }

  void _playCard(String cardId) {
    if (currentGame == null || selectedCardId == null) return;
    
    try {
      final updatedGame = PistiGameEngine.playCard(
        currentGame!,
        cardId,
        0, // Human player index
      );
      
      setState(() {
        currentGame = updatedGame;
        selectedCardId = null;
      });
      
      if (updatedGame.isPisti) {
        _showPistiAnimation();
      }
      
      // Handle AI turn if in offline mode
      if (widget.gameMode == AppConstants.offlineMode && 
          updatedGame.isInProgress && 
          updatedGame.currentPlayerIndex == 1) {
        _handleAITurn();
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _handleAITurn() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (currentGame == null || !currentGame!.isInProgress) return;
      
      final aiPlayer = currentGame!.players[1];
      if (aiPlayer.cardIds.isNotEmpty) {
        // Simple AI: play first card (can be improved)
        final cardToPlay = aiPlayer.cardIds.first;
        
        try {
          final updatedGame = PistiGameEngine.playCard(
            currentGame!,
            cardToPlay,
            1, // AI player index
          );
          
          setState(() {
            currentGame = updatedGame;
          });
          
          if (updatedGame.isPisti) {
            _showPistiAnimation();
          }
        } catch (e) {
          // Handle error silently for AI
        }
      }
    });
  }

  void _showPistiAnimation() {
    _pistiAnimationController.forward().then((_) {
      _pistiAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pişti - ${widget.gameMode ?? 'Offline'}'),
        backgroundColor: const Color(0xFF0D7377),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeGame,
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _gameBloc,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              colors: [
                const Color(0xFF0D7377),
                const Color(0xFF0D7377).withOpacity(0.8),
              ],
            ),
          ),
          child: currentGame == null 
              ? const Center(child: CircularProgressIndicator())
              : _buildGameBoard(),
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    final game = currentGame!;
    final humanPlayer = game.players[0];
    final aiPlayer = game.players[1];

    return SafeArea(
      child: Stack(
        children: [
          // Game board layout
          Column(
            children: [
              // Opponent's area
              Expanded(
                flex: 2,
                child: _buildOpponentArea(aiPlayer),
              ),
              
              // Middle area (card pile)
              Expanded(
                flex: 3,
                child: _buildMiddleArea(game),
              ),
              
              // Player's area
              Expanded(
                flex: 2,
                child: _buildPlayerArea(humanPlayer),
              ),
            ],
          ),
          
          // Pişti animation overlay
          if (_pistiAnimationController.status != AnimationStatus.dismissed)
            _buildPistiAnimation(),
            
          // Game status overlay
          if (game.isGameFinished)
            _buildGameFinishedOverlay(game),
        ],
      ),
    );
  }

  Widget _buildOpponentArea(Player opponent) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Opponent info
          Card(
            color: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    opponent.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Score: ${opponent.score}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Opponent's cards (face down)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: opponent.cardCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CardWidget(
                    width: 60,
                    height: 80,
                    isVisible: false, // Face down
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiddleArea(Game game) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Deck
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CardWidget(
                    width: 70,
                    height: 100,
                    isVisible: false,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Deck: ${game.deck.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              
              // Middle pile
              Column(
                children: [
                  CardWidget(
                    card: game.topCard,
                    width: 80,
                    height: 110,
                    isVisible: game.topCard != null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Middle: ${game.middlePile.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          
          // Current player indicator
          if (game.isInProgress)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                game.currentPlayer.name == 'You' ? 'Your Turn' : '${game.currentPlayer.name}\'s Turn',
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerArea(Player player) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Player's cards
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: player.cardIds.length,
              itemBuilder: (context, index) {
                final cardId = player.cardIds[index];
                final cardParts = cardId.split('_');
                final suit = Suit.values.firstWhere((s) => s.name == cardParts[0]);
                final rank = Rank.values.firstWhere((r) => r.name == cardParts[1]);
                final card = PlayingCard(suit: suit, rank: rank);
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CardWidget(
                    card: card,
                    width: 80,
                    height: 120,
                    isSelected: selectedCardId == cardId,
                    onTap: () {
                      if (player.isCurrentPlayer) {
                        setState(() {
                          selectedCardId = cardId;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // Player info and actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Score: ${player.score}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              
              if (selectedCardId != null && player.isCurrentPlayer)
                ElevatedButton(
                  onPressed: () => _playCard(selectedCardId!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Play Card'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPistiAnimation() {
    return AnimatedBuilder(
      animation: _pistiAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pistiAnimation.value,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Transform.scale(
                scale: _pistiAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Text(
                    'PİŞTİ!',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameFinishedOverlay(Game game) {
    final winner = game.players.firstWhere((p) => p.id == game.winnerId);
    
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 64,
                  color: Color(0xFFFFD700),
                ),
                const SizedBox(height: 16),
                Text(
                  'Game Over!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${winner.name} Wins!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Final Score: ${winner.score}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _initializeGame,
                      child: const Text('Play Again'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Main Menu'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}