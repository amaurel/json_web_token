library json_web_token_test;

import 'dart:io';
import 'package:unittest/unittest.dart';
import 'package:json_web_token/json_web_token.dart';
import 'package:rsa_pkcs/rsa_pkcs.dart' as rsa_pkcs;
import "package:cipher/cipher.dart";

import 'test_settings.dart';
//import 'private_test_settings.dart';
  
void main(){
  
  simpleTest(){
     
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
    
    test('test 3' , (){
      JWT jwt = new JWT(iss, scopes);
          var pemkey = new File(rsa_private_key_file).readAsStringSync();
          rsa_pkcs.RSAPKCSParser parser = new rsa_pkcs.RSAPKCSParser();
          rsa_pkcs.RSAPrivateKey pk = parser.parsePEM(pemkey).private;
          var privk = new RSAPrivateKey(pk.modulus, pk.privateExponent, pk.prime1, pk.prime2);
          var msg = "hello";
          jwt.sign(msg, privk).then((bytes){
            jwt.signOpenSSL(msg, rsa_private_key_file).then((openSSLBytes){
              expect(bytes, equals(openSSLBytes));
            });
          });
      });
  }
   
  simpleTest();
   
}