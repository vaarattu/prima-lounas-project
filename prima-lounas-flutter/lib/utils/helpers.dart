class Helpers {
  static findById(list, int id) {
    var findById = (obj) => obj.id == id;
    var result = list.where(findById);
    return result.length > 0 ? result.first : null;
  }
}
