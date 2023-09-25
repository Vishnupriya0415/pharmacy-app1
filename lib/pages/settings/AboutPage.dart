// ignore_for_file: file_names, sized_box_for_whitespace

import 'FAQ.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About App',
          style: TextStyle(
            fontSize: 18,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            color: Colors.indigo,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('assets/images/tablets/logo1.png'),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Introducing our Medical Delivery App: Your Trusted Delivery Partner',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14, // Adjust the font size as needed
                      color: Colors.black, // You can also set the color here
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'With our app, you can effortlessly order prescription '
                            'from the comfort of your home. Say goodbye to long queues'
                            ' and the hassle of visiting pharmacies'
                            ' – we bring your essential medications right to your doorstep.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Our Vision',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10), // Adjust the padding as needed
                child: RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14, // Adjust the font size as needed
                      color: Colors.black, // You can also set the color here
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'Our vision is to ensure universal access to vital medications and healthcare products,'
                            ' revolutionizing medical solutions. Our app will serve as a reliable, personalized source'
                            ' for timely healthcare. Through innovation,'
                            ' we\'ll unify patients and pharmacies, prioritizing health and well-being.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14, // Adjust the font size as needed
                      color: Colors.black, // You can also set the color here
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            "\"We are here to assist you at any time with any questions or"
                            " concerns you may have about our application. "
                            "Your satisfaction and well-being are our top priorities.\"",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                " Customer care",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(height: 3),
              const Row(
                children: [
                  Spacer(),
                  Icon(
                    Icons.phone,
                    size: 20,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 15),
                  Text(
                    ' +91 89813 00000',
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(" You can also contact us through "),
              Row(
                children: [
                  const Spacer(),
                  Image.asset('assets/images/tablets/instagram.webp',
                      height: 20, width: 20),
                  const SizedBox(width: 20),
                  Image.asset('assets/images/tablets/facebook.jpg',
                      height: 30, width: 30),
                  const SizedBox(width: 20),
                  Image.asset('assets/images/tablets/twitter.png',
                      height: 20, width: 20),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/tablets/Whatsapp.webp',
                      height: 30, width: 30),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.9,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      // ignore: prefer_const_constructors
                      MaterialPageRoute(builder: (context) => FAQPAge()),
                    );
                  },
                  child: const Card(
                    child: Text(
                      "FAQ ",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
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
