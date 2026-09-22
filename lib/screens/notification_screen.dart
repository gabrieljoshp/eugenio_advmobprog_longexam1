import '../widgets/custom_info.dart' as notif;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: ScreenUtil().screenWidth,
      child: SingleChildScrollView(
        child: Column(
          children: const [
            notif.CustomInformation(
              avatarImage: 'assets/icons/icon_2.jpg',
              name: 'Gabriel Josh Eugenio',
              post: 'Kamusta',
              description: 'Liked your post',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/icon_2.jpg',
              name: 'Gabriel Josh Eugenio',
              post: "Kicking off the holiday season",
              description: '',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/Ganyu_Icon.jpg',
              name: 'Ganyu',
              post: "Time to begin work?",
              description: '',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/Flins_Icon.jpg',
              name: 'Flins',
              post: "Allow me to guide the way.",
              description: '',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/Citlali_Icon.jpg',
              name: 'Citlali',
              post: "I'm never late...",
              description: '',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/Kazuha_Icon.jpg',
              name: 'Kazuha',
              post: "Quote",
              description: 'Commented on your post',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/Raiden_Icon.jpg',
              name: 'Raiden',
              post: "",
              description: 'Reacted to your post',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/Tighnari_Icon.jpg',
              name: 'Tighnari',
              post: "An Image",
              description: 'Commented on your post',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/HuTao_Icon.jpg',
              name: 'Hu Tao',
              post: "An Guide",
              description: 'Reacted to your post',
            ),
            Divider(),
            notif.CustomInformation(
              avatarImage: 'assets/icons/Jean_Icon.jpg',
              name: 'Jean',
              post: "An Image",
              description: 'Liked your post',
            ),
          ],
        ),
      ),
    );
  }
}
