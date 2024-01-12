class User {
  String id;
  String email;
  String name;
  String token;
  String url;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.token,
      required this.url});

  // User 클래스의 싱글턴 인스턴스
  static User? _instance;

  // 싱글턴 패턴을 위한 팩토리 생성자
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['jwt'] as String,
      url: "",
    );
  }

  // 현재 인스턴스에 접근하기 위한 getter
  static User get current {
    assert(_instance != null, 'User has not been initialized yet.');
    return _instance!;
  }

  // 인스턴스 초기화
  static void initialize(String id, String email, String name, String token) {
    _instance = User(id: id, email: email, name: name, token: token, url: "");
  }

  // 인스턴스 정보 업데이트
  static void update(String id, String email, String name, String token) {
    if (_instance != null) {
      _instance!.id = id ?? _instance!.id;
      _instance!.email = email ?? _instance!.email;
      _instance!.name = name ?? _instance!.name;
      _instance!.token = token ?? _instance!.token;
    }
  }

  // 로그아웃 시 인스턴스 제거
  static void logout() {
    _instance = null;
  }

  static void setUrl(String url) {
    _instance!.url = url;
  }
}
