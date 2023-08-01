import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChildInfoInputScreen extends StatefulWidget {
  @override
  _ChildInfoInputScreenState createState() => _ChildInfoInputScreenState();
}

class _ChildInfoInputScreenState extends State<ChildInfoInputScreen> {
  String _childName = '';
  String _selectedGender = '';
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/profile.png',
                width: 150,
                height: 150,
              ),
              // 파랑색 사각형을 둥글게 만든 DecoratedBox
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 450,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('이름', style: TextStyle(fontSize: 14.0)),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _childName = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: '이름을 입력하세요',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('생년월일', style: TextStyle(fontSize: 14.0)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 70,
                                  child: DropdownButton<int>(
                                    value: _selectedYear,
                                    onChanged: (year) {
                                      setState(() {
                                        _selectedYear = year;
                                      });
                                    },
                                    hint: Text('yyyy',
                                        style: TextStyle(fontSize: 14.0)),
                                    items: List.generate(
                                      15,
                                      (index) => DropdownMenuItem(
                                        value: DateTime.now().year - 14 + index,
                                        child: Text(
                                          '${DateTime.now().year - 14 + index}',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text('년'),
                                SizedBox(width: 20),
                                SizedBox(
                                  width: 70,
                                  child: DropdownButton<int>(
                                    value: _selectedMonth,
                                    onChanged: (month) {
                                      setState(() {
                                        _selectedMonth = month;
                                      });
                                    },
                                    hint: Text('mm',
                                        style: TextStyle(fontSize: 14.0)),
                                    items: List.generate(
                                      12,
                                      (index) => DropdownMenuItem(
                                        value: index + 1,
                                        child: Text(
                                          '${index + 1}월',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text('월'),
                                SizedBox(width: 20),
                                SizedBox(
                                  width: 70,
                                  child: DropdownButton<int>(
                                    value: _selectedDay,
                                    onChanged: (day) {
                                      setState(() {
                                        _selectedDay = day;
                                      });
                                    },
                                    hint: Text('dd',
                                        style: TextStyle(fontSize: 14.0)),
                                    items: List.generate(
                                      31,
                                      (index) => DropdownMenuItem(
                                        value: index + 1,
                                        child: Text(
                                          '${index + 1}일',
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text('일'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('성별', style: TextStyle(fontSize: 14.0)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedGender = '여성';
                                      });
                                    },
                                    icon: Icon(Icons.female),
                                    color: _selectedGender == '여성'
                                        ? Colors.pink
                                        : Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedGender = '남성';
                                      });
                                    },
                                    icon: Icon(Icons.male),
                                    color: _selectedGender == '남성'
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              //로그인 시 함수 입력
                            },
                            child: Text(
                              '시작하기',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFffcb39),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              fixedSize: Size(165, 48),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}