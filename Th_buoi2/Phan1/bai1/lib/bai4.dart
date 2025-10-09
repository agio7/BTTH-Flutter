import 'package:flutter/material.dart';

class Exercise04 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    const TextStyle styleProject =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header + avatar
            SizedBox(
              height: 250,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                    width: deviceWidth,
                    height: 200,
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30.0),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'CHIM CÁNH CỤT',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        Text(
                          'Flutter Software Engineer',
                          style:
                          TextStyle(fontSize: 20.0, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage:
                      AssetImage("assets/images/chimcanhcut.jpg"),
                    ),
                  )
                ],
              ),
            ),

            // Dãy hình ảnh
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/boxmagic.png", width: 80),
                Image.asset("assets/images/boxmagic.png", width: 80),
                Image.asset("assets/images/boxmagic.png", width: 80),
                Image.asset("assets/images/boxmagic.png", width: 80),
              ],
            ),

            // Thống kê
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("125", style: styleProject),
                    const Text("Projects"),
                  ],
                ),
                Column(
                  children: [
                    Text("185", style: styleProject),
                    const Text("Following"),
                  ],
                ),
                Column(
                  children: [
                    Text("1428", style: styleProject),
                    const Text("Follower"),
                  ],
                ),
              ],
            ),

            // About
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About", style: styleProject),
                  SizedBox(height: 10),
                  Text(
                    "is simply dummy text of the printing and typesetting industry. "
                        "Lorem Ipsum has been the industry's standard dummy text ever "
                        "since the 1500s ...",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {}, child: const Text('View Detail')),
                ElevatedButton(
                  onPressed: () {},
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),

            // Scroll ngang ảnh
            const SingleChildScrollView(
              padding: EdgeInsets.all(10),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Image(
                      image: AssetImage('assets/images/boxmagic.png'),
                      width: 180),
                  Image(
                      image: AssetImage('assets/images/boxmagic.png'),
                      width: 180),
                  Image(
                      image: AssetImage('assets/images/boxmagic.png'),
                      width: 180),
                  Image(
                      image: AssetImage('assets/images/boxmagic.png'),
                      width: 180),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
