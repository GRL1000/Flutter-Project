class ModelLogin{
  final String acceso;
  final String error;
  ModelLogin(this.acceso, this.error);

  ModelLogin.fromJson(Map<String, dynamic>json)
      : acceso = json['acceso'],
        error = json['error'];

  Map<String, dynamic>toJson() => {
    'acceso': acceso,
    'error' : error,
  };
}