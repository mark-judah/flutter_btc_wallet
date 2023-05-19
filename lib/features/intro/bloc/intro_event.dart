part of 'intro_bloc.dart';

@immutable
abstract class IntroEvent {}

class CheckSecureStorageEvent extends IntroEvent{

}

class AlreadyHaveWalletButtonNavigateEvent extends IntroEvent{

}

