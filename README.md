<!DOCTYPE html>
<html>

<body>

<h1>Flutter Bitcoin Wallet Client</h1>

<p>The Flutter Bitcoin Wallet Client enables users to manage their Bitcoin wallets, perform transactions, and explore past transaction details via a third-party block explorer.The wallets are HD wallets which facilitate the generation of new addresses for each transaction, preserving privacy by preventing address reuse. HD wallets simplify backup processes by requiring users to save only the initial seed phrase</p>

<h2>Features</h2>
<ul>
  <li>Create and restore wallets using a BIP39 mnemonic.</li>
  <li>Send and receive Bitcoin.</li>
  <li>View transaction history and details.</li>
  <li>Access full transaction details on a third-party block explorer.</li>
</ul>

<h2>Setup Instructions</h2>

<h3>Prerequisites</h3>
<ul>
  <li>Flutter SDK installed</li>
  <li>Compatible IDE (e.g., Android Studio, Visual Studio Code)</li>
  <li>Bitcoin Core or a compatible Bitcoin wallet (for testnet)</li>
</ul>

<h3>Setting Up the Flutter Project</h3>
<ol>
  <li>Clone the Flutter Bitcoin Wallet Client repository:</li>
  <pre><code>
  git clone https://github.com/your-username/flutter-bitcoin-wallet.git
  </code></pre>
  
  <li>Navigate to the project directory:</li>
  <pre><code>
  cd flutter-bitcoin-wallet
  </code></pre>
  
  <li>Install project dependencies:</li>
  <pre><code>
  flutter pub get
  </code></pre>
</ol>

<h3>Configuration</h3>
<p>Configure the app to connect to your Bitcoin wallet:</p>
<ul>
  <li>Update the app settings to connect to your Bitcoin Core or compatible wallet (for testnet).</li>
</ul>

<h3>Running the Project</h3>
<ol>
  <li>Connect your device/emulator to run the app:</li>
  <pre><code>
  flutter run
  </code></pre>
</ol>

</body>
</html>
