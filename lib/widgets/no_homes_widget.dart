import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoHomesWidget extends StatelessWidget {
  const NoHomesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15, width: double.infinity),
          Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 28.0),
                  child: Icon(
                    CupertinoIcons.arrow_turn_left_up,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 58, top: 33),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 3,
                      color: Colors.grey,
                    )),
              ),
              // SizedBox(width: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 11, 22, 20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'No homes created.\nAdd your Smart Home!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: double.infinity),
            ],
          ),
          ConstrainedBox(constraints: const BoxConstraints(maxWidth: 400), child: Image.asset('assets/images/constructionHouse.png')),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
