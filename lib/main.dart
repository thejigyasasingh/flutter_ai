import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';



final model = GenerativeModel(
  model: 'gemini-2.5-flash', // Fast and cost-efficient for most apps
  apiKey: 'AIzaSyAIw2UzInxE730vy6qlVilmDT3OibM6Rt4',
);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AI Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Gemini AI Assistant'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controller to get text from the input field
  final TextEditingController _controller = TextEditingController();
  
  // Variables to manage state
  String _response = "Type something and hit the send icon!";
  bool _isLoading = false;

  Future<void> askAI() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = "Thinking...";
    });

    try {
      final content = [Content.text(_controller.text)];
      final response = await model.generateContent(content);
      
      setState(() {
        _response = response.text ?? "No response received.";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = "Error: $e";
        _isLoading = false;
        print("Error occurred: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the AI response
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: SelectableText(
                                _response,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Input field
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ask me anything...",
                  labelText: "Your Message",
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isLoading ? null : askAI,
          tooltip: 'Send to AI',
          child: _isLoading 
            ? const CircularProgressIndicator(color: Colors.white) 
            : const Icon(Icons.send),
        ),
      ),
    );
  }
}