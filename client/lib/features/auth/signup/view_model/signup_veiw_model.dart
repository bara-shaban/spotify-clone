import 'package:client/features/auth/domain/usecases/signup_usecase.dart';
import 'package:client/features/auth/signup/view_model/signup_state.dart';
import 'package:state_notifier/state_notifier.dart';

class SignupViewModel extends StateNotifier<SignUpState> {
  SignupViewModel(this._signUp) : super(SignUpState.initial());

  final SignupUsecase _signUp;
}
