class CollectionsUtil {
  static int indexOf<T>(List<T> list, bool predication(T item)) {
    if (list == null) return -1;
    for (int i = 0; i < list.length; i++) {
      if (predication(list[i])) {
        return i;
      }
    }
    return -1;
  }

  static T find<T>(List<T> list,bool predication(T item)){
    if (list == null) return null;
    for (int i = 0; i < list.length; i++) {
      if (predication(list[i])) {
        return list[i];
      }
    }
    return null;
  }
}
