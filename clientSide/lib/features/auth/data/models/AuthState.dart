// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthState {
  String? user;
  String? token;
  bool isLoading;
  bool isSuccess;
  AuthState({
    required this.user,
    required this.token,
    required this.isLoading,
    required this.isSuccess
  });

}
