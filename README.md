json_web_token
==============

Json Web Token 


Using OAuth 2.0 for Server to Server Applications

https://developers.google.com/accounts/docs/OAuth2ServiceAccount


openssl pkcs12 -in privatekey.p12 -nocerts -passin pass:notasecret -nodes -out rsa_private_key.pem


```
String iss = "[your_id]@developer.gserviceaccount.com";
String scopes = "https://www.googleapis.com/auth/devstorage.read_only";
String rsa_private_key_file = "rsa_private_key.pem";

test('test 1' , (){
      JWT jwt = new JWT(iss, scopes);
      var pemkey = new File(rsa_private_key_file).readAsStringSync();
      rsa_pkcs.RSAPKCSParser parser = new rsa_pkcs.RSAPKCSParser();
      rsa_pkcs.RSAPrivateKey pk = parser.parsePEM(pemkey).private;
      var privk = new RSAPrivateKey(pk.modulus, pk.privateExponent, pk.prime1, pk.prime2);
      
      return jwt.generateAuthUsingKey(privk).then((_){
        print(jwt.auth["access_token"]);
      });
    });
    
    test('test 2' , (){
      JWTStore.getCurrent().registerKey(iss, rsa_private_key_file);
     return  JWTStore.getCurrent().generateJWT(iss, scopes).then((JWT jwt){
        print(jwt.auth);
        print(jwt.isExpired);
      });
    });
```

once a token is generated it can be used with google api ...

```
import "package:google_analytics_v3_api/analytics_v3_api_console.dart";

Analytics analyticsClient = new Analytics(new oauth2.SimpleOAuth2Console(project, "", jwt.accessToken));
analyticsClient.makeAuthRequests = true;
...
...

```