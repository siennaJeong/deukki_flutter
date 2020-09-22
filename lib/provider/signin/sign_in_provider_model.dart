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
}