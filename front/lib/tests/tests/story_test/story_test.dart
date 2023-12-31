import 'package:flutter/material.dart';
import 'package:snail/tests/tests/story_test/chat_bubble.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:html' as html;
import 'package:snail/tests/tests/story_test/Answer_check.dart';
import 'package:snail/tests/eyetracking.dart';
import 'package:camera/camera.dart';
import 'package:just_audio/just_audio.dart';

class StoryTestScreen extends StatefulWidget {
  final int videoNum; // 실행된 비디오 index
  StoryTestScreen({required this.videoNum});
  @override
  _StoryTestScreenState createState() => _StoryTestScreenState();
}

class _StoryTestScreenState extends State<StoryTestScreen> {
  bool showGreetBubble = false;
  bool showQuestionBubble = false;
  bool showAnswerBubble = false;
  bool showEndBubble = false;
  int answeredBubbleCount = 0;
  String userInput = '';

  final player = AudioPlayer();
  final _speech = stt.SpeechToText();
  late CameraController _controller;
  late var imgSender;

  //정답
  List<String> Answer = [''];

  //정답 체크
  List<bool> checkAnswerAtBack = [];

  //1. 우리끼리 가자 2. 내 꿈은 무슨 색일까
  List<List> Question = [
    [
      '지금 동물 마을의 계절은 무엇인가요?',
      '겨울잠을 잔다고 말하면서 나무 구멍으로 들어간 동물 친구는 누구였나요?',
      '맛있는 물고기를 잡으로 물에 뛰어든 동물 친구는 누구였나요?',
      '아기 토끼가 여우가 쫒아온다고 소리치자 산양 할아버지는 어떻게 여우를 쫓아 냈나요?',
      '아기 토끼가 산양 할아버지를 찾아 간 이유는 무엇인가요?'
    ],
    [
      '위험에 빠진 사람들을 구해주는 소방관이 되는 꿈은 무슨 색인가요?',
      '아이들에게 이것 저것 알려주는 선생님이 되는 꿈은 무슨 색인가요?',
      '할머니가 가져오신 신비로운 함에는 무엇이 들어있었나요?',
      '꿈의 색을 이것저것 섞어보던 아름이는 왜 울었을까?',
      '할머니께서는 오색 색동옷을 입으면 옷을 입은 사람에게 무슨 일이 일어난다고 하셨나요?'
    ]
  ];

  @override
  void initState() {
    super.initState();
    openCamera();
    _showBubblesStart().then((_) {
      _speech.initialize();
      startQuestionSequence();
    });
  }

  Future<void> openCamera() async {
    _controller = await initializeCamera();

    imgSender = FaceImgSender(_controller);
    imgSender.startSending();
  }

  List<String> temp = [];
  int correctNum = 0;

  void startQuestionSequence() async {
    print(Answer);
    if (answeredBubbleCount < Question[widget.videoNum].length) {
      _showBubbleQuestion();
      _onAnswerBubbleSubmitted();
    } else {
      setState(() {
        temp = List.from(Answer); //넘겨주는 data는 Answer의 0 index 삭제
      });
      temp.removeAt(0);
      correctNum = await checkAnswers(temp, widget.videoNum);
      _showBubbleLast();
    }
  }

  Future<void> _showBubblesStart() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        showGreetBubble = true;
      });
    });
    await player.setAsset('assets/sounds/story_test/startbubble01.wav');
    await player.play();

    await player.processingStateStream.firstWhere((state) => state == ProcessingState.completed);

    await player.setAsset('assets/sounds/story_test/startbubble02.wav');
    await player.play();
    
    await player.processingStateStream.firstWhere((state) => state == ProcessingState.completed);

    await player.setAsset('assets/sounds/story_test/startbubble03.wav');
    await player.play();

    await Future.delayed(Duration(seconds: 5));
  }

  //문제 생성
  void _showBubbleQuestion() async {
    userInput = '';
    await Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        showQuestionBubble = true;
        showAnswerBubble = true; // 응답 말풍선을 표시
      });
    });
    getNextQuestion();
  }

