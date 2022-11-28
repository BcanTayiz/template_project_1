import { configureStore } from '@reduxjs/toolkit'

import selectCountry from '../features/selectCountry/selectCountry'
import priceChange from '../features/priceSquare/priceSquare'
import buyCount from '../features/buyCount/buyCount'
import credit from '../features/credit/credit'

export default configureStore({
  reducer: {selectCountry,priceChange,buyCount,credit},
})