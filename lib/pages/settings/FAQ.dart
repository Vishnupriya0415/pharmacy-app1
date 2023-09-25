// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class FAQPAge extends StatelessWidget {
  const FAQPAge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title:const  Text(" Frequently Asked Questions",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Set background color to transparent
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.left,
                  text:const  TextSpan(
                    style: TextStyle(
                      fontSize: 14, // Adjust the font size as needed
                      color: Colors.black, // You can also set the color here
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: " Welcome to our FAQ section! Here are some common questions "
                            "our customers often ask, Feel free to contact us if your question is not covered here"
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20,),
              FAQItem(
                question: 'How does this medicine delivery application work?',
                answer:
                'Our medicine delivery application helps you choose a medical store that is near to you. You can order medicine by simply scanning the prescription using the app. Browse available medical stores, select the one you prefer, and place your order with ease.',
              ),
              FAQItem(question: 'How do i place an order for medicines using this app?',
                  answer: ' Placing an order is easy! After scanning your prescription or searching '
                      'for the medicines you need, the app will show you a list of available medicines and nearby pharmacies.'
                      ' You can choose a pharmacy, review your order, provide your delivery address, and then '
                      'simply confirm and place your order. It\'s a convenient way to get your medicines delivered right to your doorstep'
              ),
              FAQItem(question: 'How do i upload my prescription to the app?',
                  answer: ' Yes, you can either scan your prescription using the app\'s camera or manually enter the'
                      ' details to order medicines.'),
              FAQItem(question: ' What payment methods are accepted ?',
                  answer:'  We accept various payment methods, including credit/debit cards, mobile wallets, and online banking. '
                      'You can choose the one that\'s most convenient for you.'),
              FAQItem(question: ' Is my personal and medical information secure?',
                  answer: ' Yes, we prioritize the security of your data. We use encryption and follow strict privacy policies to'
                      ' protect your personal and medical information.'),
              FAQItem(question: ' Can i cancel or modify my order after placing it?',
                  answer: 'Depending on the status of your order, you may be able to cancel or modify it. '
                      'Contact our customer support as soon as possible for assistance.'),
              FAQItem(question: 'How can i contact customer support?',
                  answer: 'You can reach our customer support through the app\'s help section, '
                      'or you can call our helpline at [+81 &9813 00000].'),
              FAQItem(question: 'What if i receive  the wrong medicines or there\'s an issue with my order? ',
                  answer: 'We understand that accuracy is crucial when it comes to your'
                      ' medicines. If you receive the wrong medicines or encounter any issues with '
                      'your order, please contact our customer support immediately. Our dedicated support '
                      'team will work swiftly to resolve the problem. You can reach us through the app\'s customer'
                      ' support chat, helpline number, or email. We\'re committed to ensuring your satisfaction'
                      ' and well-being, and we\'ll take all necessary steps to make things right for you. Your'
                      ' trust in our service is of the utmost importance to u  '
                      ' '),
              FAQItem(question: 'How do i find nearby pharmacies?',
                  answer: 'The app uses your location to show you a list of pharmacies near you. '
                      'You can also search for specific pharmacies or medicines.'),
            ],
          ),

        ),
      ),
    );
  }
}
class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  // ignore: prefer_const_constructors_in_immutables
  FAQItem({super.key, required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(widget.question, style:const  TextStyle(color: Colors.black),),
        collapsedBackgroundColor: Colors.grey.shade100,
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.answer,
              style:const  TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