Widget _questionAndAnswer(int questionIndex) {
    return Column(children: [
        AnimatedContainer(
            duration: Duration(seconds: 30),
            curve: Curves.easeInOut,
            height: showQuestionBubble ? null : 0,
            child: QuestionBubbleFromService(
                text: Question[widget.videoNum][questionIndex]),
        ),
        if (answeredBubbleCount == questionIndex + 1)
            FutureBuilder(
                future: Future.delayed(Duration(seconds: 2)), // 질문 후 정답 버블이 나오는 시간
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                    } else {
                        return AnimatedContainer(
                            duration: Duration(seconds: 30),
                            curve: Curves.easeInOut,
                            height: showAnswerBubble ? null : 0,
                            child: questionIndex >= Answer.length - 1
                                ? BubbleFromChildBefore()
                                : BubbleFromChildAfter(Answer: Answer[questionIndex + 1]),
                        );
                    }
                }
            ),
        if (answeredBubbleCount != questionIndex + 1)
            AnimatedContainer(
                duration: Duration(seconds: 30),
                curve: Curves.easeInOut,
                height: showAnswerBubble ? null : 0,
                child: questionIndex >= Answer.length - 1
                    ? BubbleFromChildBefore()
                    : BubbleFromChildAfter(Answer: Answer[questionIndex + 1]),
            ),
    ]);
}

void getNextQuestion() async {
    await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
    if (!_speech.isListening) {
      _speech.listen(
        listenFor: Duration(seconds: 14),
        pauseFor: Duration(seconds: 30),
        cancelOnError: true,
        partialResults: true,
        localeId: 'ko-KR',
        listenMode: stt.ListenMode.dictation,
        onResult: (result) async {
          userInput = result.recognizedWords;
          if (result.finalResult) {
            Answer.add(userInput);
            startQuestionSequence();
          }
        },
      );
    }
    Future.delayed(Duration(seconds: 16), () {
      if (!_speech.isListening && userInput == '') {
        userInput = '정답이 입력되지 않았어요.';
        Answer.add(userInput);
        startQuestionSequence();
      }
    });
  }

  void _showBubbleLast() async {
    setState(() {
      showEndBubble = true;
    });

    await player.setAsset('assets/sounds/story_test/endbubble01.wav');
    await player.play();

    await player.processingStateStream.firstWhere((state) => state == ProcessingState.completed);

    await player.setAsset('assets/sounds/story_test/endbubble02.wav');
    await player.play();

    await player.processingStateStream.firstWhere((state) => state == ProcessingState.completed);

    await Future.delayed(Duration(seconds: 2));
    
    int etCount = imgSender.stopSending();
    Navigator.pop(context, [correctNum, etCount]);
  }

  void _onAnswerBubbleSubmitted() {
    setState(() {
      answeredBubbleCount += 1; //응답한 말풍선 개수 더함
    });
  }

  @override
  void dispose() {
    _speech.stop(); // Stop the speech recognition
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              /*
              image: DecorationImage(
                image: AssetImage('assets/background_story.png'),
                fit: BoxFit.fill,
              ),
              */
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              //좌우: 200, 상하: 50
              padding: EdgeInsets.fromLTRB(150, 50, 150, 50),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 30000),
                    curve: Curves.easeInOut,
                    height: showGreetBubble ? null : 0,
                    child: GreetBubbleFromService(),
                  ),
                  if (answeredBubbleCount >= 1) _questionAndAnswer(0),
                  if (answeredBubbleCount >= 2) _questionAndAnswer(1),
                  if (answeredBubbleCount >= 3) _questionAndAnswer(2),
                  if (answeredBubbleCount >= 4) _questionAndAnswer(3),
                  if (answeredBubbleCount >= 5) _questionAndAnswer(4),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 30000),
                    curve: Curves.easeInOut,
                    height: showEndBubble ? null : 0,
                    child: EndBubbleFromService(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
