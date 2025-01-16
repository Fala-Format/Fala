import 'package:fala/mode/store.dart';
import 'package:fala/mode/subscription_entity.dart';
import 'package:fala/mode/subscriptions_link_entity.dart';
import 'package:flutter/foundation.dart';

class SubscriptionProvider with ChangeNotifier {
  List<SubscriptionsLinkEntity> links = [];

  SubscriptionProvider() {
    init();
  }

  void init() async {
    links = await Store.getSubscriptionLinks();
    notifyListeners();
  }

  void addLink(SubscriptionsLinkEntity link) {
    int currentIndex = subscriptions.length;
    for(SubscriptionEntity item in link.subscriptions ?? []) {
      item.index = currentIndex;
      currentIndex++;
    }
    links.add(link);
    Store.setSubscriptionLinks(links);
    notifyListeners();
  }

  void removeLink(SubscriptionsLinkEntity link) {
    links.remove(link);
    reSortIndex();
    Store.setSubscriptionLinks(links);
    notifyListeners();
  }

  void reSortIndex() {
    var list = subscriptions;
    var index = 0;
    for(var item in list) {
      item.index = index;
      index++;
    }
  }

  void updateLink(SubscriptionsLinkEntity link) {
    SubscriptionsLinkEntity oldLink = links.firstWhere((item) => item.url == link.url);
    oldLink.loading = false;
    List<SubscriptionEntity> subscriptions = oldLink.subscriptions!;
    int currentIndex = subscriptions.length;
    for(int index = 0; index < link.subscriptions!.length; index++) {
      if(subscriptions.length > index) {
        subscriptions[index].title = link.subscriptions![index].title;
        subscriptions[index].sources = link.subscriptions![index].sources;
      } else {
        link.subscriptions![index].index = currentIndex;
        currentIndex++;
        subscriptions.add(link.subscriptions![index]);
      }
    }
    if(subscriptions.length > link.subscriptions!.length) {
      subscriptions.removeRange(link.subscriptions!.length, subscriptions.length);
      reSortIndex();
    }
    Store.setSubscriptionLinks(links);
    notifyListeners();
  }

  bool existLink(SubscriptionsLinkEntity link) {
    return links.any((item) => item.url == link.url);
  }

  void editLink(SubscriptionsLinkEntity link, SubscriptionsLinkEntity newLink) {
    links = links.map((item) => item == link ? newLink : item).toList();
    Store.setSubscriptionLinks(links);
    notifyListeners();
  }

  void editSubscription(SubscriptionEntity sub, SubscriptionEntity value) {
    if(!value.visible) {
      value.index = -1;
    }
    for(var item in links) {
      if(item.subscriptions?.isNotEmpty == true) {
        item.subscriptions = item.subscriptions!.map((item){
          return item == sub ? value : item;
        }).toList();
      }
    }
    Store.setSubscriptionLinks(links);
    notifyListeners();
  }

  void updateIndex(int oldIndex, int newIndex){
    if(oldIndex < newIndex) {
      newIndex -= 1;
    }
    var list = subscriptions;
    list[oldIndex].index = newIndex;
    list[newIndex].index = oldIndex;
    Store.setSubscriptionLinks(links);
    notifyListeners();
  }

  List<SubscriptionEntity> get subscriptions {
    List<SubscriptionEntity> subscriptions = [];
    for(var item in links) {
      subscriptions.addAll(item.subscriptions?.where((sub) => sub.visible).toList() ?? []);
    }
    subscriptions.sort((a,b) => a.index - b.index);
    int index = 0;
    for(var sub in subscriptions) {
      if(sub.index > 0 && sub.index >= index) {
        index = sub.index+1;
      }
      if(sub.index < 0) {
        sub.index = index;
        index += 1;
      }
    }
    return subscriptions;
  }
}