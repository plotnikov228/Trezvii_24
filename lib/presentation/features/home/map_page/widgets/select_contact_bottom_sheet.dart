import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';

class SelectContactBottomSheet extends StatelessWidget {
  final List<Contact> contacts;
  final Function(Contact) onSelect;

  const SelectContactBottomSheet(
      {super.key, required this.contacts, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height / 3 * 2,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: size.height / 3 * 2,
            child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final photo = contacts[index].photo;
                  final name = contacts[index].displayName;
                  late final String number;
                  try {
                    number = contacts[index].phones.first.normalizedNumber;
                  } catch (_) {
                    number = '';
                  }
                  return InkWell(
                    onTap: () {
                      onSelect(contacts[index]);
                      context.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: SizedBox(
                          height: 40,
                          width: size.width - 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey, shape: BoxShape.circle),
                                  child: photo != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CircleAvatar(
                                              backgroundImage:MemoryImage(photo)))
                                      : const Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.black45,
                                        )),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppStyle.black12,
                                  ),
                                  Text(
                                    number,
                                    style: AppStyle.black10
                                        .copyWith(fontWeight: FontWeight.w300),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            height: 50,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.white12],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
          )
        ],
      ),
    );
  }
}
