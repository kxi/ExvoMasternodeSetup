## Exvo Masternode Installation

**NOTE:** This installation guide is provided as is with no warranties of any kind.

**NOTE:** This script does not ask for manually type in IP address. The only thing need you to interact is to type in your __Masternode Private Key__. It will create a 2GB swap file.


If you follow the steps and use a newly installed Ubuntu 16.04 VPS, it will automatically configure and start your Master Node. Other version of Ubuntu and other Linux distros are not currently supported.

Steps:

**0) Create a new VPS** or re-use existing one. Recommended VPS resource configuration is similar to the Vultr's $5/mo (25GB SSD/1xCPU/1GB RAM, Ubuntu 16.04).

**1)** In Windows wallet, **create a new receiving address** and name it **mn1** for example.

**2) Send exactly 7500 Exvo to this new address**. Make sure you select correct __inputs__ for each payment or __lock__ your 7500 coins manually after each payment using Coin Control Features, otherwise your coins may get reused and only last payment will yield valid masternode output. The wallet will lock your payments automatically after you restart it in step (6).

**3) View masternode outputs** - output transaction ID and transaction index in wallet Debug Console (Help -> Debug window) by typing:

```bash
walletpassphrase [your passphrase] 300
lockunspent true
masternode outputs
```

**4) Generate Masternode Private Key**

```bash
masternode genkey
```

Copy both masternode outputs and masternode private key somewhere safe. You will use these in the masternode.conf file for your wallet as well as setting up VPS later.

**5) Connect to your VPS server console** using PuTTY terminal program, login as root and clone the setup script and wallet binaries from github repository.
(NOTE: Currently this script repo contains Linux wallet binaries which are necessary to run master node on VPS.

To download (clone) the script and binaries to your VPS, use the following command in VPS Linux console:

```bash
cd ~
git clone https://github.com/kxi/ExvoMasternodeSetup.git
```

**6) Run the install script** which will install and configure your masternode with all necessary options.

```bash
cd ~/ExvoMasternodeSetup
chmod +x *.sh
./exvo-setup.sh
```

__NOTE:__ This process may take anywhere from 5 to 20 minutes, depending on your VPS HW specs. If it's not your very first ever masternode setup, you may want to speed up the process by doing things in parallel. While the MN setup script is running on the VPS, you can spend this time getting ready to start your new masternode from your Hot Wallet (also referred to as Control Wallet) by following instructions in next step (6).

The script can automatically detect your VPS Public IP Address. It will ask you to input Masternode Private Key which it generated in Step 4.

**7) Prepare your Hot Wallet and start the new masternode**. In this step you will introduce your new masternode to the Exvo network by issuing a masternode start command from your wallet, which will broadcast information proving that
the collateral for this masternode is secured in your wallet. Without this step your new masternode will function as a regular Exvo node (wallet) and will not yield any rewards. Usually you keep your Hot Wallet on your Windows machine where you securely store your funds for the MN collateral.

Basically all you need to do is just edit the __masternode.conf__ text file located in your hot wallet __data directory__ to enter a few masternode parameters, restart the wallet and then issue a start command for this new masternode.

There are two ways to edit __masternode.conf__. The easiest way is to open the file from within the wallet app (Help -> Show Masternode Conf File). Optionally, you can open it from the wallet data folder directly by navigating to the %appdata%/roaming/exvo. Just hit Win+R, paste %appdata%/roaming/exvo, hit Enter and then open **masternode.conf** with Notepad for editing.

It does not matter which way you open the file or how you edit it. In either case you will need to restart your wallet when you are done in order for it to pickup the changes you made in the file. Make sure to save it before you restart your wallet.

__Here's what you need to do in masternode.conf file__. For each masternode you are going to setup, you need to enter one separate line of text  which will look like this:

```bash
mn1 [IP]]:8585 7sPfzySd3WKKBTKwA2aaPHmgXk7Pw4DjNxtP9RP7378jmB6bfAD 59c25d4b31b573bc78cb2369667e58bc13d6d092d2c30eeffa2dcaad86119536 1 0
```

The format for this string is as follow:
```bash
masternodealias publicipaddress:8585 masternodeprivatekey output-tx-ID output-tx-index
```

__Here's what you need to do in exvo.conf file__ (Windows Wallet)
```bash
rpcuser=
rpcpassword=
rpcallowip=127.0.0.1
```

Finally, you need to either __restart__ the wallet app, unlock it with your encryption password. At this point the wallet app will read your __masternode.conf__ file and populate the Masternodes tab. Newly added nodes will show up as MISSING, which is normal.

Todo so you can either run a simple command in Debug Console (Help -> Debug window):

```bash
walletpassphrase [your passphrase] 300
lockunspent true
masternode start-alias [masternodename]
```

Example:
```bash
masternode start-alias mn1
```

Or, as an alternative, you can issue a start broadcast from the wallet Masternodes tab by right-clicking on the node:

```bash
Masternodes -> Select masternode -> RightClick -> start alias
```

Go back to your VPS and wait for the status of your new masternode to change to "Masternode successfully started". This may take some time and you may need to wait for several hours until your new masternode completes sync process.

Finally, to **monitor your masternode status** you can use the following commands in Linux console of your masternode VPS:

```bash
cd ~/ExvoMasternodeSetup
./mn_check.sh
```





If you found this script and masternode setup guide helpful...

... please consider tipping me Exvo to: **ENbQLq2Tiyv1jejwKDhCwPAc68sHzvYquM**.
