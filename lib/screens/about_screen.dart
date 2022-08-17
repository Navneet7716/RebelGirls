import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rebel_girls/utils/colors.dart';

final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/rebelgirls-d3f0d.appspot.com/o/gallery%2FWhatsApp%20Image%202022-06-03%20at%201.41.59%20PM%20(1).jpeg?alt=media&token=a0049610-886a-41e7-b89b-059ef3ecad19',
  'https://firebasestorage.googleapis.com/v0/b/rebelgirls-d3f0d.appspot.com/o/gallery%2FWhatsApp%20Image%202022-06-03%20at%201.41.59%20PM%20(2).jpeg?alt=media&token=43a8810b-01fa-4bce-b7ea-5a274bf3344e',
  'https://firebasestorage.googleapis.com/v0/b/rebelgirls-d3f0d.appspot.com/o/gallery%2FWhatsApp%20Image%202022-06-03%20at%201.41.59%20PM%20(3).jpeg?alt=media&token=9dfb35c6-1bdc-40ee-9e83-0cdf7700560b',
  'https://firebasestorage.googleapis.com/v0/b/rebelgirls-d3f0d.appspot.com/o/gallery%2FWhatsApp%20Image%202022-06-03%20at%201.41.59%20PM.jpeg?alt=media&token=a2e4d55e-aeb7-44d3-bfe6-9c69be66271b',
  'https://firebasestorage.googleapis.com/v0/b/rebelgirls-d3f0d.appspot.com/o/gallery%2FWhatsApp%20Image%202022-06-03%20at%201.47.31%20PM.jpeg?alt=media&token=c0b6fabf-709d-47c0-ae6c-c59df93bf739',
];

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
        title: const Text(
          'About Us',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins-Bold',
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: imageSliders,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 16),
                      text:
                          "Over the past few years, young social activists have been leading global conversations to drive actions that end poverty, protect the planet, and ensure that all people enjoy peace and prosperity. Today’s youth is raising its voice to be heard, speaking up for those who have been marginalized, demanding an equal and just society to live in.",
                      children: <InlineSpan>[
                        TextSpan(
                          text:
                              "\n\nIn a quest to empower young voices like themselves, brother-sister duo Kartikeya & Nitya founded Rebel Girls in November 2017, at the young age of 11 and 9 years.",
                        ),
                        TextSpan(
                          text:
                              "\n\nA youth-led mentoring platform for boys and girls, Rebel Girls aims to inspire children through interactions with extraordinary women, “the rebels”, the ones who have broken barriers and dared to achieve their dreams.",
                        ),
                        TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          text:
                              """\n\n “If you want to do something, work hard towards it and you will achieve it.
Dream. Believe. Dare. Achieve.” """,
                        ),
                        TextSpan(
                          text:
                              "\n\nThrough these interactive and fun sessions, children learn about the intersectionality of various aspects of discrimination and gender inequality that impact choices for women and girls- from violence to social norms to disability to prevalent stereotypes. They also explore a wide range complex issues ranging from ideas of good governance, civic challenges and how to drive change in society to the role of a humanitarian aid worker and various reasons for human displacement, including war, genocide, natural calamities to girls pursuing careers in STEM and sports.",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: const DecorationImage(
                          image: CachedNetworkImageProvider(
                            'https://rebelgirls.in/wp-content/uploads/2020/10/WhatsApp-Image.jpeg',
                          ),
                          fit: BoxFit.fill,
                          // alignment: FractionalOffset.topCenter,
                        ),
                      )),
                    ),
                  ),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromARGB(255, 13, 13, 13),
                            Color.fromARGB(0, 48, 48, 48),
                          ],
                        )),
                    width: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Founders',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Pacifico',
                          fontSize: 37,
                        ),
                      ),
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

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: item,
                    fit: BoxFit.cover,
                    width: 1000.0,
                  ),
                ],
              )),
        ))
    .toList();
