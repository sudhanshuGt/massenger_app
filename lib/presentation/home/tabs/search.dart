import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/chat_user_info.dart';
import '../../../viewmodel/chat_viewmodel.dart';
import '../../chats/users_chat.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final viewModel = Provider.of<ChatViewModel>(context, listen: false);
    final query = _controller.text.trim();
    viewModel.searchUsers(query);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Search username...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (_controller.text.length < 3)
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_sharp,
                    size: 100,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 20),
                  Text(
                    "Let’s search the users around you\nand connect with them",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          else if (viewModel.isSearching)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (viewModel.searchResults.isEmpty)
              const Expanded(child: Center(child: Text("No users found.")))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = viewModel.searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(user.firstName[0])),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.bio),
                      onTap: () {
                        final receiver = UserInfoModel(
                          username: user.username,
                          firstName: user.firstName,
                          lastName: user.lastName,
                          bio: user.bio,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(user: receiver),
                          ),
                        );
                      }
                      ,
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
