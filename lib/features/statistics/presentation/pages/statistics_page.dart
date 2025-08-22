import 'package:flutter/material.dart';
import '../../../core/services/persistence_service.dart';

class StatisticsPage extends StatelessWidget {
  final PersistenceService _persistenceService = PersistenceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İstatistikler'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Overall Stats Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.bar_chart,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Genel İstatistikler',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          title: 'Toplam Oyun',
                          value: _persistenceService.getGamesPlayed().toString(),
                          icon: Icons.sports_esports,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _StatItem(
                          title: 'Kazanılan',
                          value: _persistenceService.getGamesWon().toString(),
                          icon: Icons.emoji_events,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          title: 'Kazanma Oranı',
                          value: '${_persistenceService.getWinRate().toStringAsFixed(0)}%',
                          icon: Icons.trending_up,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _StatItem(
                          title: 'En Yüksek Skor',
                          value: _persistenceService.getHighScore().toString(),
                          icon: Icons.stars,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Pişti Stats Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.celebration,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Pişti İstatistikleri',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          title: 'Toplam Pişti',
                          value: _persistenceService.getTotalPisti().toString(),
                          icon: Icons.celebration,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _StatItem(
                          title: 'Oyun Başına Ort.',
                          value: _persistenceService.getAveragePistiPerGame().toStringAsFixed(1),
                          icon: Icons.analytics,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          title: 'Tek Oyunda En Çok',
                          value: _persistenceService.getMaxPistiInGame().toString(),
                          icon: Icons.rocket_launch,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _StatItem(
                          title: 'Ardışık Pişti',
                          value: '3',
                          icon: Icons.whatshot,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Recent Games Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Son Oyunlar',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  ..._buildRecentGames(),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Reset Stats Button
          Card(
            child: InkWell(
              onTap: () => _showResetDialog(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.red,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'İstatistikleri Sıfırla',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tüm istatistikleri sıfırla ve yeni başla',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SizedBox(height: 32),
        ],
      ),
    );
  }

  List<Widget> _buildRecentGames() {
    final games = [
      {'result': 'Kazandın', 'score': '156-89', 'pisti': '4', 'date': '2 saat önce'},
      {'result': 'Kaybettin', 'score': '134-152', 'pisti': '2', 'date': '1 gün önce'},
      {'result': 'Kazandın', 'score': '187-91', 'pisti': '7', 'date': '2 gün önce'},
      {'result': 'Kazandın', 'score': '162-103', 'pisti': '3', 'date': '3 gün önce'},
    ];

    return games.map((game) {
      final isWin = game['result'] == 'Kazandın';
      return Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isWin 
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isWin 
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isWin ? Icons.emoji_events : Icons.close,
              color: isWin ? Colors.green : Colors.red,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game['result']!,
                    style: TextStyle(
                      color: isWin ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Skor: ${game['score']} • Pişti: ${game['pisti']}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              game['date']!,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('İstatistikleri Sıfırla'),
        content: Text('Bu işlem tüm oyun istatistiklerinizi kalıcı olarak silecektir. Devam etmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _persistenceService.resetStatistics();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('İstatistikler sıfırlandı!'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Sıfırla'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}