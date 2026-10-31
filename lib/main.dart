
import 'package:flutter/material.dart';

void main() {
  runApp(const ClassVoteApp());
}

class Candidate {
  final String name;
  final String position;
  int votes;

  Candidate({
    required this.name,
    required this.position,
    this.votes = 0,
  });
}

class ClassVoteApp extends StatelessWidget {
  const ClassVoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ClassVote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const VotingScreen(),
    );
  }
}

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final TextEditingController voterController =
  TextEditingController();

  final List<Candidate> candidates = [
    Candidate(name: 'Alice', position: 'Class President'),
    Candidate(name: 'Brian', position: 'Class President'),
    Candidate(name: 'Diane', position: 'Class President'),
  ];

  final Set<String> voters = {};
  String message = '';

  void voteFor(Candidate candidate) {
    final voterName = voterController.text.trim().toLowerCase();

    if (voterName.isEmpty) {
      setState(() {
        message = 'Please enter your name first.';
      });
      return;
    }

    if (voters.contains(voterName)) {
      setState(() {
        message = 'You have already voted!';
      });
      return;
    }

    setState(() {
      voters.add(voterName);
      candidate.votes++;
      message = 'Your vote for ${candidate.name} was recorded!';
      voterController.clear();
    });
  }

  @override
  void dispose() {
    voterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClassVote'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Election Results',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ResultsScreen(candidates: candidates),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.how_to_vote,
            size: 65,
            color: Colors.indigo,
          ),
          const SizedBox(height: 10),
          const Text(
            'Class Election',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose your preferred class president.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          TextField(
            controller: voterController,
            decoration: const InputDecoration(
              labelText: 'Enter your full name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Candidates',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...candidates.map((candidate) {
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(candidate.name),
                subtitle: Text(candidate.position),
                trailing: ElevatedButton(
                  onPressed: () => voteFor(candidate),
                  child: const Text('Vote'),
                ),
              ),
            );
          }),
          const SizedBox(height: 15),
          if (message.isNotEmpty)
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 15),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ResultsScreen(candidates: candidates),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart),
            label: const Text('View Election Results'),
          ),
        ],
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final List<Candidate> candidates;

  const ResultsScreen({
    super.key,
    required this.candidates,
  });

  @override
  Widget build(BuildContext context) {
    final totalVotes = candidates.fold<int>(
      0,
          (sum, candidate) => sum + candidate.votes,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Election Results'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.emoji_events,
            size: 60,
            color: Colors.amber,
          ),
          const Text(
            'Election Results',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (totalVotes == 0)
            const Text(
              'No votes have been cast yet.',
              textAlign: TextAlign.center,
            )
          else
            ...candidates.map((candidate) {
              final percentage = candidate.votes / totalVotes * 100;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${candidate.votes} votes '
                            '(${percentage.toStringAsFixed(1)}%)',
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: candidate.votes / totalVotes,
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 15),
          Text(
            'Total votes: $totalVotes',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
