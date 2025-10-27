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

  ChannelDTO(
      {this.id,
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
      this.podcasts});

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
        socialMedia!.add(new SocialMedia.fromJson(v));
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
        programs!.add(new Program.fromJson(v));
      });
    }
    if (json['podcasts'] != null) {
      podcasts = <Podcasts>[];
      json['podcasts'].forEach((v) {
        podcasts!.add(new Podcasts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['web_logo'] = this.webLogo;
    data['maximizedLogo'] = this.maximizedLogo;
    data['minimizedLogo'] = this.minimizedLogo;
    data['circledLogo'] = this.circledLogo;
    data['stream_url'] = this.streamUrl;
    data['mobile_number'] = this.mobileNumber;
    data['mobile_number_ksa'] = this.mobileNumberKsa;
    data['mobile_number_uae'] = this.mobileNumberUae;
    if (this.socialMedia != null) {
      data['social_media'] = this.socialMedia!.map((v) => v.toJson()).toList();
    }
    data['email'] = this.email;
    data['type'] = this.type;
    data['favorite'] = this.favorite;
    data['meta_data'] = this.metaData;
    data['has_voice_note'] = this.hasVoiceNote;
    data['has_messaging'] = this.hasMessaging;
    data['has_hosts'] = this.hasHosts;
    data['has_schedule'] = this.hasSchedule;
    data['has_call'] = this.hasCall;
    data['has_news'] = this.hasNews;
    data['default_channel'] = this.defaultChannel;
    data['landing_page'] = this.landingPage;
    data['placeholder'] = this.placeholder;
    data['channel_banners'] = this.channelBanners;
    data['channelOrder'] = this.channelOrder;
    if (this.programs != null) {
      data['programs'] = this.programs!.map((v) => v.toJson()).toList();
    }
    if (this.podcasts != null) {
      data['podcasts'] = this.podcasts!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['type'] = this.type;
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

  Program(
      {this.id,
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
      this.socialMedia});

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
        socialMedia!.add(new SocialMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['channel_id'] = this.channelId;
    data['name'] = this.name;
    data['text'] = this.text;
    data['image'] = this.image;
    data['thumbnail'] = this.thumbnail;
    data['category'] = this.category;
    data['censorship'] = this.censorship;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['date'] = this.date;
    if (this.socialMedia != null) {
      data['social_media'] = this.socialMedia!.map((v) => v.toJson()).toList();
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

  Podcasts(
      {this.id,
      this.channelId,
      this.thumbnail,
      this.image,
      this.hashtag,
      this.title,
      this.name,
      this.description,
      this.episodes});

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
        episodes!.add(new Episodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['channel_id'] = this.channelId;
    data['thumbnail'] = this.thumbnail;
    data['image'] = this.image;
    data['hashtag'] = this.hashtag;
    data['title'] = this.title;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.episodes != null) {
      data['episodes'] = this.episodes!.map((v) => v.toJson()).toList();
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

  Episodes(
      {this.id,
      this.title,
      this.description,
      this.date,
      this.episode,
      this.link,
      this.externalLink,
      this.isVideo,
      this.podcastId});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['date'] = this.date;
    data['episode'] = this.episode;
    data['link'] = this.link;
    data['external_link'] = this.externalLink;
    data['is_video'] = this.isVideo;
    data['podcast_id'] = this.podcastId;
    return data;
  }
}
