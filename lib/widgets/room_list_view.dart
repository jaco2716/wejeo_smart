import 'package:flutter/material.dart';

class RoomsListView extends StatefulWidget {
  final List<List<String>> roomsList;
  const RoomsListView({Key? key, required this.roomsList}) : super(key: key);

  @override
  State<RoomsListView> createState() => _RoomsListViewState();
}

class _RoomsListViewState extends State<RoomsListView> {
  int selectedRoom = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        itemCount: widget.roomsList.length + 1,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          if (index == widget.roomsList.length) {
            return SizedBox(
              height: 70,
              width: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit, size: 30),
                ],
              ),
            );
          } else {
            return Container(
                padding: const EdgeInsets.all(3),
                decoration: index == selectedRoom
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        // border: Border.all(color: Colors.white, width: 2),
                        color: Colors.white,
                      )
                    : null,
                width: 280,
                height: 120,
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                      onTap: () => changeSelected(index),
                      child: CardWithImage(imagePath: widget.roomsList[index][0], title: widget.roomsList[index][1], status: true)),
                ));
          }
        },
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  void changeSelected(int index) {
    setState(() {
      selectedRoom = index;
    });
  }
}

class CardWithImage extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool status;

  const CardWithImage({Key? key, required this.imagePath, required this.title, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Ink.image(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Ink(
            color: Colors.black45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Devices: 3', style: TextStyle(fontSize: 16, color: Colors.grey[300], fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }
}
