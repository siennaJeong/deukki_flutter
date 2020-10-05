import 'package:deukki/data/model/user_vo.dart';
import 'package:deukki/data/repository/user/user_repository.dart';
import 'package:deukki/data/repository/user/user_rest_repository.dart';
import 'package:deukki/provider/provider_model.dart';
import 'package:deukki/provider/signin/sign_in_provider_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInProviderModel extends ProviderModel<SignInProviderState> {
  SignInProviderModel({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(SignInProviderState());

  factory SignInProviderModel.build() => SignInProviderModel(userRepository: UserRestRepository());
  final UserRepository _userRepository;

  Future<void> checkSignUp(String authType, String authId) async {
    final checkSignUp = _userRepository.checkUserSignUp(authType, authId);
    await value.checkSignUp.set(checkSignUp, notifyListeners);
  }

  Future<void> signUp(UserVO userVO, String authType, String authId, bool agreeMarketing, String marketingMethod) async {
    final signUp = _userRepository.signUp(userVO, authType, authId, agreeMarketing, marketingMethod);
    await value.signUp.set(signUp, notifyListeners);
  }

  Future<void> signOut(String authJWT) async {
    final signOut = _userRepository.signOut(authJWT);
    await value.signOut.set(signOut, notifyListeners);
  }

  Future<void> login(String authType, String authId) async {
    final login = _userRepository.login(authType, authId);
    await value.login.set(login, notifyListeners);
  }

  Future<void> logout(String authJWT) async {
    final logout = _userRepository.logout(authJWT);
    await value.logout.set(logout, notifyListeners);
  }
}