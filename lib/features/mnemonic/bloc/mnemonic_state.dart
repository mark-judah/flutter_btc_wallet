part of 'mnemonic_bloc.dart';

//include all probable states the ui could be in in this file: loading, loaded, success ,error etc
@immutable
//this state builds the ui
abstract class MnemonicState {}

//this state takes an action
abstract class MnemonicActionState extends MnemonicState{}

class MnemonicInitial extends MnemonicState {}

class MnemonicLoadingState extends MnemonicState{
  //show loading circle
}

class MnemonicLoadedSuccessState extends MnemonicState{
  List mnemonicList;
  MnemonicLoadedSuccessState(List<String> this.mnemonicList);


}

class MnemonicErrorState extends MnemonicState{
  //show error message

}

class NavigateToConfirmSelectedMnemonicPageActionState extends MnemonicActionState{
  List finalMnemonicPhrase;
  NavigateToConfirmSelectedMnemonicPageActionState(this.finalMnemonicPhrase);
  //navigate to confirmed selected mnemonic page

}

class CreateWalletName extends MnemonicState{
  String seed;
  CreateWalletName(this.seed);

}

class NavigateToWalletHomeActionState extends MnemonicActionState {

}