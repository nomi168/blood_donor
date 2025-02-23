import 'package:blood_donor/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'MenuScreen.dart';

class FAQs extends StatefulWidget {
  const FAQs({super.key});

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  Set<int> expandedItems = Set();

  List<Map<String, String>> faqsList = [
    {
      "question": "What is E Blood?",
      "answer":
          "BloodDonationHub is a centralized platform where you can find nearby blood donation centers, register to donate, and track your donation history."
    },
    {
      "question": "How do I create an account on E Blood?",
      "answer":
          "No need to create an account. Simply click on the “Sign In” button, enter your details, and follow the prompts to verify your email. Once verified, you can log in and start scheduling donations."
    },
    {
      "question": "How do I register for a blood donation?",
      "answer":
          "Once you find a suitable donation center, click on the “Register to Donate” button on its page. You will receive a confirmation, and you can track your upcoming appointments in your account."
    },
    {
      "question": "How do I update my donation details?",
      "answer":
          "When your donation is completed, you’ll receive a confirmation notification. You can update your health or personal details in the “Profile” section by clicking the “Update” button."
    },
    {
      "question":
          "What should I do if I'm unable to donate blood after registering?",
      "answer":
          "If you encounter any issues, such as health problems or scheduling conflicts, please contact the donation center to cancel or reschedule your appointment."
    },
    {
      "question": "How can I contact support for blood donation queries?",
      "answer":
          "You can contact our support team via the “nafeesmazhar1661@gmail.com”, or reach out to us through chat platforms like WhatsApp for immediate assistance."
    },
    {
      "question": "How does Eblood ensure the safety of my donations?",
      "answer":
          "All donations follow strict health protocols to ensure the safety of both the donor and recipient. The blood donation process is monitored, and equipment is sterilized. How is my personal information protected?\nWe take your privacy seriously. All personal information is encrypted and stored securely. We never share your data with third parties without your consent."
    }
  ];

  @override
  void initState() {
    super.initState();
    if (faqsList.isNotEmpty) {
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );
      _offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredFaqsList = faqsList.where((faq) {
      return faq['question']!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          faq['answer']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(3.w, 4.h, 0, 0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 27,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const MenuScreen();
                        },
                        transitionDuration: const Duration(seconds: 1),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(-10.0, 0.0); // slide in from the left
                          const end = Offset.zero;
                          const curve = Curves.easeInOutQuart;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(28.w, 4.h, 0, 0),
                  child: Text(
                    'FAQs',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ))
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search FAQs',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              // autofocus: true,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: SlideTransition(
              position: _offsetAnimation,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: filteredFaqsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var faq = filteredFaqsList[index];
                    bool isExpanded = expandedItems.contains(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              spreadRadius: 0.5,
                              blurRadius: 1,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FAQ question
                            Text(
                              faq['question'] ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),

                            Text(
                              faq['answer'] ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              maxLines: isExpanded ? null : 2,
                              overflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            if (faq['answer']!.length > 110)
                              Center(
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isExpanded) {
                                            expandedItems.remove(index);
                                          } else {
                                            expandedItems.add(index);
                                          }
                                        });
                                      },
                                      child: ColorFiltered(
                                          colorFilter: const ColorFilter.mode(
                                            PRIMARY_COLOR,
                                            BlendMode.srcIn,
                                          ),
                                          child: isExpanded
                                              ? Text(
                                                  'Read less',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Text(
                                                  'Read more',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
