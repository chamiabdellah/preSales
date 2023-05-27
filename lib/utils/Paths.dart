

class Paths{

  /*
  Articles
   */
  static const String articlePath = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles.json";

  // used to check the existence of an article with the same code
  static const String articleByCode = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles.json"
      "?orderBy=\"articleCode\"&equalTo=\"%ARTICLE_CODE%\"";

  // used to get the article from the database for modification => more accurate reading.
  static const String articleWithId = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Articles/%ARTICLE_ID%.json";

  static String getArticleByCodePath(String code){
    return articleByCode.replaceAll("%ARTICLE_CODE%", code);
  }

  static String getArticlePathWithId(String id){
    return articleWithId.replaceAll("%ARTICLE_ID%", id);
  }

  /*
  Customers
   */
  static const String customerPath = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Customers.json";

  static const String customerWithId = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Customers/%CUSTOMER_ID%.json";

  static const String customerByCode = "https://amlogpresales-default-rtdb.europe-west1.firebasedatabase.app/Customers.json"
      "?orderBy=\"customerCode\"&equalTo=\"%CUSTOMER_CODE%\"";

  static String getCustomerByCodePath(String code){
    return customerByCode.replaceAll("%CUSTOMER_CODE%", code);
  }

  static String getCustomerPathWithId(String id){
    return customerWithId.replaceAll("%CUSTOMER_ID%", id);
  }
}