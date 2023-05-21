

class Paths{

  static const String articlePath = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles.json";

  static const String articleWithId = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles/%ARTICLE_ID%.json";

  static const String articleByCode = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles.json"
      "?orderBy=\"articleCode\"&equalTo=\"%ARTICLE_CODE%\"";

  static String getArticleByCodePath(String code){
    return articleByCode.replaceAll("%ARTICLE_CODE%", code);
  }

  static String getArticlePathWithId(String id){
    return articleWithId.replaceAll("%ARTICLE_ID%", id);
  }

}