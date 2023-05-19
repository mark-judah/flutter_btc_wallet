part of 'mnemonic_bloc.dart';

@immutable
abstract class MnemonicEvent {}

class FetchMnemonicsEvent extends MnemonicEvent{
  //populate mnemonic list with selected phrases

}

class NavigateToConfirmSelectedMnemonicPageEvent extends MnemonicEvent{
  List finalMnemonicPhrase=[];
  NavigateToConfirmSelectedMnemonicPageEvent(this.finalMnemonicPhrase);

}

class CreateWalletSeedEvent extends MnemonicEvent{
  List finalMnemonicPhrase=[];
  CreateWalletSeedEvent(this.finalMnemonicPhrase);

}

class CreateWalletEvent extends MnemonicEvent{
  String walletName,walletPassword,seedHex;
  CreateWalletEvent(this.walletName,this.walletPassword,this.seedHex);
}

class SetWalletSeedEvent extends MnemonicEvent{
  String walletName;
  String seedHex;
  SetWalletSeedEvent(this.walletName,this.seedHex);

}