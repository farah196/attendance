import 'error_model.dart';


class LoginResult {
  String? jsonrpc;

  Result? result;
  Error? error;
  LoginResult({this.jsonrpc,this.error,  this.result});

  LoginResult.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];

    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['jsonrpc'] = jsonrpc;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class Result {
  int? uid;
  // bool? isSystem;
  // bool? isAdmin;
  // UserContext? userContext;
  String? db;
  // String? serverVersion;
  // List<int>? serverVersionInfo;
  // String? supportUrl;
  String? name;
  String? username;
  String? partnerDisplayName;
  // int? companyId;
  // int? partnerId;
  // String? webBaseUrl;
  // int? activeIdsLimit;
  // Null? profileSession;
  // Null? profileCollectors;
  // Null? profileParams;
  // int? maxFileUploadSize;
  // bool? homeActionId;
  // CacheHashes? cacheHashes;
  //
  // BundleParams? bundleParams;

  // bool? showEffect;
  // bool? displaySwitchCompanyMenu;
  List<int>? userId;

  Result({this.uid, this.db, this.name, this.username, this.partnerDisplayName, this.userId});

  Result.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    // isSystem = json['is_system'];
    // isAdmin = json['is_admin'];
    // userContext = json['user_context'] != null ? new UserContext.fromJson(json['user_context']) : null;
    db = json['db'];
    // serverVersion = json['server_version'];
    // serverVersionInfo = json['server_version_info'].cast<int>();
    // supportUrl = json['support_url'];
    name = json['name'];
    username = json['username'];
    partnerDisplayName = json['partner_display_name'];
    // companyId = json['company_id'];
    // partnerId = json['partner_id'];
    // webBaseUrl = json['web.base.url'];
    // activeIdsLimit = json['active_ids_limit'];
    // profileSession = json['profile_session'];
    // profileCollectors = json['profile_collectors'];
    // profileParams = json['profile_params'];
    // maxFileUploadSize = json['max_file_upload_size'];
    // homeActionId = json['home_action_id'];
    // cacheHashes = json['cache_hashes'] != null ? new CacheHashes.fromJson(json['cache_hashes']) : null;
    //
    // bundleParams = json['bundle_params'] != null ? new BundleParams.fromJson(json['bundle_params']) : null;
    //
    // showEffect = json['show_effect'];
    // displaySwitchCompanyMenu = json['display_switch_company_menu'];
    userId = json['user_id'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['uid'] = uid;
    // data['is_system'] = this.isSystem;
    // data['is_admin'] = this.isAdmin;
    // if (this.userContext != null) {
    //   data['user_context'] = this.userContext!.toJson();
    // }
    data['db'] = db;
    // data['server_version'] = this.serverVersion;
    // data['server_version_info'] = this.serverVersionInfo;
    // data['support_url'] = this.supportUrl;
    data['name'] = name;
    data['username'] = username;
    data['partner_display_name'] = partnerDisplayName;
    // data['company_id'] = this.companyId;
    // data['partner_id'] = this.partnerId;
    // data['web.base.url'] = this.webBaseUrl;
    // data['active_ids_limit'] = this.activeIdsLimit;
    // data['profile_session'] = this.profileSession;
    // data['profile_collectors'] = this.profileCollectors;
    // data['profile_params'] = this.profileParams;
    // data['max_file_upload_size'] = this.maxFileUploadSize;
    // data['home_action_id'] = this.homeActionId;
    // if (this.cacheHashes != null) {
    //   data['cache_hashes'] = this.cacheHashes!.toJson();
    // }

    // if (this.bundleParams != null) {
    //   data['bundle_params'] = this.bundleParams!.toJson();
    // }
    //
    // data['show_effect'] = this.showEffect;
    // data['display_switch_company_menu'] = this.displaySwitchCompanyMenu;
    data['user_id'] = userId;
    return data;
  }
}

class UserContext {
  String? lang;
  String? tz;
  int? uid;

  UserContext({this.lang, this.tz, this.uid});

  UserContext.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    tz = json['tz'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['lang'] = lang;
    data['tz'] = tz;
    data['uid'] = uid;
    return data;
  }
}

class CacheHashes {
  String? translations;
  String? loadMenus;

  CacheHashes({this.translations, this.loadMenus});

  CacheHashes.fromJson(Map<String, dynamic> json) {
    translations = json['translations'];
    loadMenus = json['load_menus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['translations'] = translations;
    data['load_menus'] = loadMenus;
    return data;
  }
}



class BundleParams {
  String? lang;

  BundleParams({this.lang});

  BundleParams.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['lang'] = lang;
    return data;
  }
}






