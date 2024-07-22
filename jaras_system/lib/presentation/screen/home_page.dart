import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaras_system/presentation/modul/pick_up_request.dart';
import 'package:jaras_system/presentation/modul/receiver.dart';
import 'package:jaras_system/presentation/screen/add_recevier_page.dart';
import 'package:jaras_system/presentation/screen/recevier_page.dart';
import 'package:jaras_system/presentation/screen/supervisor_page.dart';
import 'package:jaras_system/presentation/widget/student_state_toggle.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // State variables
  String currentTime = '';
  String pickUpStatus = 'لم يحن موعد الخروج بعد';
  List<Receiver> receivers = [];
  List<PickUpRequest> completedRequests = [];
  List<PickUpRequest> pendingRequests = [];
  List<PickUpRequest> parentRequests = [];
  final Uuid uuid = const Uuid();
  bool isCooldownActive = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  // Stream controller for pick-up status
  final StreamController<String> _pickUpStatusController =
      StreamController<String>();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initializeRequests();
  }

  @override
  void dispose() {
    _pickUpStatusController.close();
    super.dispose();
  }

  // Start timer to update current time and pick-up status
  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final now = DateTime.now();
      final pickUpTime = DateTime(
          now.year, now.month, now.day); // Example pick-up time at 7:00 AM
      String newPickUpStatus = now.isAfter(pickUpTime)
          ? 'حان موعد الخروج'
          : 'لم يحن موعد الخروج بعد';

      if (newPickUpStatus != pickUpStatus) {
        setState(() {
          pickUpStatus = newPickUpStatus;
        });
        _pickUpStatusController.add(newPickUpStatus); // Notify listeners
      }

      setState(() {
        currentTime = DateFormat('hh:mm a').format(now);
      });
    });
  }

  // Initialize dummy pick-up requests
  void _initializeRequests() {
    completedRequests = [
      PickUpRequest(
        id: uuid.v4(),
        studentName: 'أحمد محمد',
        time: DateTime.now().subtract(const Duration(minutes: 5)).toString(),
        date: '26 مارس 2024',
        status: 'خرج',
      ),
      PickUpRequest(
          id: uuid.v4(),
          studentName: 'سعيد محمد',
          time: DateTime.now().subtract(const Duration(minutes: 6)).toString(),
          date: '26 مارس 2024',
          status: 'خرج'),
      PickUpRequest(
        id: uuid.v4(),
        studentName: 'علي محمد',
        time: DateTime.now().subtract(const Duration(minutes: 5)).toString(),
        date: '26 مارس 2024',
        status: 'خرج',
      ),
    ];

    pendingRequests = [];
    parentRequests = [
      PickUpRequest(
          id: uuid.v4(),
          studentName: 'علي عبدالله',
          time: 'لم يبدأ بعد',
          date: '',
          status: 'حاضر'),
      PickUpRequest(
          id: uuid.v4(),
          studentName: 'إبراهيم جعفر',
          time: 'لم يبدأ بعد',
          date: '',
          status: 'خرج'),
      PickUpRequest(
          id: uuid.v4(),
          studentName: 'ماجد سعيد',
          time: 'لم يبدأ بعد',
          date: '',
          status: 'غائب'),
    ];
    receivers = [
      Receiver(name: 'علي القحطاني', relationship: 'ولي أمر', isActive: true),
      Receiver(name: 'كومار حسن', relationship: 'سائق', isActive: false),
    ];
  }

  // Add a new pick-up request
  void _addPickUpRequest(String studentName) {
    if (isCooldownActive) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Error: You must wait 60 seconds before adding another request.'),
      ));
      return;
    }

    setState(() {
      pendingRequests.add(PickUpRequest(
          id: uuid.v4(),
          studentName: studentName,
          time: 'لم يبدأ بعد',
          date: '',
          status: 'حاضر'));
      isCooldownActive = true;
    });

    Timer(const Duration(seconds: 60), () {
      setState(() {
        isCooldownActive = false;
      });
    });
  }

  // Mark a pick-up request as completed and move it after 30 seconds
  void _markCompleted(PickUpRequest request) {
    // Add a delay of 30 seconds before moving the request

    Future.delayed(const Duration(seconds: 30), () {
      setState(() {
        // Move the request from parentRequests to pendingRequests
        pendingRequests.add(request);
        parentRequests.remove(request);
      });
    });
  }

  String formatTimeDifference(DateTime requestTime) {
    final now = DateTime.now();
    final difference = now.difference(requestTime);

    if (difference.inMinutes < 1) {
      return 'قبل لحظة';
    } else if (difference.inMinutes < 60) {
      return 'قبل ${difference.inMinutes} دقائق';
    } else if (difference.inHours < 24) {
      return 'قبل ${difference.inHours} ساعات';
    } else {
      return 'قبل ${difference.inDays} أيام';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF92D204),
        toolbarHeight: 0,
        elevation: 0,
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return StreamBuilder<String>(
            stream: _pickUpStatusController.stream,
            initialData: pickUpStatus,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              String currentStatus =
                  snapshot.data ?? pickUpStatus; // Ensure not null

              return _buildBody(currentStatus);
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(String currentStatus) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFF92D204),
          height: MediaQuery.of(context).size.height * 0.5,
        ),
        Positioned(
          top: 85,
          right: -80,
          child: Container(
            width: 304,
            height: 304,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/bb.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.black.withOpacity(
                    0.3), // Optional: to add a dark overlay on the image
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildUserCard(
                      userName: 'علي القحطاني',
                      userRole: 'ولي الأمر',
                      leadingIcon: Icons.more_horiz,
                      trailingIcon: Icons.notifications,
                      cardColor: const Color(0xFF093E49),
                      textColor: Colors.white,
                      iconColor: Colors.white,
                    ),
                    const SizedBox(height: 11),
                    _buildStatusCard(currentStatus),
                    if (currentStatus == 'حان موعد الخروج') ...[
                      _buildCurrentTime(),
                      _buildPendingRequests(),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildRequestList(),
                      const SizedBox(height: 20),
                      _buildreceiverlist(receivers)
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard({
    required String userName,
    required String userRole,
    required IconData leadingIcon,
    required IconData trailingIcon,
    required Color cardColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return Card(
      color: cardColor,
      child: ListTile(
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: const Color(0xff006981),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(
            leadingIcon,
            color: iconColor,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
                Text(
                  userRole,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: const Color(0xff006981),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                trailingIcon,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String currentStatus) {
    // Determine the color based on the status
    Color color = currentStatus == 'حان موعد الخروج'
        ? const Color(0xFF92D400)
        : const Color(0xFFA4AFC0);

    // Determine the icon based on the status
    IconData leadingIcon = currentStatus == 'حان موعد الخروج'
        ? Icons.notifications_active
        : Icons.notifications;

    // Determine the image based on the status
    String imagePath = currentStatus == 'حان موعد الخروج'
        ? 'assets/image/Echo.jpg' // Image for "حان موعد الخروج"
        : 'assets/image/bell2.png'; // Image for other statuses

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: const Color(0xFFFFFFFF),
        child: ListTile(
          leading: Icon(
            Icons.play_circle_outline,
            color: color,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'جرس',
                    style: TextStyle(
                      fontSize: 20,
                      color: color,
                    ),
                  ),
                  Text(
                    currentStatus,
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build current time widget
  Widget _buildCurrentTime() {
    return ListTile(
      title: Text(
        currentTime,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
        ),
      ),
    );
  }

  Widget _buildPendingRequests() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: _buildHeader(
                  leftText: 'حالة الطالب',
                  leftIcon: Icons.info,
                  leftIconColor: const Color(0xFFA4AFC0),
                  onLeftIconPressed: () {
                    // Add your onPressed code here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.highlight_off,
                                    color: Color(0xffD0D5DD)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Text('ما هي حالة الطالب؟'),
                              IconButton(
                                iconSize: 20,
                                icon: const Icon(Icons.help),
                                color: const Color(0xFF92D400),
                                onPressed: () {
                                  // onPressed code here
                                },
                              ),
                              const SizedBox(width: 1)
                            ],
                          ),
                          content: StudentStatusList(),
                        );
                      },
                    );
                  },
                  rightText: 'طلب النداء',
                  rightImagePath:
                      'assets/image/greenbell.png', // Path to the right image
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 382, // Fixed width
                height: 390, // Fixed height
                child: SingleChildScrollView(
                  child: Column(
                    children: parentRequests.map((request) {
                      return _buildRequestItem(request);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required String leftText,
    required IconData leftIcon,
    required Color leftIconColor,
    required VoidCallback onLeftIconPressed,
    required String rightText,
    required String rightImagePath, // Path for the right image
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFA4AFC0).withOpacity(0.1), // Border color
            width: 1.0, // Border width
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  iconSize: 24,
                  icon: Icon(leftIcon),
                  color: leftIconColor,
                  onPressed: onLeftIconPressed,
                ),
                Text(
                  leftText,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFFA4AFC0),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  rightText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(rightImagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItem(PickUpRequest request) {
    // Variables to hold the image path, color, and text based on the request status
    String statusImagePath;
    Color statusColor;
    String statusText;
    String listTileText;

    // Determine the values of the variables based on the request status
    switch (request.status) {
      case 'حاضر':
      case 'يذاع الأن':
      case 'طلب النداء':
        statusImagePath = 'assets/image/Checkmark.png';
        statusColor = const Color(0xFF92D400);
        statusText = 'حاضر';
        listTileText = (request.status == 'يذاع الأن')
            ? 'يذاع الآن؛ يرجى الانتظار'
            : 'اسحب لرن الجرس';
        break;
      case 'خرج':
        statusImagePath =
            'assets/image/Outside.png'; // Change this to appropriate image
        statusColor = const Color(0xff00D9F4);
        statusText = 'خرج';
        listTileText = 'غادر الطالب المدرسة';
        break;
      case 'غائب':
        statusImagePath =
            'assets/image/Heartbreak.png'; // Change this to appropriate image
        statusColor = const Color(0xff9DA5B2);
        statusText = 'غائب';
        listTileText = 'الطالب غائب اليوم';
        break;
      case 'متأخر':
        statusImagePath =
            'assets/image/ClockDelay.png'; // Change this to appropriate image
        statusColor = const Color(0xffFFA544);
        statusText = 'متأخر';
        listTileText = 'لم يخرج بعد 5 دقائق من ندائه';
        break;
      default:
        statusImagePath =
            'assets/image/D.png'; // Change this to appropriate image
        statusColor = Colors.grey;
        statusText = 'غير معروف';
        listTileText = 'الحالة غير معروفة';
    }

    // Widget for the trailing part of the ListTile, customized based on status
    Widget trailingWidget;
    if (request.status == 'حاضر') {
      trailingWidget = _buildListTile(
        listTileText,
        const Color(0xFF92D400),
        'assets/image/DD.png',
        request,
      );
    } else if (request.status == 'يذاع الأن') {
      trailingWidget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: _buildListTile(listTileText, const Color(0xff00D9F4),
            'assets/image/off.png', request),
      );
    } else if (request.status == 'خرج') {
      trailingWidget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: _buildListTile(listTileText, const Color(0xff00D9F4),
            'assets/image/lol.png', request),
      );
    } else {
      trailingWidget = Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: _buildListTile(listTileText, const Color(0xFF9DA5B2),
            'assets/image/up.png', request),
      );
    }

    // Return the complete request item widget
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Row(
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 20,
                      height: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(statusImagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    request.studentName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.account_circle,
                    color: statusColor,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          trailingWidget,
        ],
      ),
    );
  }

  Widget _buildListTile(String listTileText, Color color, String imagePath,
      PickUpRequest request) {
    return SizedBox(
      width: 382,
      child: ListTile(
        title: Card(
          color: Colors.white,
          child: ListTile(
            title: const SizedBox(), // Empty widget as title
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      listTileText,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(width: 8), // Space between text and image
                    // Conditionally add Dismissible based on request status
                    if (request.status == 'حاضر')
                      Dismissible(
                        key: Key(request.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            request.status = 'يذاع الأن';
                          });
                          _addPickUpRequest(request.studentName);
                        },
                        background: Container(
                          margin: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: const Color(0xFF92D400),
                              border:
                                  Border.all(color: const Color(0xFFEBEBEB)),
                              borderRadius: BorderRadius.circular(14)),
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: color,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: color,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            leading: (listTileText == 'اسحب لرن الجرس')
                ? Icon(
                    Icons.notifications,
                    color: color,
                  )
                : Icon(
                    Icons.lock,
                    color: color,
                    size: 20,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList() {
    List<PickUpRequest> allRequests = [
      ...pendingRequests.take(1),
      ...completedRequests.take(3)
    ];

    // Sort the list, handling 'لم يبدأ بعد' appropriately
    allRequests.sort((a, b) {
      if (a.time == 'لم يبدأ بعد' && b.time == 'لم يبدأ بعد') {
        return 0; // If both are 'لم يبدأ بعد', leave them in the current order
      } else if (a.time == 'لم يبدأ بعد') {
        return -1; // Put 'لم يبدأ بعد' before any other time
      } else if (b.time == 'لم يبدأ بعد') {
        return 1; // Put 'لم يبدأ بعد' after any other time
      } else {
        // Normal comparison for valid dates
        return DateTime.parse(b.time).compareTo(DateTime.parse(a.time));
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              shape: BoxShape.rectangle,
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: 382,
                height: 320,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildHeader1(),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildRequestItems(allRequests),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader1() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFA4AFC0).withOpacity(0.2), // Border color
            width: 1.0, // Border width
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // onPressed code here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SupervisorPage()),
                    );
                  },
                  child: Container(
                    width: 24,
                    height: 20,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/image/Help.png'), // Replace with your image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Space between image and text
                const Text(
                  'هل تواجه مشكلة',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA4AFC0),
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  'أحدث طلبات النداء',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.circle_notifications,
                  color: Color(0xFF92D400),
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItems(List<PickUpRequest> allRequests) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: allRequests.length,
      itemBuilder: (context, index) {
        final request = allRequests[index];
        _markCompleted(request);

        // Display the formatted time or 'لم يبدأ بعد' if time is not set
        String displayTime = request.time != 'لم يبدأ بعد'
            ? formatTimeDifference(DateTime.parse(request.time))
            : 'التالي          ';

        return Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 0),
          child: ListTile(
            leading: Text(
              displayTime,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                request.studentName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    request.time == 'لم يبدأ بعد'
                        ? 'assets/image/Echo.png' // Replace with your active image path
                        : 'assets/image/off.png', // Replace with your inactive image path
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildreceiverlist(List<Receiver> receivers) {
    // Accepts list of receivers as parameter
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _buildHeader(
                  leftText: 'إضافة مفوض جديد',
                  leftIcon: Icons.add_circle,
                  leftIconColor: const Color(0xFF92D400),
                  onLeftIconPressed: () {
                    // Navigate to AddReceiverForm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddReceiverForm()),
                    );
                  },
                  rightText: 'المفوّض بالاستلام',
                  rightImagePath:
                      'assets/image/Parent Student.png', // Path to the right image
                ),
              ),
              // Pass the receivers list to ReceiverListWidget
              ReceiverListWidget(
                receivers: receivers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
