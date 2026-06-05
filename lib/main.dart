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
