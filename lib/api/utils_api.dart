//TODO: Créer les queryBuilder nécessaires, ajouter les 4 entêtes (auth/login/ws/api)
/**
 * Collection des requêtes API
 */
final String baseUrl = "http://localhost:8080";

//Websocket
final String wsQueryString = baseUrl + "";

//api
final String apiQueryString = baseUrl + "/api/v1/";

/**
 * Requête pour récupérer les catégories, si id est nul, alors retourne toutes els catégories
 * @param id : id de la catégorie
 * @return String
 */
String getCategorie(int id)  {
  if(id == null) {
    return baseUrl + "categorie";
  }
  return baseUrl + "categorie/$id";
}

//auth
final String authQueryString = apiQueryString + "auth/";

//login
final String createUserQuery = apiQueryString + "user/create";
