import { createSlice } from '@reduxjs/toolkit'
/* Değişen kare fiyatlarını belirtmek için global veri olarak kullanabilecek slice*/
export const PriceChangeSlice = createSlice({
  name: 'priceChange',
  initialState: {
    value: 0.0001
  },
  reducers: {
    priceAssign: (state, action) => {
      state.value = state.value + 0.00001 /* değeri bu şekilde belirledim değişebilir*/
    },
  },
})

// Action creators are generated for each case reducer function
export const {priceAssign} = PriceChangeSlice.actions

export default PriceChangeSlice.reducer