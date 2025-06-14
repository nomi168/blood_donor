import 'package:blood_donor/constants.dart';
import 'package:blood_donor/core/utils/api_response.dart';
import 'package:blood_donor/features/dashboard/menus/data/models/faqs_model.dart';
import 'package:blood_donor/features/dashboard/menus/domain/term_condition_repository.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'menu_setting_screen.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  Set<int> expandedItems = Set();
  final TermConditionRepository _repository = TermConditionRepository();
  List<FaqModel> faqsList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFaqsList();

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

  Future<void> getFaqsList() async {
    faqsList.clear();
    isLoading = true;
    faqsList = await getFaqsData();
    isLoading = false;
    setState(() {});
  }

  Future<List<FaqModel>> getFaqsData() async {
    try {
      return await _repository.getUserData();
    } catch (e) {
      Helper.handleError(e, 'Error while getting faqs data!');
      return [];
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<FaqModel> filteredFaqsList = faqsList.where((faq) {
      return faq.question.toLowerCase().contains(searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
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
                          return const MenuSettingScreen();
                        },
                        transitionDuration: const Duration(microseconds: 100),
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
                          color:
                              Colors.blueGrey.shade100.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
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
                              faq.question,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),

                            Text(
                              faq.answer,
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
                            if (faq.answer.length > 110)
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
