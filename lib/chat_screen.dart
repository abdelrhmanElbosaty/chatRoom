import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  List messages = [
    ChatMessage(
        message: 'FirstMessage ',
        isOwner: true,
        messageType: MessageType.audio),
    ChatMessage(
        message: 'secondMessage',
        isOwner: true,
        messageType: MessageType.image,
        image:
            'https://upload.wikimedia.org/wikipedia/commons/4/41/Sunflower_from_Silesia2.jpg'),
    ChatMessage(
        message: 'thirdMessage', isOwner: false, messageType: MessageType.text),
    ChatMessage(
        message: 'fourthMessage',
        isOwner: false,
        messageType: MessageType.text),
    ChatMessage(
        message: 'FifthMessage', isOwner: true, messageType: MessageType.text),
    ChatMessage(
        message: 'FirstMessage',
        isOwner: false,
        messageType: MessageType.audio),
    ChatMessage(
        message: 'secondMessage', isOwner: true, messageType: MessageType.text),
    ChatMessage(
        message: 'thirdMessage',
        isOwner: false,
        messageType: MessageType.image,
        image:
            'https://upload.wikimedia.org/wikipedia/commons/4/41/Sunflower_from_Silesia2.jpg'),
    ChatMessage(
        message: 'fourthMessage', isOwner: true, messageType: MessageType.text),
    ChatMessage(
        message: 'FifthMessage', isOwner: true, messageType: MessageType.text),
    ChatMessage(
        message: 'FirstMessage', isOwner: false, messageType: MessageType.text),
    ChatMessage(
        message: 'secondMessage',
        isOwner: false,
        messageType: MessageType.text),
    ChatMessage(
        message: 'thirdMessage', isOwner: true, messageType: MessageType.text),
    ChatMessage(
        message: 'fourthMessage', isOwner: true, messageType: MessageType.text),
    ChatMessage(
        message: 'FifthMessage', isOwner: false, messageType: MessageType.text),
  ];

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildChatEntry(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.orange,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Abdelrahman',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                'last seen',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        chatIcons(
          icon: Icons.call_outlined,
          color: Colors.black,
          onPressed: () {},
        ),
        chatIcons(
          icon: Icons.video_call_outlined,
          color: Colors.black,
          onPressed: () {},
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }

  Widget buildChatEntry() {
    return Column(
      children: [
        Expanded(child: buildChatBody()),
        Container(
          padding:
              const EdgeInsets.only(bottom: 24, left: 16, right: 24, top: 8),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              chatIcons(
                icon: Icons.mic,
                color: Colors.black,
                onPressed: () {},
              ),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      chatIcons(
                        icon: Icons.emoji_emotions_outlined,
                        color: Colors.black,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.black12,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type message',
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      chatIcons(
                        icon: Icons.attach_file,
                        color: Colors.black,
                        onPressed: () {},
                      ),
                      chatIcons(
                        icon: Icons.camera_alt_outlined,
                        color: Colors.black,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildChatBody() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) => chatMessages(messages[index]),
          ),
        ),
      ],
    );
  }

  Widget chatMessages(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            !message.isOwner ? MainAxisAlignment.start : MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          !message.isOwner
              ? Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 14,
                    ),
                    const SizedBox(width: 8),
                    messageContainer(message)
                  ],
                )
              : messageContainer(message)
        ],
      ),
    );
  }

  Widget messageContainer(ChatMessage message) {
    return Container(
      decoration: BoxDecoration(
        color: !message.isOwner ? Colors.grey[300] : Colors.grey,
        borderRadius: !message.isOwner
            ? const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(8),
                bottomStart: Radius.circular(0),
                topEnd: Radius.circular(8),
                topStart: Radius.circular(8),
              )
            : const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(0),
                bottomStart: Radius.circular(8),
                topEnd: Radius.circular(8),
                topStart: Radius.circular(8),
              ),
      ),
      // padding: const EdgeInsets.all(8),
      child: buildMessage(message),
    );
  }

  Widget buildMessage(ChatMessage message) {
    switch (message.messageType) {
      case MessageType.text:
        return textMessage(message);
      case MessageType.audio:
        return audioMessage(message);
      case MessageType.image:
        return imageMessage(message);
    }
  }

  Widget textMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message.message,
        style: TextStyle(
          color: !message.isOwner ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget audioMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
        child: SizedBox(
          height: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 21,
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Container(
                    width: 95, //MediaQuery.of(context).size.width,
                    height: 2,
                    color: Colors.black,
                  ),
                  Positioned(
                    left: 54,
                    child: Container(
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 4,
              ),
              const Text('5:33'),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageMessage(ChatMessage message) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      height: 110,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: !message.isOwner
            ? const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(8),
                bottomStart: Radius.circular(0),
                topEnd: Radius.circular(8),
                topStart: Radius.circular(8),
              )
            : const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(0),
                bottomStart: Radius.circular(8),
                topEnd: Radius.circular(8),
                topStart: Radius.circular(8),
              ),
      ),
      child: Image.network('${message.image}', fit: BoxFit.cover),
    );
  }

  Widget chatIcons(
      {required IconData icon,
      required Color color,
      required Function onPressed}) {
    return IconButton(
      onPressed: () {
        onPressed;
      },
      constraints: const BoxConstraints(
        maxHeight: 40,
        // maxWidth: 30,
        // minWidth: 20
      ),
      icon: Icon(
        icon,
        color: color,
      ),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}

class ChatMessage {
  late String message;
  late bool isOwner;
  late MessageType messageType;
  String? image;

  ChatMessage(
      {required this.message,
      required this.isOwner,
      required this.messageType,
      this.image});
}

enum MessageType {
  text,
  image,
  audio,
}
