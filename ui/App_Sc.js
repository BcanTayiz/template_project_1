//Burada chian değiştirme kodunu da ekledik.

import React, { useEffect, useState } from "react";
import "./App.css";
import web3 from "web3";

const App = () => {
  const [currentAccount, setCurrentAccount] = useState("");

  const checkIfWalletIsConnected = async () => {
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Make sure you have metamask!");
      return;
    } else {
      console.log("We have the ethereum object", ethereum);
    }

    const accounts = await ethereum.request({ method: 'eth_accounts' });

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account)
    } else {
      console.log("No authorized account found")
    }
  }

  /*
  * Implement your connectWallet method here
  */
  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        alert("Get MetaMask!");
        return;
      }

      /*
      * Fancy method to request access to account.
      */
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });

      /*
      * Boom! This should print out public address once we authorize Metamask.
      */
      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]); 
    } catch (error) {
      console.log(error)
    }

    //Polygon ağına geçme talebi
    const chainId = 137 // Polygon Mainnet

if (window.ethereum.networkVersion !== chainId) {
      try {
        await window.ethereum.request({
          method: 'wallet_switchEthereumChain',
          params: [{ chainId: web3.utils.toHex(chainId) }]
        });
      } catch (err) {
          // This error code indicates that the chain has not been added to MetaMask
        if (err.code === 4902) {
          await window.ethereum.request({
            method: 'wallet_addEthereumChain',
            params: [
              {
                chainName: 'Polygon Mainnet',
                chainId: web3.utils.toHex(chainId),
                nativeCurrency: { name: 'MATIC', decimals: 18, symbol: 'MATIC' },
                rpcUrls: ['https://polygon-rpc.com/']
              }
            ]
          });
        }
      }
    }
    //Polygon ağına geçme talebi bitti
  }

  

  // Render Methods
  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="cta-button connect-wallet-button">
      Connect to Wallet
    </button> 
    
  );

  useEffect(() => {
    checkIfWalletIsConnected();
  }, [])

 

  return (
    <div className="App">
    <div className="container">
    <div className="header-container">
      <table>
        <tr>
          <td><p className="header gradient-text">NFT FLAG GAME | </p></td> 
          <td> <p className="sub-text">
            Your Pixel Your National Flag     <br></br>
            Your National Flag Your Wealth 
        </p>
        </td>
        <td><p className="header gradient-text">| </p></td> 
          <td>| {currentAccount === "" ? (
            renderNotConnectedContainer()
          ) : (
            <button onClick={null} className="cta-button connect-wallet-button">
              You are connected ! 
            </button> 
            
          )}

          </td>
        </tr>
      </table>
     
        
       
        
        
      </div>
       
      </div>
    </div>
  );
};

export default App;
