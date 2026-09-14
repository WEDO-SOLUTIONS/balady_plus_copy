class ChannelDTO {
  int? id;
  String? name;
  String? logo;
  String? webLogo;
  String? maximizedLogo;
  String? minimizedLogo;
  String? circledLogo;
  String? streamUrl;
  String? mobileNumber;
  String? mobileNumberKsa;
  String? mobileNumberUae;
  List<SocialMedia>? socialMedia;
  String? email;
  String? type;
  String? favorite;
  String? metaData;
  bool? hasVoiceNote;
  bool? hasMessaging;
  bool? hasHosts;
  bool? hasSchedule;
  bool? hasCall;
  bool? hasNews;
  bool? defaultChannel;
  String? landingPage;
  String? placeholder;
  List<String>? channelBanners;
  int? channelOrder;
  List<Program>? programs;
  List<Podcasts>? podcasts;

  ChannelDTO({
    this.id,
    this.name,
    this.logo,
    this.webLogo,
    this.maximizedLogo,
    this.minimizedLogo,
    this.circledLogo,
    this.streamUrl,
    this.mobileNumber,
    this.mobileNumberKsa,
    this.mobileNumberUae,
    this.socialMedia,
    this.email,
    this.type,
    this.favorite,
    this.metaData,
    this.hasVoiceNote,
    this.hasMessaging,
    this.hasHosts,
    this.hasSchedule,
    this.hasCall,
    this.hasNews,
    this.defaultChannel,
    this.landingPage,
    this.placeholder,
    this.channelBanners,
    this.channelOrder,
    this.programs,
    this.podcasts,
  });

  ChannelDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    webLogo = json['web_logo'];
    maximizedLogo = json['maximizedLogo'];
    minimizedLogo = json['minimizedLogo'];
    circledLogo = json['circledLogo'];
    streamUrl = json['stream_url'];
    mobileNumber = json['mobile_number'];
    mobileNumberKsa = json['mobile_number_ksa'];
    mobileNumberUae = json['mobile_number_uae'];
    if (json['social_media'] != null) {
      socialMedia = <SocialMedia>[];
      json['social_media'].forEach((v) {
        socialMedia!.add(SocialMedia.fromJson(v));
      });
    }
    email = json['email'];
    type = json['type'];
    favorite = json['favorite'];
    metaData = json['meta_data'];
    hasVoiceNote = json['has_voice_note'];
    hasMessaging = json['has_messaging'];
    hasHosts = json['has_hosts'];
    hasSchedule = json['has_schedule'];
    hasCall = json['has_call'];
    hasNews = json['has_news'];
    defaultChannel = json['default_channel'];
    landingPage = json['landing_page'];
    placeholder = json['placeholder'];
    channelBanners = json['channel_banners'].cast<String>();
    channelOrder = json['channelOrder'];
    if (json['programs'] != null) {
      programs = <Program>[];
      json['programs'].forEach((v) {
        programs!.add(Program.fromJson(v));
      });
    }
    if (json['podcasts'] != null) {
      podcasts = <Podcasts>[];
      json['podcasts'].forEach((v) {
        podcasts!.add(Podcasts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['web_logo'] = webLogo;
    data['maximizedLogo'] = maximizedLogo;
    data['minimizedLogo'] = minimizedLogo;
    data['circledLogo'] = circledLogo;
    data['stream_url'] = streamUrl;
    data['mobile_number'] = mobileNumber;
    data['mobile_number_ksa'] = mobileNumberKsa;
    data['mobile_number_uae'] = mobileNumberUae;
    if (socialMedia != null) {
      data['social_media'] = socialMedia!.map((v) => v.toJson()).toList();
    }
    data['email'] = email;
    data['type'] = type;
    data['favorite'] = favorite;
    data['meta_data'] = metaData;
    data['has_voice_note'] = hasVoiceNote;
    data['has_messaging'] = hasMessaging;
    data['has_hosts'] = hasHosts;
    data['has_schedule'] = hasSchedule;
    data['has_call'] = hasCall;
    data['has_news'] = hasNews;
    data['default_channel'] = defaultChannel;
    data['landing_page'] = landingPage;
    data['placeholder'] = placeholder;
    data['channel_banners'] = channelBanners;
    data['channelOrder'] = channelOrder;
    if (programs != null) {
      data['programs'] = programs!.map((v) => v.toJson()).toList();
    }
    if (podcasts != null) {
      data['podcasts'] = podcasts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SocialMedia {
  String? url;
  String? type;

  SocialMedia({this.url, this.type});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['type'] = type;
    return data;
  }
}

class Program {
  int? id;
  int? channelId;
  String? name;
  String? text;
  String? image;
  String? thumbnail;
  String? category;
  String? censorship;
  String? date;
  String? startTime;
  String? endTime;
  List<SocialMedia>? socialMedia;

  Program({
    this.id,
    this.channelId,
    this.name,
    this.text,
    this.image,
    this.thumbnail,
    this.category,
    this.censorship,
    this.date,
    this.startTime,
    this.endTime,
    this.socialMedia,
  });

  Program.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelId = json['channel_id'];
    name = json['name'];
    text = json['text'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    category = json['category'];
    censorship = json['censorship'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    date = json['date'];
    if (json['social_media'] != null) {
      socialMedia = <SocialMedia>[];
      json['social_media'].forEach((v) {
        socialMedia!.add(SocialMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel_id'] = channelId;
    data['name'] = name;
    data['text'] = text;
    data['image'] = image;
    data['thumbnail'] = thumbnail;
    data['category'] = category;
    data['censorship'] = censorship;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['date'] = date;
    if (socialMedia != null) {
      data['social_media'] = socialMedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Podcasts {
  int? id;
  int? channelId;
  String? thumbnail;
  String? image;
  String? hashtag;
  String? title;
  String? name;
  String? description;
  List<Episodes>? episodes;

  Podcasts({
    this.id,
    this.channelId,
    this.thumbnail,
    this.image,
    this.hashtag,
    this.title,
    this.name,
    this.description,
    this.episodes,
  });

  Podcasts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelId = json['channel_id'];
    thumbnail = json['thumbnail'];
    image = json['image'];
    hashtag = json['hashtag'];
    title = json['title'];
    name = json['name'];
    description = json['description'];
    if (json['episodes'] != null) {
      episodes = <Episodes>[];
      json['episodes'].forEach((v) {
        episodes!.add(Episodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['channel_id'] = channelId;
    data['thumbnail'] = thumbnail;
    data['image'] = image;
    data['hashtag'] = hashtag;
    data['title'] = title;
    data['name'] = name;
    data['description'] = description;
    if (episodes != null) {
      data['episodes'] = episodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Episodes {
  int? id;
  String? title;
  String? description;
  String? date;
  int? episode;
  String? link;
  String? externalLink;
  int? isVideo;
  int? podcastId;

  Episodes({
    this.id,
    this.title,
    this.description,
    this.date,
    this.episode,
    this.link,
    this.externalLink,
    this.isVideo,
    this.podcastId,
  });

  Episodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    episode = json['episode'];
    link = json['link'];
    externalLink = json['external_link'];
    isVideo = json['is_video'];
    podcastId = json['podcast_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['episode'] = episode;
    data['link'] = link;
    data['external_link'] = externalLink;
    data['is_video'] = isVideo;
    data['podcast_id'] = podcastId;
    return data;
  }
}
