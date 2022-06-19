import 'package:flutter/material.dart';
import 'package:rebel_girls/utils/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text(
          'About Us',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Pacifico', fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 200.0,
                    spreadRadius: 1,
                    color: Color.fromARGB(255, 139, 139, 139))
              ]),
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
                          image: NetworkImage(
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                elevation: 14,
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
          ],
        ),
      ),
    );
  }
}
