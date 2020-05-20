import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:onde_tem_saude_app/repositories/user_repository.dart';
import 'package:onde_tem_saude_app/validators/validators.dart';
import 'package:rxdart/rxdart.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

void main() {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  when(_auth.onAuthStateChanged).thenAnswer((_) {
    return _user;
  });
  UserRepository _repo = UserRepository.instance(auth: _auth);

  group('LOGIN', () {
    test("Email vazio", () {
      var result = validatorEmail("");
      expect(result, "Informe o e-mail.");
    });

    test("Email inválido", () {
      var result = validatorEmail("teste");
      expect(result, "E-mail inválido!");
    });

    test("Senha vazia", () {
      var result = validatorSenha("");
      expect(result, "Informe a senha.");
    });

    test("Senha inválida", () {
      var result = validatorSenha("12345");
      expect(result, "Senha inválida!");
    });

    test("Recuperar senha", () {
      var result = validatorEmail("teste@teste.com");
      expect(result, null);
    });

    when(_auth.signInWithEmailAndPassword(email: "email", password: "password"))
        .thenAnswer((_) async {
      _user.add(MockFirebaseUser());
      return _user.value;
    });
    when(_auth.signInWithEmailAndPassword(email: "mail", password: "pass"))
        .thenThrow(() {
      return null;
    });
    test("Login com email e senha", () async {
      bool signedIn = await _repo.signIn("email", "password");
      expect(signedIn, true);
      expect(_repo.status, Status.Authenticated);
    });

    test("Login com email e senha incorretos", () async {
      bool signedIn = await _repo.signIn("mail", "pass");
      expect(signedIn, false);
      expect(_repo.status, Status.Unauthenticated);
    });

    test('Logout', () async {
      await _repo.signOut();
      expect(_repo.status, Status.Unauthenticated);
    });
  });

  group('USUARIO', () {
    test("Email vazio", () {
      var result = validatorEmail("");
      expect(result, "Informe o e-mail.");
    });
    test("Email inválido", () {
      var result = validatorEmail("teste");
      expect(result, "E-mail inválido!");
    });

    test("Senha vazia", () {
      var result = validatorSenha("");
      expect(result, "Informe a senha.");
    });

    test("Senha inválida", () {
      var result = validatorSenha("12345");
      expect(result, "Senha inválida!");
    });

    test("Confirmar senha falha", () {
      String senha = "1234567";
      String confSenha = "123456";

      var result = validatorConfirmarSenha(senha, confSenha);
      expect(result, "Confirmação de Senha Diferente da Senha!");
    });

    test("Confirmar senha sucesso", () {
      String senha = "123456";
      String confSenha = "123456";

      var result = validatorConfirmarSenha(senha, confSenha);
      expect(result, null);
    });

    test("Nome vazio", () {
      var result = validatorNome("");
      expect(result, "Nome inválido!");
    });

    test("Endereço vazio", () {
      var result = validatorTelefone("");
      expect(result, "Telefone inválido!");
    });

    test("Telefone vazio", () {
      var result = validatorEndereco("");
      expect(result, "Endereço inválido!");
    });

    test("Cidade não selecionada", () {
      var result = validatorCidade("");
      expect(result, "Selecione a cidade!");
    });

    test("Bairro não selecionado", () {
      var result = validatorBairro("");
      expect(result, "Selecione o bairro!");
    });

  });
}
