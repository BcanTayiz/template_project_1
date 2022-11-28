import React, { useEffect, useState } from "react";
import "./App.css";

import Dashboard from "./components/Dashboard/Dashboard";
import GridTemplate from "./components/GridTemplate/GridTemplate";
import Footer from "./components/Footer/Footer";

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

  /*
  * Added a conditional render! We don't want to show Connect to Wallet if we're already conencted :).
  */
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
          )}</td>
        </tr>
      </table>
     
        {/* Grid Template'in ve Dashboardun olduğu alan. Burayı main olarak aldım, index.css içinde değiştirmeye aldım*/}
       <main className="main-field">
         <section className='grid-component'>
          <GridTemplate  />
         </section>
        <section className='dashboard-component'>
          <Dashboard  />        
        </section>
         
       </main>

       
        
        
      </div>
       
      </div>

      <footer>
        <Footer />
       </footer>
    </div>
  );
};

export default App;
