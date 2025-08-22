import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Theme Settings
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Görünüm',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      SwitchListTile(
                        title: Text('Karanlık Tema'),
                        subtitle: Text('Karanlık renk temasını etkinleştir'),
                        value: state.isDarkMode,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(ToggleThemeEvent());
                        },
                        secondary: Icon(
                          state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Language Settings
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dil',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        title: Text('Türkçe'),
                        leading: Radio<Locale>(
                          value: Locale('tr', 'TR'),
                          groupValue: state.locale,
                          onChanged: (locale) {
                            if (locale != null) {
                              context.read<SettingsBloc>().add(
                                ChangeLocaleEvent(locale),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          context.read<SettingsBloc>().add(
                            ChangeLocaleEvent(Locale('tr', 'TR')),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('English'),
                        leading: Radio<Locale>(
                          value: Locale('en', 'US'),
                          groupValue: state.locale,
                          onChanged: (locale) {
                            if (locale != null) {
                              context.read<SettingsBloc>().add(
                                ChangeLocaleEvent(locale),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          context.read<SettingsBloc>().add(
                            ChangeLocaleEvent(Locale('en', 'US')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Sound Settings
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ses',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      SwitchListTile(
                        title: Text('Ses Efektleri'),
                        subtitle: Text('Kart ve oyun seslerini etkinleştir'),
                        value: state.soundEnabled,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                            ChangeSoundEvent(value),
                          );
                        },
                        secondary: Icon(
                          state.soundEnabled ? Icons.volume_up : Icons.volume_off,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // About Section
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hakkında',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        title: Text('Uygulama Sürümü'),
                        subtitle: Text('1.0.0'),
                        leading: Icon(Icons.info_outline),
                      ),
                      ListTile(
                        title: Text('Geliştirici'),
                        subtitle: Text('Pişti Oyun Geliştiricileri'),
                        leading: Icon(Icons.code),
                      ),
                      ListTile(
                        title: Text('Geri Bildirim Gönder'),
                        subtitle: Text('Önerilerinizi bizimle paylaşın'),
                        leading: Icon(Icons.feedback),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Geri bildirim özelliği yakında gelecek!'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}