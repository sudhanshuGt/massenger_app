import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/chat_user_info.dart';
import '../../../viewmodel/chat_viewmodel.dart';
import '../../../viewmodel/theme_viewmodel.dart';
import '../../chats/users_chat.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatViewModel>(context, listen: false).loadChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final viewModel = Provider.of<ChatViewModel>(context);
    final chats = viewModel.chats;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/app/no_message.png',
                height: 180,
                color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
              ),
              const SizedBox(height: 20),
              Text(
                'No Conversations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start chatting with your friends!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }else{
      return ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: Hero(tag: "profile-pic", child: CircleAvatar(
              child: Text(chat.firstName[0]),
            )),
            title: Text('${chat.firstName} ${chat.lastName}'),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(DateFormat('hh:mm a').format(chat.timestamp)),
            onTap: () {
              final receiver = UserInfoModel(
                username: chat.username,
                firstName: chat.firstName,
                lastName: chat.lastName,
                bio: chat.bio,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(user: receiver),
                ),
              );
            },
          );
        },
      );
    }
  }
}
