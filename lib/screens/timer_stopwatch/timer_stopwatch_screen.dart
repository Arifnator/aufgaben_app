// Erstellung einer Timer  App (Stoppuhr App)
// Das Ziel
// Erstelle eine Timer App in Flutter.  Entweder als reine Timer App: Es läuft eine vorgegebene Anzahl an Sekunden (oder Minuten) ab,
// oder als Stoppuhr App: Es wird bei 0 gestartet, und die Zeit läuft nach oben. Wenn du schnell bist, kannst du auch eine App erstellen,
// die beide Funktionen bietet. Die Aufgabe soll helfen, die Nutzung von async und await zu verstehen und anzuwenden.
// Eingerechnet sind dafür die restlichen Tage bis zum Ende der Woche, auch wenn der Abgabetermin auf einem späteren Zeitpunkt liegt.

// Die Anforderungen
// Allgemeine Anforderungen
// Timer-Funktion (Option 1)
// Starten und Stoppen:
// Ein Button zum Starten des Timers.
// Ein Button zum Stoppen des Timers.
// Zeitwahl:
// Ein Input-Feld zur Eingabe der Timer-Dauer (z.B. in Sekunden).
// Anzeige:
// Eine Anzeige, die die verbleibende Zeit in Minuten und Sekunden zeigt.
// Benachrichtigung:
// Eine einfache Benachrichtigung (z.B. Text, Snack-Bar, Hintergrund wechselt auf Grün, etc…), wenn der Timer abgelaufen ist.
// Async und Await:
// Nutze async und await, um den Timer asynchron zu betreiben, sodass die UI nicht blockiert wird.
// Stoppuhr-Funktion (Option 2)
// Starten, Stoppen und Zurücksetzen:
// Ein Button zum Starten der Stoppuhr.
// Ein Button zum Stoppen der Stoppuhr.
// Ein Button zum Zurücksetzen der Stoppuhr.
// Anzeige:
// Eine Anzeige, die die verstrichene Zeit in Minuten, Sekunden und Millisekunden zeigt.
// Async und Await:
// Nutze async und await, um die Zeitmessung asynchron durchzuführen, sodass die UI nicht blockiert wird.

// Optionale Anforderungen (für zusätzliche Herausforderung)
// Beides Kombinieren:
// Eine App erstellen, die sowohl Timer- als auch Stoppuhr-Funktionen bietet und über eine Navigation bar

// Hinweise und Tipps
// Async und Await: Stelle sicher, dass du async und await verwendest, um die Timer- oder Stoppuhr-Funktionalität nicht-blockierend zu implementieren.
// State Management: Nutze setState, um Änderungen im UI entsprechend der Zeitmesser-Aktivität anzuzeigen.
// UI-Design: Halte das Design einfach und funktional. Halte dich vor allem am Anfang nicht zu sehr mit dem Styling auf und kümmere dich erstmal um die Funktionalitäten.
// Wenn du Lust hast, kannst du natürlich zuerst einen Entwurf in Figma machen und diesen nach detailgetreu coden.

// Abgabe
// Quellcode: Lade den vollständigen Quellcode der App in ein Github-Repository hoch und teile den Link.
// Vorstellung: Am Montag nach dem Urlaub (19.8.) werden 2-3 von euch ihre App vorstellen. Dabei soll es wie in der Vergangenheit einen kurze Übersicht der App geben und dann eine Erklärung des Codes.

// Viel Erfolg und viel Spaß beim Programmieren!

import 'package:flutter/material.dart';
import 'dart:async';

class TimerStopwatchScreen extends StatefulWidget {
  const TimerStopwatchScreen({super.key});

  @override
  State<TimerStopwatchScreen> createState() => _TimerStopwatchScreenState();
}

class _TimerStopwatchScreenState extends State<TimerStopwatchScreen> {
  bool isTimerRunning = false;
  bool isStopwatchRunning = false;

  int timerDuration = 0;
  int secondsElapsed = 0;

  late Timer timer;
  late Timer stopwatch;

  void startTimer() {
    setState(() {
      isTimerRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timerDuration > 0) {
        setState(() {
          timerDuration--;
        });
      } else {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Timer abgelaufen!")),
        );
        setState(() {
          isTimerRunning = false;
        });
      }
    });
  }

  void stopTimer() {
    setState(() {
      isTimerRunning = false; 
    });
    timer.cancel();
  }

  void startStopwatch() {
    setState(() {
      isStopwatchRunning = true;
    });
    stopwatch = Timer.periodic(const Duration(seconds: 1), (Timer stopwatch) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void stopStopwatch() {
    setState(() {
      isStopwatchRunning = false;
    });
    stopwatch.cancel();
  }

  void resetStopwatch() {
    setState(() {
      secondsElapsed = 0;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    stopwatch.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsElapsed % 60).toString().padLeft(2, '0');
    final timerMinutes = (timerDuration ~/ 60).toString().padLeft(2, '0');
    final timerSeconds = (timerDuration % 60).toString().padLeft(2, '0');
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xff61B688).withValues(alpha: .8),
              const Color(0xff61B688).withValues(alpha: .5),
              const Color(0xff61B688).withValues(alpha: .2)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Timer & Stopwatch"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SizedBox(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'Timer: $timerMinutes:$timerSeconds',
                style: const TextStyle(fontSize: 32),
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  onChanged: (value) {
                    timerDuration = int.tryParse(value) ?? 0;
                  },
                  decoration: InputDecoration(

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.transparent,
                      labelStyle: const TextStyle(color: Colors.black),
                      labelText: 'Timer-Dauer in Sekunden'),
                ),
              ),
              ElevatedButton(
                onPressed: isTimerRunning ? stopTimer : startTimer,
                child: Text(isTimerRunning ? 'Stoppen' : 'Starten'),
              ),
              const Divider(height: 50, color: Colors.black),
              Text(
                'Stopwatch: $minutes:$seconds',
                style: const TextStyle(fontSize: 32),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        isStopwatchRunning ? stopStopwatch : startStopwatch,
                    child: Text(isStopwatchRunning ? 'Stoppen' : 'Starten'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: resetStopwatch,
                    child: const Text('Zurücksetzen'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
