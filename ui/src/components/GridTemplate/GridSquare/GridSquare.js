import React, { useRef,useState} from 'react'
import {useDispatch,useSelector} from 'react-redux'
import { priceAssign } from '../../../features/priceSquare/priceSquare'
import { assignBuyCount } from '../../../features/buyCount/buyCount'
import { assignCredit } from '../../../features/credit/credit'
import { US,GR,TR } from 'country-flag-icons/react/3x2'


// Represents a grid square with a color
import './gridSquare.css'

export default function GridSquare(props) { 
 const selectCountry = useSelector((state) => state.selectCountry.value)
 const buyCountValue = useSelector((state) => state.buyCount.value)
 const creditValue = useSelector((state) => state.credit.value)
 const priceValue = useSelector((state) => state.priceChange.value)
 const [flag,setFlag] = useState()
 const dispatch = useDispatch()
 const changeİnnerText = useRef()



 const handleFlag = (flagProp) => {
  console.log(flagProp)
  switch(flagProp) {
    case 'US':
      return <US title="US" className="grid-square"/>
    case 'TR':
      return <TR title="TR" className='grid-square'/>
    case 'GR':
      return <GR title="GR" className="grid-square"/>
    default:
      return <TR title="TR" className='grid-square'/>
  }
 }

 const handleSelectSquare = () => {
  
    if(buyCountValue > 0){
      console.log(selectCountry)
      dispatch(assignBuyCount(buyCountValue - 1))
      dispatch(priceAssign())
      dispatch(assignCredit(creditValue - priceValue))
      setFlag(selectCountry)
    }
    
    
 }

  /* flag kısmını bu şekilde döndürdüm fakat liste olarak statik olarak durması için redux kullanılması gerekebilir*/
  const classes = `grid-square color-${props.color}`
  /*if(flag !== ''){
   return <div className={classes} > {selectCountry}</div>
  }else{ }*/
    return <div className={classes} onClick={handleSelectSquare} ref={changeİnnerText}/>
  
  
  
  
}