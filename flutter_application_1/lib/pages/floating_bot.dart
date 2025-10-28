import 'package:flutter/material.dart';

class FloatingBot extends StatefulWidget {
  @override
  _FloatingBotState createState() => _FloatingBotState();
}

class _FloatingBotState extends State<FloatingBot> {
  bool _isChatOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Floating Icon Button (like Edge Copilot)
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isChatOpen = !_isChatOpen;
              });
            },
            child: Image.asset('assets/images/photo.png'), // Your Gemini image
            backgroundColor: Colors.blue[700],
            elevation: 8,
          ),
        ),

        // Chat Interface
        if (_isChatOpen)
          Positioned(
            bottom: 80,
            right: 20,
            child: Container(
              width: 350,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'MAXIM AI Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isChatOpen = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Chat messages area
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        // Your chat messages will go here
                      ],
                    ),
                  ),

                  // Input area
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Ask me anything...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            // Send message logic
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}