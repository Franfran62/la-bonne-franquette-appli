//TODO: Créer les queryBuilder nécessaires, ajouter les 4 entêtes (auth/login/ws/api)
/**
 * Collection des requêtes API
 */
class UtilsApi {

static const String baseUrl = "http://10.0.2.2:8080"; //loopback = 10.0.2.2

//Websocket
static const String wsQueryString = "$baseUrl/ws";

//api
static const String apiQueryString = "$baseUrl/api/v1/";

//auth
static const String authQueryString = apiQueryString + "auth/";

//login
static const String createUserQuery = apiQueryString + "user/create";

}