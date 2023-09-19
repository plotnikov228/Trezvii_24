abstract class SecurityStorageRepository {

  void initializeSecurityStorage ();

  Future<String> getSecretKey ();

}