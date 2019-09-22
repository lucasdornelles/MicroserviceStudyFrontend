import React from 'react';
import ProductForm from './ProductForm';
import logo from './logo.svg';
import './App.css';


function IsProductionCode(props) {
  const developmentEnv = process.env.NODE_ENV === 'development';
  if (developmentEnv){
    return <p>development</p>;
  } else{
    return <p>production</p>;
  }
}

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <IsProductionCode />
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
        <ProductForm />
      </header>
    </div>
  );
}

export default App;
