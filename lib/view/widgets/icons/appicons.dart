import 'package:flutter/material.dart';

import '../../../view_model/theme/common.dart';

class AppIcons {
  static Icon email = const Icon(Icons.email_outlined);
  static Icon person = const Icon(Icons.person);
  static Icon photoPlaceholder =
      const Icon(Icons.add_photo_alternate_outlined, size: 40);
  static Icon share = const Icon(Icons.share);
  static Icon people = const Icon(Icons.people);
  static Icon fav = Icon(Icons.favorite, color: CommonColors.redC, size: 16);
  static Icon error =
      Icon(Icons.error_outline, color: CommonColors.blueC, size: 12);
  static Icon call = const Icon(Icons.call_outlined);
  static Icon settings = const Icon(Icons.settings);
  static Icon sim = const Icon(Icons.sim_card_outlined);
  static Icon sms = const Icon(Icons.message);
  static Icon vCall = const Icon(Icons.video_call_outlined);
  static Icon highlights = const Icon(Icons.try_sms_star_outlined);
  static Icon organise = const Icon(Icons.bookmark_add);
  static Icon search = const Icon(Icons.search);
  static Icon arrowDown = const Icon(Icons.keyboard_arrow_down_sharp);
  static Icon aToZ = const Icon(Icons.sort_by_alpha_outlined);
  static Icon filter = const Icon(Icons.filter_list);
  static Icon delete = Icon(Icons.delete, color: CommonColors.redC);
  static Icon bin = const Icon(Icons.delete);
  static Icon block = const Icon(Icons.block);
  static Icon redBlock = Icon(
    Icons.block,
    color: CommonColors.redC,
  );
  static Icon edit = const Icon(Icons.edit);

  static Icon camera = const Icon(Icons.camera);
  static Icon gallery = const Icon(Icons.photo_album);
  static Icon close = const Icon(Icons.close);
  static Icon star = Icon(Icons.star, color: CommonColors.favColor);
  static Icon starOutlined = const Icon(Icons.star_outline);

  static IconData received = Icons.call_received;
  static IconData missed = Icons.call_missed;
  static IconData called = Icons.call_made;
}
