import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/chat_user_info.dart';
import '../../viewmodel/chat_viewmodel.dart';

class ChatScreen extends StatefulWidget {
  final UserInfoModel user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late final ChatViewModel _viewModel;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ChatViewModel();
    _viewModel.startPolling(widget.user.username);

    _controller.addListener(() {
      final typing = _controller.text.trim().isNotEmpty;
      if (isTyping != typing) {
        setState(() {
          isTyping = typing;
        });
      }
    });
  }


  @override
  void dispose() {
    _viewModel.stopPolling();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ChatViewModel>(
        builder: (_, viewModel, __) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Hero(tag: "profile-pic", child:  CircleAvatar(child: Icon(Icons.person))),
                  const SizedBox(width: 8),
                  Text('${widget.user.firstName} ${widget.user.lastName}'),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    reverse: true,
                    itemCount: viewModel.messages.length,
                    itemBuilder: (_, index) {
                      final msg = viewModel.messages[
                      viewModel.messages.length - 1 - index];
                      final isMe =
                          msg.sender.username != widget.user.username;

                      final bgColor = isMe
                          ? (isDark ? Colors.blue[700] : Colors.blue[100])
                          : (isDark ? Colors.grey[800] : Colors.grey[300]);

                      final textColor =
                      isDark ? Colors.white : Colors.black;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.content,
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(
                            color:
                            Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color:(isTyping ? Colors.blue[700] : Colors.blue[100]),
                        ),
                        onPressed: () {
                          final text = _controller.text.trim();
                          if (text.isNotEmpty) {
                            _viewModel.sendMessage(
                                widget.user.username, text);
                            _controller.clear();
                          }
                        },

                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
