import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blueAccent,
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==========================================
// 1. AUTHENTICATION / LOGIN SCREEN
// ==========================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _fullName = '';
  String _selectedRole = 'student';
  bool _isLoginMode = true;

  void _submitAuthForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();

    // Simulating database routing based on selected role
    if (_isLoginMode) {
      // For demo purposes: if logging in, we default to student.
      // In a real app, Firebase tells us their exact role.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (ctx) => const StudentDashboard(userName: "User")),
      );
    } else {
      // During signup, route directly to the chosen role
      if (_selectedRole == 'teacher') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (ctx) => TeacherDashboard(teacherName: _fullName)),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (ctx) => StudentDashboard(userName: _fullName)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLoginMode ? 'Welcome Back!' : 'Create an Account',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 20),
                    if (!_isLoginMode) ...[
                      TextFormField(
                        key: const ValueKey('name'),
                        decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder()),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your name' : null,
                        onSaved: (value) => _fullName = value!,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                            labelText: 'I want to join as a:',
                            border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(
                              value: 'student',
                              child: Text('Student (Learn English)')),
                          DropdownMenuItem(
                              value: 'teacher',
                              child: Text('Teacher (Earn Money)')),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedRole = value!),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      key: const ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder()),
                      validator: (value) => value!.contains('@')
                          ? null
                          : 'Please enter a valid email address',
                      onSaved: (value) => _email = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('password'),
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password', border: OutlineInputBorder()),
                      validator: (value) => value!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitAuthForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(_isLoginMode ? 'Login' : 'Sign Up'),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _isLoginMode = !_isLoginMode),
                      child: Text(_isLoginMode
                          ? 'Create new account'
                          : 'I already have an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. STUDENT DASHBOARD SCREEN
// ==========================================
class StudentDashboard extends StatelessWidget {
  final String userName;
  const StudentDashboard({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const AuthScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, $userName! 👋',
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const Text('Ready to practice your spoken English today?',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Action Button to Call
            Card(
              color: Colors.blue[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.phone_in_talk,
                    color: Colors.blue, size: 36),
                title: const Text('Start Audio Lesson',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text(
                    'Connect instantly with an online native teacher'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AudioCallScreen(
                        remotePartyName: "Teacher Sarah",
                        userRole: "student",
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Connecting to audio server...')));
                },
              ),
            ),
            const SizedBox(height: 24),

            const Text('Your Past Sessions & Scores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Sample list of recorded historical sessions
            Expanded(
              child: ListView(
                children: const [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Session with Teacher Sarah'),
                      subtitle: Text('Recorded: Yesterday • Score: 85/100'),
                      trailing:
                          Icon(Icons.play_circle_fill, color: Colors.blue),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Session with Teacher John'),
                      subtitle: Text('Recorded: May 28 • Score: 78/100'),
                      trailing:
                          Icon(Icons.play_circle_fill, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. TEACHER DASHBOARD SCREEN
// ==========================================
class TeacherDashboard extends StatelessWidget {
  final String teacherName;
  const TeacherDashboard({Key? key, required this.teacherName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hardcoded logic values for design demonstration
    int completedSessions = 6;
    double payoutProgress = completedSessions / 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const AuthScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, Teacher $teacherName!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text(
                'Keep up the great work helping students speak confidently.',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Payout Tracking Widget
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Milestone Payout Tracker',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('$completedSessions of 10 sessions completed',
                        style: const TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: payoutProgress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.teal,
                      minHeight: 12,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '💡 Payout will trigger automatically upon completing 10 successful review-backed sessions.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Recent Student Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                children: const [
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.star, color: Colors.white)),
                      title: Text('Student David given 90/100'),
                      subtitle: Text(
                          '"Great pacing, teacher helped me fix my pronunciation errors instantly."'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. Audio - Call Screen
// ==========================================
class AudioCallScreen extends StatefulWidget {
  final String remotePartyName; // Name of the person on the other end
  final String userRole; // 'student' or 'teacher'

  const AudioCallScreen(
      {Key? key, required this.remotePartyName, required this.userRole})
      : super(key: key);

  @override
  _AudioCallScreenState createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  // Call States
  bool _isMuted = false;
  bool _isSpeakerOn = true;

  // Timer States
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Formatting seconds into MM:SS display format
  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _endCall() {
    _timer?.cancel();

    // Show a small confirmation notification
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Call ended. Saving recording...'),
          backgroundColor: Colors.amber),
    );

    // Close the call screen and go back to the previous dashboard
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1a2e), // Deep dark premium background
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TOP SECTION: Status & Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, color: Colors.greenAccent, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Encrypted & Auto-Recording".toUpperCase(),
                    style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // MIDDLE SECTION: Profile avatar, Name, and Live Timer
            Column(
              children: [
                // Animated Pulsing Avatar Placeholder
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    ),
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    ),
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        widget.remotePartyName[0].toUpperCase(),
                        style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  widget.remotePartyName,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.userRole == 'student'
                      ? 'English Instructor'
                      : 'Student',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                      letterSpacing: 0.5),
                ),
                const SizedBox(height: 32),

                // Real-time Display Clock
                Text(
                  _formatTime(_secondsElapsed),
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontFamily: 'monospace'),
                ),
              ],
            ),

            // BOTTOM SECTION: Control Deck
            Container(
              padding: const EdgeInsets.all(32.0),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xff16162a),
                borderRadius: BorderRadius.circular(30),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute Microphone button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        iconSize: 32,
                        icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                        color: _isMuted ? Colors.redAccent : Colors.white,
                        onPressed: () {
                          setState(() {
                            _isMuted = !_isMuted;
                          });
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(_isMuted ? "Muted" : "Mute",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),

                  // Red Hang-Up Call button
                  FloatingActionButton(
                    heroTag: "hangup",
                    backgroundColor: Colors.red,
                    onPressed: _endCall,
                    child: const Icon(Icons.call_end,
                        size: 28, color: Colors.white),
                  ),

                  // Speaker Toggle button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        iconSize: 32,
                        icon: Icon(
                            _isSpeakerOn ? Icons.volume_up : Icons.volume_down),
                        color: _isSpeakerOn ? Colors.blueAccent : Colors.white,
                        onPressed: () {
                          setState(() {
                            _isSpeakerOn = !_isSpeakerOn;
                          });
                        },
                      ),
                      const SizedBox(height: 4),
                      Text("Speaker",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
