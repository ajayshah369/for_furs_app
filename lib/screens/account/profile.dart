import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import '../../utilities/dio_instance.dart';

import '../../providers/user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';

  bool loadingChangePassword = false;

  void requestPasswordReset(BuildContext ctx) async {
    setState(() {
      loadingChangePassword = true;
    });

    try {
      await dio.get('/user/requestPasswordReset');
      Navigator.of(ctx).pushNamed('/verifyPasswordResetOtp');
    } on DioError catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content:
              Text(jsonDecode(e.response.toString())['message'] as String)));
    }

    setState(() {
      loadingChangePassword = false;
    });
  }

  void showChangeNameModal(BuildContext ctx, Map<dynamic, dynamic> me) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6), topRight: Radius.circular(6))),
      context: ctx,
      builder: (BuildContext context) {
        return Container(
            height: 180 + MediaQuery.of(context).viewInsets.bottom,
            padding: EdgeInsets.only(
                bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
                top: 16,
                left: 24,
                right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: me.containsKey('name') ? me['name'] : '',
                  onChanged: (v) {
                    setState(() {
                      name = v;
                    });
                  },
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                          bottom: 4, left: 0, right: 0, top: 0),
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.secondary)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.secondary))),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        )),
                    TextButton(
                        onPressed: () {
                          if (name.isEmpty) {
                            Navigator.of(context).pop();
                          } else {
                            Provider.of<User>(context, listen: false)
                                .updateName(ctx, name);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        ))
                  ],
                )
              ],
            ));
      },
    );
  }

  void imagePicker(BuildContext context, {String? source = 'gallery'}) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image;

    if (source == 'gallery') {
      image = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await _picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      Provider.of<User>(context, listen: false)
          .updateImage(context, image.path);
    }
    Navigator.of(context).pop();
  }

  void showChangeImageModal(BuildContext ctx, Map<dynamic, dynamic> me) {
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6))),
        context: ctx,
        builder: (BuildContext context) {
          return Container(
            height: 180,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Photo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (me.containsKey('image'))
                      SizedBox(
                        width: 60,
                        child: InkWell(
                          onTap: () {
                            Provider.of<User>(context, listen: false)
                                .removeImage(ctx);
                            Navigator.of(context).pop();
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.red,
                                child: SvgPicture.asset(
                                  'assets/delete.svg',
                                  color: Colors.white,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Remove photo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (me.containsKey('image')) const SizedBox(width: 24),
                    SizedBox(
                      width: 60,
                      child: InkWell(
                        onTap: () {
                          imagePicker(ctx);
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  Image.asset('assets/gallery.png').image,
                              child: const Icon(
                                FontAwesome5.image,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Gallery',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    SizedBox(
                      width: 60,
                      child: InkWell(
                        onTap: () {
                          imagePicker(ctx, source: 'camera');
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  Image.asset('assets/gallery.png').image,
                              child: const Icon(
                                FontAwesome5.camera,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Camera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final me = Provider.of<User>(context).me;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        titleTextStyle: Theme.of(context).textTheme.headline3,
      ),
      body: Column(children: <Widget>[
        Container(
          height: 200,
          alignment: Alignment.center,
          child: Stack(children: [
            Positioned(
                right: (MediaQuery.of(context).size.width - 150) / 2,
                bottom: (200 - 150) / 2,
                child: CircleAvatar(
                  backgroundImage: me.containsKey('image')
                      ? NetworkImage(me['image'])
                      : Image.asset('assets/user2.png').image,
                  radius: 75,
                  backgroundColor: Colors.white10,
                )),
            if (Provider.of<User>(context).updateImageLoading)
              Positioned(
                  right: (MediaQuery.of(context).size.width - 150) / 2,
                  bottom: (200 - 150) / 2,
                  child: const CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.black54,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )),
            Positioned(
                right: ((MediaQuery.of(context).size.width - 150) / 2),
                bottom: (200 - 150) / 2,
                child: InkWell(
                  onTap: () {
                    showChangeImageModal(context, me);
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    radius: 25,
                    child: const Icon(
                      Icons.camera_alt,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                )),
          ]),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            showChangeNameModal(context, me);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0, color: Colors.grey.shade300)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(
                    children: const [
                      SizedBox(height: 10),
                      Icon(FontAwesome5.user, size: 20, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name', style: TextStyle(color: Colors.grey)),
                      Text(
                        me.containsKey('name') ? me['name'] : '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ]),
                SvgPicture.asset(
                  'assets/edit.svg',
                  color: Theme.of(context).colorScheme.secondary,
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: loadingChangePassword
              ? null
              : () => requestPasswordReset(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0, color: Colors.grey.shade300)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(
                    children: const [
                      SizedBox(height: 10),
                      Icon(Entypo.key, size: 20, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Change password',
                          style: TextStyle(color: Colors.grey)),
                      Text(
                        '***********',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ]),
                loadingChangePassword
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : SvgPicture.asset(
                        'assets/edit.svg',
                        color: Theme.of(context).colorScheme.secondary,
                        height: 20,
                        width: 20,
                      ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            // decoration: BoxDecoration(
            //   border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            // ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(
                    children: const [
                      SizedBox(height: 10),
                      Icon(Icons.call, size: 20, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Phone', style: TextStyle(color: Colors.grey)),
                      Text(
                        me['phone'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
