import 'package:flutter/material.dart';
import 'package:messanger_app/presentation/home/tabs/chat.dart';
import 'package:messanger_app/presentation/home/tabs/profile.dart';
import 'package:messanger_app/presentation/home/tabs/search.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/chat_viewmodel.dart';
import '../../viewmodel/nav_viewmodel.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const ChatTab(),
      const SearchTab(),
      const ProfileTab(),
    ];

    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: Consumer<NavigationViewModel>(
        builder: (context, navViewModel, _) {
          return Scaffold(
            appBar: AppBar(title: const Text("Messenger App")),
            body: tabs[navViewModel.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navViewModel.currentIndex,
              onTap: navViewModel.setIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        },
      ),
    );
  }
}
