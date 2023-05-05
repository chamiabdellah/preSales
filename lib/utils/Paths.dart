

class Paths{

  static const String articlePath = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles.json";

  static const String articleByCode = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles.json"
      "?orderBy=\"articleCode\"&equalTo=\"%ARTICLE_CODE%\"";

  static String getArticleByCodePath(String code){
    return articleByCode.replaceAll("%ARTICLE_CODE%", code);
  }

}