import React,{useState,useEffect} from 'react'
import './dashboard.css'


/* React dropdown npm içinden indirip bu yapıyı kullandım */
import Dropdown from 'react-dropdown';
import 'react-dropdown/style.css';

/* Country Flag için gerekli kütüphane */
import { US,GR,TR } from 'country-flag-icons/react/3x2'

import { select} from '../../features/selectCountry/selectCountry';
import {priceAssign} from '../../features/priceSquare/priceSquare'
import {assignBuyCount} from '../../features/buyCount/buyCount';
import { assignCredit } from '../../features/credit/credit';
import {useSelector,useDispatch} from 'react-redux'

  

export default function Dashboard() {
  const dispatch = useDispatch()
  /* Dashboard üzerinde kullanılan state bilgilerini bu şekilde çekiyorum */
  const selectCountry = useSelector((state) => state.selectCountry.value)
  const priceSelected = useSelector((state) => state.priceChange.value)
  const buyCountValue = useSelector((state) => state.buyCount.value)
  const creditValue = useSelector((state) => state.credit.value)
  const [buyCountState,setBuyCountState] = useState(0)
  const [country,setCountry] = useState('')
    

  /* Options kısmında bayrakların gözükmesi için option içinde bu şekilde kullandım */
    const options = [
      <US title="US" className="..."/>,
      <TR title="TR" className='...'/>,
      <GR title="GR" className="..."/>
  ];

  useEffect(() => {
    /* Dashboard üzerinde kullanılan state bilgilerini bu şekilde çekiyorum */
    dispatch(assignCredit(100))
  }, []);

  var defaultOption = options[0];

  const handleBuyValueChange = (event) => {
    setBuyCountState(event.target.value)
  }

  const handleBuy = () => {
    dispatch(select(country))
    dispatch(assignBuyCount(buyCountState))
    
    if(country !== ''){
      dispatch(priceAssign())
    }
    
  }

  const onSelect = (event) => {
    console.log(event)
    setCountry(event.value)
  }
  
  return (
    <div className='dashboard'>
        <header>
            <h2> Dashboard</h2>
        </header>
        <main className='main-section'>
            <section>
                <h2>Price</h2>
            </section>
            <section>
            <Dropdown options={options} onChange={onSelect} value={defaultOption} placeholder="Select an option" className='dropdown' />
            </section>
            <section onClick={handleBuy}>
                <h2>Buy</h2>
                <aside>
                  <input type="number" onChange={handleBuyValueChange}/>
                </aside>
                <section>
                  <div className='dashboard-values'>
                    Selected Country: {selectCountry}
                  </div>
                <br/>
                  <div className='dashboard-values'>
                    Price of Square: {priceSelected}
                  </div>
                
                <br/>
                  <div className='dashboard-values'>
                   Buy Count Value: {buyCountValue}
                  </div>
                
                <br/>
                  <div className='dashboard-values'>
                    Credit Value: {creditValue}
                  </div>
                
                </section>
                
                
            </section>
        </main>
       
    </div>
  )
}
